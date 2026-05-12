package com.languageapp.language_learning_backend.dto.firebase;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class FcmTokenResponse {
    private String message;
    private String userId;
    private String deviceType;
    private boolean success;
}