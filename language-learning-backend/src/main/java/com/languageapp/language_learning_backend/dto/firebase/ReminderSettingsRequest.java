package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.*;
import lombok.*;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ReminderSettingsRequest {
    private boolean enabled;

    @Min(0) @Max(23)
    private int hour;

    @Min(0) @Max(59)
    private int minute;

    private String timezone;
}
