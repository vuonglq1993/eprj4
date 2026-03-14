package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.user.*;
import com.languageapp.language_learning_backend.entity.User;
import com.languageapp.language_learning_backend.repository.UserRepository;
import com.languageapp.language_learning_backend.security.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.entity.User.Role;
import com.languageapp.language_learning_backend.entity.User.AuthProvider;
import java.util.UUID;
import com.languageapp.language_learning_backend.security.UserPrincipal;
@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepo;
    private final PasswordEncoder encoder;

    // TODO enable JWT when authentication module is fully configured
    // private final JwtTokenProvider jwt;

    private final StringRedisTemplate redis;

    // TODO enable email OTP verification later
    // private final EmailService emailService;

    // Redis keys (currently unused)
    // private static final String REFRESH = "refresh:";
    // private static final String OTP_VER = "otp:verify:";
    // private static final String OTP_RST = "otp:reset:";

    // ── REGISTER ──────────────────────────────────────────────
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

        /*
        // Generate OTP for email verification
        String otp = otp6();

        // Store OTP in Redis (5 minutes)
        redis.opsForValue().set(OTP_VER + user.getEmail(), otp, Duration.ofMinutes(5));

        // Send verification email
        emailService.sendVerification(user.getEmail(), otp);
        */

        return buildTokens(user);
    }

    // ── LOGIN ──────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest req) {

        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Invalid credentials"));

        if (!user.getIsActive())
            throw new UnauthorizedException("Account is disabled");

        if (user.getProvider() != AuthProvider.LOCAL)
            throw new BadRequestException("Please login with " + user.getProvider().name().toLowerCase());

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

    // ── LOGOUT (DISABLED) ─────────────────────────────────────
    public void logout(UUID userId) {

        /*
        redis.delete(REFRESH + userId);
        */

        log.warn("Logout called but refresh-token system is disabled");
    }

    // ── VERIFY EMAIL (DISABLED) ───────────────────────────────
    @Transactional
    public void verifyEmail(String email, String otp) {

        /*
        String stored = redis.opsForValue().get(OTP_VER + email);

        if (stored == null || !stored.equals(otp))
            throw new BadRequestException("Invalid or expired OTP");

        userRepo.findByEmail(email).ifPresent(u -> {
            u.setEmailVerified(true);
            userRepo.save(u);
        });

        redis.delete(OTP_VER + email);
        */

        throw new UnsupportedOperationException("Email verification is currently disabled");
    }

    // ── FORGOT PASSWORD (DISABLED) ────────────────────────────
    public void forgotPassword(String email) {

        /*
        userRepo.findByEmail(email)
                .filter(u -> u.getProvider() == AuthProvider.LOCAL)
                .ifPresent(u -> {

                    String otp = otp6();

                    redis.opsForValue().set(OTP_RST + email, otp, Duration.ofMinutes(5));

                    emailService.sendPasswordReset(email, otp);
                });
        */

        log.warn("Forgot password requested but OTP reset is disabled");
    }

    // ── RESET PASSWORD (DISABLED) ─────────────────────────────
    @Transactional
    public void resetPassword(String token, String newPassword) {

        /*
        String decoded = new String(java.util.Base64.getDecoder().decode(token));
        String[] parts = decoded.split(":", 2);

        if (parts.length != 2)
            throw new BadRequestException("Invalid token format");

        String email = parts[0];
        String otp = parts[1];

        String stored = redis.opsForValue().get(OTP_RST + email);

        if (stored == null || !stored.equals(otp))
            throw new BadRequestException("Invalid or expired OTP");

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User not found"));

        user.setPassword(encoder.encode(newPassword));
        userRepo.save(user);

        redis.delete(OTP_RST + email);
        redis.delete(REFRESH + user.getId());
        */

        throw new UnsupportedOperationException("Reset password feature is disabled");
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

    // JWT token creation (currently simplified)
    private AuthResponse buildTokens(User user) {

        /*
        String at = jwt.generateAccessToken(user.getId(), user.getEmail(), user.getRole().name());
        String rt = jwt.generateRefreshToken(user.getId());

        redis.opsForValue().set(REFRESH + user.getId(), rt,
                Duration.ofMillis(jwt.getRefreshExp()));
        */

        return AuthResponse.builder()
                .accessToken("disabled")
                .refreshToken("disabled")
                .expiresIn(0L)
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
                .build();
    }

    private String otp6() {
        return String.format("%06d", (int) (Math.random() * 1_000_000));
    }
}