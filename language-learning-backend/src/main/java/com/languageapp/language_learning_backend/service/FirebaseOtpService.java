package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.firebase.document.OtpDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseOtpRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Random;

@Slf4j
@Service
@RequiredArgsConstructor
public class FirebaseOtpService {

    private final FirebaseOtpRepository otpRepo;
    private final EmailService emailService;

    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRY_MINUTES = 5;
    private static final int MAX_ATTEMPTS = 3;

    // ══════════════════════════════════════════════
    // GENERATE & SEND OTP
    // ══════════════════════════════════════════════
    public void generateAndSendOtp(String email, String type) {
        try {
            String otp = generateOtp();

            OtpDocument doc = OtpDocument.builder()
                    .email(email)
                    .otp(otp)
                    .type(type)
                    .createdAt(Instant.now())
                    .expiresAt(Instant.now().plus(OTP_EXPIRY_MINUTES, ChronoUnit.MINUTES))
                    .used(false)
                    .attempts(0)
                    .build();

            otpRepo.save(doc);

            // Send email
            if ("VERIFICATION".equals(type)) {
                emailService.sendVerificationOtp(email, otp);
            } else if ("RESET_PASSWORD".equals(type)) {
                emailService.sendPasswordResetOtp(email, otp);
            }

            log.info("✅ OTP sent to {} for {}", email, type);

        } catch (Exception e) {
            log.error("❌ Failed to generate OTP: {}", e.getMessage());
            throw new RuntimeException("Failed to send OTP");
        }
    }

    // ══════════════════════════════════════════════
    // VERIFY OTP
    // ══════════════════════════════════════════════
    public boolean verifyOtp(String email, String otp, String type) {
        try {
            var optDoc = otpRepo.findByEmailAndType(email, type);

            if (optDoc.isEmpty()) {
                log.warn("⚠️ OTP not found for {}", email);
                return false;
            }

            OtpDocument doc = optDoc.get();

            // Checks
            if (doc.isUsed()) {
                log.warn("⚠️ OTP already used for {}", email);
                return false;
            }

            if (Instant.now().isAfter(doc.getExpiresAt())) {
                log.warn("⚠️ OTP expired for {}", email);
                return false;
            }

            if (doc.getAttempts() >= MAX_ATTEMPTS) {
                log.warn("⚠️ Max attempts reached for {}", email);
                return false;
            }

            if (!otp.equals(doc.getOtp())) {
                otpRepo.updateAttempts(email, type, doc.getAttempts() + 1);
                log.warn("⚠️ Invalid OTP for {}", email);
                return false;
            }

            // Mark as used
            otpRepo.markAsUsed(email, type);
            log.info("✅ OTP verified for {}", email);
            return true;

        } catch (Exception e) {
            log.error("❌ Failed to verify OTP: {}", e.getMessage());
            return false;
        }
    }

    // ══════════════════════════════════════════════
    // CLEANUP
    // ══════════════════════════════════════════════
    public void cleanupExpiredOtps() {
        try {
            int deleted = otpRepo.deleteExpired();
            log.info("🗑️ Cleaned up {} expired OTPs", deleted);
        } catch (Exception e) {
            log.error("❌ Failed to cleanup OTPs: {}", e.getMessage());
        }
    }

    private String generateOtp() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }
}