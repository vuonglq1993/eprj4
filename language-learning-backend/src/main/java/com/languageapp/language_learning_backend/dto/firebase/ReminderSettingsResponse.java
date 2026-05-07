package com.languageapp.language_learning_backend.dto.firebase;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ReminderSettingsResponse {
    private boolean enabled;
    private int hour;
    private int minute;
    private String timezone;
}
