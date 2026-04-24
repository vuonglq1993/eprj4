package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.user.*;
import com.languageapp.language_learning_backend.entity.User;
import com.languageapp.language_learning_backend.firebase.document.OtpDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseOtpRepository;
import com.languageapp.language_learning_backend.repository.UserRepository;
import com.languageapp.language_learning_backend.security.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.entity.User.Role;
import com.languageapp.language_learning_backend.entity.User.AuthProvider;

import java.time.Instant;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final EmailService emailService;
    private final FirebaseOtpRepository otpRepository;
    private final JwtTokenProvider jwt;

    // TODO enable email OTP verification later
    // private final EmailService emailService;

    @Transactional
    public AuthResponse register(RegisterRequest req) {

        if (userRepo.existsByEmail(req.getEmail()))
            throw new ConflictException("Email already registered");

        User user = userRepo.save(User.builder()
                .email(req.getEmail())
                .password(encoder.encode(req.getPassword()))
                .firstName(req.getFirstName())
                .lastName(req.getLastName())
                .phone(req.getPhone())
                .role(Role.STUDENT)
                .provider(AuthProvider.LOCAL)
                .build());

        try {
            String otp = otp6();

            otpRepository.save(OtpDocument.builder()
                    .email(user.getEmail())
                    .otp(otp)
                    .type("VERIFY_EMAIL")
                    .createdAt(Instant.now())
                    .expiresAt(Instant.now().plusSeconds(300))
                    .used(false)
                    .attempts(0)
                    .build());

            emailService.sendVerificationOtp(user.getEmail(), otp);

        } catch (Exception e) {
            log.error("❌ Failed to send OTP", e);
        }

        return buildTokens(user);
    }

    // ── LOGIN ──────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest req) {

        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Invalid credentials"));

        if (!user.getIsActive())
            throw new UnauthorizedException("Account is disabled");

        // Google user chưa set password → không thể login bằng email
        if (user.getPassword() == null)
            throw new BadRequestException("no_password_set");

        if (!encoder.matches(req.getPassword(), user.getPassword()))
            throw new UnauthorizedException("Invalid credentials");

        return buildTokens(user);
    }

    // ── REFRESH TOKEN (DISABLED) ──────────────────────────────
    public AuthResponse refresh(String refreshToken) {

        /*
        if (!jwt.validate(refreshToken) || !jwt.isRefreshToken(refreshToken))
            throw new UnauthorizedException("Invalid refresh token");

        UUID userId = jwt.getUserId(refreshToken);

        if (!refreshToken.equals(redis.opsForValue().get(REFRESH + userId)))
            throw new UnauthorizedException("Token revoked or reused");

        User user = userRepo.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        redis.delete(REFRESH + userId);

        return buildTokens(user);
        */

        throw new UnsupportedOperationException("Refresh token feature is disabled");
    }

    // ── LOGOUT (CLIENT SIDE ONLY) ─────────────────────────────
    public void logout(UUID userId) {
        log.warn("Logout handled on client side (no Redis)");
    }

    @Transactional
    public void verifyEmail(String email, String otp) {

        try {
            OtpDocument doc = otpRepository.findByEmailAndType(email, "VERIFY_EMAIL")
                    .orElseThrow(() -> new BadRequestException("OTP not found"));

            if (doc.isUsed())
                throw new BadRequestException("OTP already used");

            if (!doc.getOtp().equals(otp))
                throw new BadRequestException("Invalid OTP");

            if (doc.getExpiresAt().isBefore(Instant.now()))
                throw new BadRequestException("OTP expired");

            User user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new NotFoundException("User not found"));

            user.setEmailVerified(true);
            userRepo.save(user);

            otpRepository.markAsUsed(email, "VERIFY_EMAIL");

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void forgotPassword(String email) {

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User not found"));

        try {
            String otp = otp6();

            otpRepository.save(OtpDocument.builder()
                    .email(email)
                    .otp(otp)
                    .type("RESET_PASSWORD")
                    .createdAt(Instant.now())
                    .expiresAt(Instant.now().plusSeconds(300))
                    .used(false)
                    .attempts(0)
                    .build());

            emailService.sendPasswordResetOtp(email, otp);

            log.info("✅ OTP reset password sent to {}", email);

        } catch (Exception e) {
            log.error("❌ Failed to send reset OTP", e);
        }
    }

    @Transactional
    public void resetPassword(String email, String otp, String newPassword) {

        try {
            OtpDocument doc = otpRepository.findByEmailAndType(email, "RESET_PASSWORD")
                    .orElseThrow(() -> new BadRequestException("OTP not found"));

            if (doc.isUsed())
                throw new BadRequestException("OTP already used");

            if (!doc.getOtp().equals(otp))
                throw new BadRequestException("Invalid OTP");

            if (doc.getExpiresAt().isBefore(Instant.now()))
                throw new BadRequestException("OTP expired");

            User user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new NotFoundException("User not found"));

            user.setPassword(encoder.encode(newPassword));
            userRepo.save(user);

            otpRepository.markAsUsed(email, "RESET_PASSWORD");

            log.info("✅ Password reset success for {}", email);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // ── GET PROFILE ───────────────────────────────────────────
    @Transactional(readOnly = true)
    public UserProfileResponse getProfile(UserPrincipal principal) {
        return toProfileResponse(findUser(principal.getUserId()));
    }

    // ── UPDATE PROFILE ────────────────────────────────────────
    @Transactional
    public UserProfileResponse updateProfile(UpdateProfileRequest req, UserPrincipal principal) {

        User user = findUser(principal.getUserId());

        if (req.getFirstName() != null)
            user.setFirstName(req.getFirstName());

        if (req.getLastName() != null)
            user.setLastName(req.getLastName());

        if (req.getAvatarUrl() != null)
            user.setAvatarUrl(req.getAvatarUrl());

        if (req.getUiLanguage() != null)
            user.setUiLanguage(req.getUiLanguage());

        return toProfileResponse(userRepo.save(user));
    }

    // ── CHANGE PASSWORD ───────────────────────────────────────
    @Transactional
    public void changePassword(ChangePasswordRequest req, UserPrincipal principal) {

        User user = findUser(principal.getUserId());

        if (!encoder.matches(req.getCurrentPassword(), user.getPassword()))
            throw new BadRequestException("Current password is incorrect");

        user.setPassword(encoder.encode(req.getNewPassword()));
        userRepo.save(user);
    }

    // ── HELPERS ───────────────────────────────────────────────
    private User findUser(UUID id) {
        return userRepo.findById(id)
                .orElseThrow(() -> new NotFoundException("User not found"));
    }

    // ✅ JWT WORKING
    private AuthResponse buildTokens(User user) {

        String at = jwt.generateAccessToken(
                user.getId(),
                user.getEmail(),
                user.getRole().name()
        );

        String rt = jwt.generateRefreshToken(user.getId());

        return AuthResponse.builder()
                .accessToken(at)
                .refreshToken(rt)
                .tokenType("Bearer")
                .expiresIn(900L)
                .user(AuthResponse.UserInfo.builder()
                        .id(user.getId())
                        .email(user.getEmail())
                        .firstName(user.getFirstName())
                        .lastName(user.getLastName())
                        .phone(user.getPhone())
                        .avatarUrl(user.getAvatarUrl())
                        .role(user.getRole().name())
                        .build())
                .build();
    }

    private UserProfileResponse toProfileResponse(User u) {

        return UserProfileResponse.builder()
                .id(u.getId())
                .email(u.getEmail())
                .firstName(u.getFirstName())
                .lastName(u.getLastName())
                .avatarUrl(u.getAvatarUrl())
                .role(u.getRole().name())
                .provider(u.getProvider().name())
                .emailVerified(u.getEmailVerified())
                .isActive(u.getIsActive())
                .createdAt(u.getCreatedAt())
                .subscriptionPlan(u.getSubscription() != null
                        ? u.getSubscription().getPlan().name()
                        : "FREE")
                .isPremium(u.isPremium())
                .uiLanguage(u.getUiLanguage())
                .build();
    }

    private String otp6() {
        return String.format("%06d", (int) (Math.random() * 1_000_000));
    }
}