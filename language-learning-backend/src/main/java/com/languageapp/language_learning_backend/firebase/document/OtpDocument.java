package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;
import java.time.Instant;

/**
 * Firestore Document cho OTP
 * Collection: otps
 * Document ID: {email}_{type}
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OtpDocument {
    private String email;
    private String otp;
    private String type;        // VERIFICATION, RESET_PASSWORD
    private Instant createdAt;
    private Instant expiresAt;
    private boolean used;
    private int attempts;
}