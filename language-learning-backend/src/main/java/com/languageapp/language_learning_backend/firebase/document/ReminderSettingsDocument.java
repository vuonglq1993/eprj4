package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;

/**
 * Firestore Document: reminder_settings/{userId}
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ReminderSettingsDocument {
    private String userId;
    private boolean enabled;
    private int hour;
    private int minute;
    private String timezone;
    private String lastSentDate; // "yyyy-MM-dd" in user's timezone
}
