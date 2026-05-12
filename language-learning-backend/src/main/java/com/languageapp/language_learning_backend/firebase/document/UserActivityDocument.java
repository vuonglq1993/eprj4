package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;
import java.time.Instant;
import java.util.Map;

/**
 * Firestore Document cho User Activities (Analytics)
 * Collection: user_activities
 * Document ID: auto-generated
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserActivityDocument {
    private String userId;
    private String activityType;    // LOGIN, LESSON_COMPLETE, EXERCISE_SUBMIT
    private Instant timestamp;
    private Map<String, Object> metadata;
}