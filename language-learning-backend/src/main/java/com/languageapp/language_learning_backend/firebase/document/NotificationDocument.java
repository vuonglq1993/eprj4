package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;
import java.time.Instant;
import java.util.Map;

/**
 * Firestore Document cho Notifications History
 * Collection: notifications
 * Document ID: auto-generated
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class NotificationDocument {
    private String userId;
    private String title;
    private String body;
    private String type;        // STUDY_REMINDER, ACHIEVEMENT, SYSTEM
    private Instant sentAt;
    private boolean read;
    private Map<String, String> data;
}