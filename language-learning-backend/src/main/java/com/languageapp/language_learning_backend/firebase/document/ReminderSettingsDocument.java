package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;

/**
 * Firestore Document: reminder_settings/{userId}
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ReminderSettingsDocument {
    private String userId;
    private boolean enabled;
    private int hour;           // 0-23
    private int minute;         // 0 or 30
    private String timezone;    // "Asia/Ho_Chi_Minh"
}
