package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.*;
import lombok.*;
import java.util.Map;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class NotificationRequest {
    @NotBlank
    private String title;

    @NotBlank
    private String body;

    private String type; // STUDY_REMINDER, ACHIEVEMENT, SYSTEM

    private Map<String, String> data;
}