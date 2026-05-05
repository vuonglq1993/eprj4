package com.languageapp.language_learning_backend.dto.firebase;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OtpResponse {
    private String message;
    private boolean success;
    private String email;
    private Integer expiresInMinutes;
}