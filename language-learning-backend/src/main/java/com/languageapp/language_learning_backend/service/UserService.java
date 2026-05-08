package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.user.*;
import com.languageapp.language_learning_backend.entity.User;
import com.languageapp.language_learning_backend.entity.User.Role;
import com.languageapp.language_learning_backend.entity.User.AuthProvider;
import com.languageapp.language_learning_backend.firebase.document.OtpDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseOtpRepository;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepo;
    private final SubscriptionRepository subRepo;
    private final CourseRepository courseRepo;
    private final LearningPathRepository lpRepo;
    private final ExerciseAttemptRepository attemptRepo;
    private final UserProgressRepository progressRepo;
    private final StudyLogRepository studyLogRepo;
    private final AIInteractionLogRepository aiLogRepo;
    private final PaymentTransactionRepository paymentRepo;
    private final DeviceTokenRepository deviceTokenRepo;
    private final UserOnboardingRepository onboardingRepo;
    private final UserLearningPathRepository ulpRepo;
    private final UserBadgeRepository badgeRepo;
    private final UserGameProfileRepository gameProfileRepo;
    private final PasswordEncoder encoder;
    private final EmailService emailService;
    private final FirebaseOtpRepository otpRepository;
    private final JwtTokenProvider jwt;

    // ── REGISTER ───────────────────────────────────────────────
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
            String otp = String.format("%06d", (int) (Math.random() * 1_000_000));
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
            log.error("Failed to send OTP", e);
        }

        return buildTokens(user);
    }

    // ── LOGIN ─────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest req) {
        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Invalid credentials"));

        if (!user.getIsActive())
            throw new UnauthorizedException("Account is disabled");

        if (user.getPassword() == null)
            throw new BadRequestException("no_password_set");

        if (!encoder.matches(req.getPassword(), user.getPassword()))
            throw new UnauthorizedException("Invalid credentials");

        return buildTokens(user);
    }

    // ── REFRESH TOKEN (DISABLED) ──────────────────────────────
    public AuthResponse refresh(String refreshToken) {
        throw new UnsupportedOperationException("Refresh token feature is disabled");
    }

    // ── LOGOUT ────────────────────────────────────────────────
    public void logout(UUID userId) {
        log.warn("Logout handled on client side (no Redis)");
    }

    // ── VERIFY EMAIL ──────────────────────────────────────────
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

    // ── FORGOT PASSWORD ──────────────────────────────────────
    public void forgotPassword(String email) {
        userRepo.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User not found"));

        try {
            String otp = String.format("%06d", (int) (Math.random() * 1_000_000));
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
            log.info("OTP reset password sent to {}", email);
        } catch (Exception e) {
            log.error("Failed to send reset OTP", e);
        }
    }

    // ── RESET PASSWORD ────────────────────────────────────────
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
            log.info("Password reset success for {}", email);
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

        if (req.getFirstName() != null)  user.setFirstName(req.getFirstName());
        if (req.getLastName() != null)   user.setLastName(req.getLastName());
        if (req.getAvatarUrl() != null)  user.setAvatarUrl(req.getAvatarUrl());
        if (req.getUiLanguage() != null) user.setUiLanguage(req.getUiLanguage());

        return toProfileResponse(userRepo.save(user));
    }

    // ── CHANGE PASSWORD ──────────────────────────────────────
    @Transactional
    public void changePassword(ChangePasswordRequest req, UserPrincipal principal) {
        User user = findUser(principal.getUserId());

        if (!encoder.matches(req.getCurrentPassword(), user.getPassword()))
            throw new BadRequestException("Current password is incorrect");

        if (encoder.matches(req.getNewPassword(), user.getPassword()))
            throw new BadRequestException("New password must be different from current password");

        user.setPassword(encoder.encode(req.getNewPassword()));
        userRepo.save(user);
    }

    // ── ADMIN: GET ALL USERS ──────────────────────────────────
    @Transactional(readOnly = true)
    public Page<UserResponse> getAllUsers(int page, int size) {
        Page<User> users = userRepo.findAll(PageRequest.of(page, size, Sort.by("createdAt").descending()));
        return users.map(u -> new UserResponse(
                u.getId(), u.getEmail(), u.getFirstName(), u.getLastName(),
                u.getAvatarUrl(),
                u.getRole() != null ? u.getRole().name() : "STUDENT",
                u.getIsActive(), u.getEmailVerified(), u.getCreatedAt()
        ));
    }

    // ── ADMIN: COUNT USERS ───────────────────────────────────
    @Transactional(readOnly = true)
    public long getUsersCount() {
        return userRepo.countAll();
    }

    // ── ADMIN: SEARCH USERS ───────────────────────────────────
    @Transactional(readOnly = true)
    public List<UserSearchResult> searchUsers(String query) {
        if (query == null || query.trim().isEmpty()) return List.of();

        return userRepo.findByEmailContainingIgnoreCase(query.trim()).stream()
                .limit(10)
                .map(u -> new UserSearchResult(
                        u.getId().toString(),
                        u.getEmail(),
                        (u.getFirstName() != null ? u.getFirstName() : "")
                                + " " + (u.getLastName() != null ? u.getLastName() : ""),
                        u.getRole() != null ? u.getRole().name() : "STUDENT"
                ))
                .toList();
    }

    // ── ADMIN: UPDATE ROLE ───────────────────────────────────
    @Transactional
    public String updateUserRole(UUID userId, String roleStr) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        Role role;
        try {
            role = Role.valueOf(roleStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new BadRequestException("Invalid role: " + roleStr);
        }

        user.setRole(role);
        userRepo.save(user);
        return role.name();
    }

    // ── ADMIN: DELETE USER ───────────────────────────────────
    @Transactional
    public void deleteUser(UUID userId) {
        userRepo.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        // Null-ify createdBy so FK constraint is satisfied
        courseRepo.findByCreatedById(userId).forEach(c -> {
            c.setCreatedBy(null);
            courseRepo.save(c);
        });
        lpRepo.findByCreatedById(userId).forEach(lp -> {
            lp.setCreatedBy(null);
            lpRepo.save(lp);
        });

        // Cascade delete all user-related records
        subRepo.findByUserId(userId).ifPresent(sub -> subRepo.delete(sub));
        attemptRepo.deleteByUserId(userId);
        progressRepo.deleteByUserId(userId);
        studyLogRepo.deleteByUserId(userId);
        aiLogRepo.deleteByUserId(userId);
        paymentRepo.deleteByUserId(userId);
        deviceTokenRepo.deleteByUserId(userId);
        onboardingRepo.deleteByUserId(userId);
        ulpRepo.deleteByUserId(userId);
        badgeRepo.deleteByUserId(userId);
        gameProfileRepo.findByUserId(userId)
                .ifPresent(gameProfileRepo::delete);

        userRepo.deleteById(userId);
    }

    // ── PRIVATE HELPERS ───────────────────────────────────────
    private User findUser(UUID id) {
        return userRepo.findById(id)
                .orElseThrow(() -> new NotFoundException("User not found"));
    }

    private AuthResponse buildTokens(User user) {
        String at = jwt.generateAccessToken(user.getId(), user.getEmail(), user.getRole().name());
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
                .role(u.getRole() != null ? u.getRole().name() : "STUDENT")
                .provider(u.getProvider() != null ? u.getProvider().name() : "LOCAL")
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

    // ── RECORDS ───────────────────────────────────────────────
    public record UserSearchResult(String id, String email, String name, String role) {}

    public record UserResponse(
            UUID id,
            String email,
            String firstName,
            String lastName,
            String avatarUrl,
            String role,
            Boolean isActive,
            Boolean emailVerified,
            Instant createdAt
    ) {}
}
