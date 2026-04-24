package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;
import java.time.Instant;

/**
 * Firestore Document cho FCM Tokens
 * Collection: fcm_tokens
 * Document ID: {userId}_{deviceType}
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class FcmTokenDocument {
    private String userId;
    private String token;
    private String deviceType;  // ANDROID, IOS, WEB
    private Instant createdAt;
    private Instant lastUsedAt;
    private boolean active;
}