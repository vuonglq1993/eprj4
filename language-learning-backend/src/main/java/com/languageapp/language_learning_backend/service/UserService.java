package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.user.*;
import com.languageapp.language_learning_backend.entity.PasswordHistory;
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
    private final PasswordHistoryRepository passwordHistoryRepo;
    private final PasswordEncoder encoder;
    private final EmailService emailService;
    private final FirebaseOtpRepository otpRepository;
    private final JwtTokenProvider jwt;
    private final com.languageapp.language_learning_backend.security.JwtBlacklistService jwtBlacklist;

    private static final int PASSWORD_HISTORY_LIMIT = 2;

    // ── REGISTER ───────────────────────────────────────────────
    @Transactional
    public void register(RegisterRequest req) {
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

        if (Boolean.FALSE.equals(user.getEmailVerified()))
            throw new ForbiddenException("email_not_verified");

        return buildTokens(user);
    }

    // ── REFRESH TOKEN ─────────────────────────────────────────
    @Transactional(readOnly = true)
    public AuthResponse refresh(String refreshToken) {
        if (!jwt.validate(refreshToken))
            throw new UnauthorizedException("Invalid refresh token");
        if (!jwt.isRefreshToken(refreshToken))
            throw new UnauthorizedException("Not a refresh token");

        String jti = jwt.getJti(refreshToken);
        if (jwtBlacklist.isBlacklisted(jti))
            throw new UnauthorizedException("Refresh token has been revoked");

        UUID userId = jwt.getUserId(refreshToken);
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new UnauthorizedException("User not found"));
        if (!user.getIsActive())
            throw new UnauthorizedException("Account is disabled");

        return buildTokens(user);
    }

    // ── LOGOUT ────────────────────────────────────────────────
    public void logout(String accessToken, String refreshToken) {
        blacklistToken(accessToken);
        if (refreshToken != null && !refreshToken.isBlank()) {
            blacklistToken(refreshToken);
        }
    }

    private void blacklistToken(String token) {
        try {
            if (jwt.validate(token)) {
                String jti = jwt.getJti(token);
                long remaining = jwt.getRemainingSeconds(token);
                if (remaining > 0) jwtBlacklist.blacklist(jti, remaining);
            }
        } catch (Exception e) {
            log.warn("Blacklist token failed: {}", e.getMessage());
        }
    }

    public boolean existsByEmail(String email) {
        return userRepo.existsByEmail(email);
    }

    public boolean existsByPhone(String phone) {
        return userRepo.existsByPhone(phone);
    }

    // ── VERIFY EMAIL ──────────────────────────────────────────
    @Transactional
    public void verifyEmail(String email, String otp) throws Exception {
        OtpDocument doc = otpRepository.findByEmailAndType(email, "VERIFY_EMAIL")
                .orElseThrow(() -> new BadRequestException("OTP not found"));

        if (doc.isUsed())
            throw new BadRequestException("OTP already used");
        if (doc.getExpiresAt().isBefore(Instant.now()))
            throw new BadRequestException("OTP expired");
        if (!doc.getOtp().equals(otp))
            throw new BadRequestException("Invalid OTP");

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User not found"));
        user.setEmailVerified(true);
        userRepo.save(user);
        otpRepository.markAsUsed(email, "VERIFY_EMAIL");
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
    public void resetPassword(String email, String otp, String newPassword) throws Exception {
        OtpDocument doc = otpRepository.findByEmailAndType(email, "RESET_PASSWORD")
                .orElseThrow(() -> new BadRequestException("OTP not found"));

        if (doc.isUsed())
            throw new BadRequestException("OTP already used");
        if (doc.getExpiresAt().isBefore(Instant.now()))
            throw new BadRequestException("OTP expired");
        if (!doc.getOtp().equals(otp))
            throw new BadRequestException("Invalid OTP");

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User not found"));
        checkPasswordHistory(user.getId(), newPassword);
        savePasswordHistory(user.getId(), user.getPassword());
        user.setPassword(encoder.encode(newPassword));
        userRepo.save(user);
        otpRepository.markAsUsed(email, "RESET_PASSWORD");
        log.info("Password reset success for {}", email);
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

        if (req.getDisplayName() != null) user.setFirstName(req.getDisplayName());
        if (req.getFirstName()   != null) user.setFirstName(req.getFirstName());
        if (req.getLastName()    != null) user.setLastName(req.getLastName());
        if (req.getAvatarUrl()   != null) user.setAvatarUrl(req.getAvatarUrl());
        if (req.getUiLanguage()  != null) user.setUiLanguage(req.getUiLanguage());
        if (req.getPhone()       != null) user.setPhone(req.getPhone());
        if (req.getGender()      != null) user.setGender(req.getGender());
        if (req.getDateOfBirth() != null) user.setDateOfBirth(req.getDateOfBirth());
        if (req.getCountry()     != null) user.setCountry(req.getCountry());
        if (req.getTimezone()    != null) user.setTimezone(req.getTimezone());
        if (req.getBio()         != null) user.setBio(req.getBio());

        return toProfileResponse(userRepo.save(user));
    }

    // ── CHANGE PASSWORD ──────────────────────────────────────
    @Transactional
    public void changePassword(ChangePasswordRequest req, UserPrincipal principal) {
        User user = findUser(principal.getUserId());

        if (user.getPassword() == null) {
            // Google-only user setting password for the first time — skip current password check
            if (req.getCurrentPassword() != null)
                throw new BadRequestException("Account has no password set");
        } else {
            if (req.getCurrentPassword() == null)
                throw new BadRequestException("Current password is required");
            if (!encoder.matches(req.getCurrentPassword(), user.getPassword()))
                throw new BadRequestException("Current password is incorrect");
        }

        checkPasswordHistory(user.getId(), req.getNewPassword());

        savePasswordHistory(user.getId(), user.getPassword());
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
        passwordHistoryRepo.deleteByUserId(userId);

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
                .phone(u.getPhone())
                .gender(u.getGender())
                .dateOfBirth(u.getDateOfBirth())
                .country(u.getCountry())
                .timezone(u.getTimezone())
                .bio(u.getBio())
                .build();
    }

    private void checkPasswordHistory(UUID userId, String newRawPassword) {
        List<PasswordHistory> recent = passwordHistoryRepo.findRecentByUserId(
                userId, PageRequest.of(0, PASSWORD_HISTORY_LIMIT));
        for (PasswordHistory h : recent) {
            if (encoder.matches(newRawPassword, h.getPasswordHash()))
                throw new BadRequestException(
                        "New password must not match the last " + PASSWORD_HISTORY_LIMIT + " passwords");
        }
    }

    private void savePasswordHistory(UUID userId, String currentHashedPassword) {
        if (currentHashedPassword == null) return;
        passwordHistoryRepo.save(PasswordHistory.builder()
                .userId(userId)
                .passwordHash(currentHashedPassword)
                .build());
        // Giữ tối đa PASSWORD_HISTORY_LIMIT bản ghi, xóa bản cũ hơn
        List<PasswordHistory> all = passwordHistoryRepo.findRecentByUserId(
                userId, PageRequest.of(0, Integer.MAX_VALUE));
        if (all.size() > PASSWORD_HISTORY_LIMIT) {
            List<PasswordHistory> toDelete = all.subList(PASSWORD_HISTORY_LIMIT, all.size());
            passwordHistoryRepo.deleteAll(toDelete);
        }
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
