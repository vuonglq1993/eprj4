package com.languageapp.language_learning_backend.dto.firebase;

import lombok.*;
import java.time.Instant;
import java.util.Map;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class NotificationResponse {
    private String userId;
    private String title;
    private String body;
    private String type;
    private Instant sentAt;
    private boolean read;
    private Map<String, String> data;
}