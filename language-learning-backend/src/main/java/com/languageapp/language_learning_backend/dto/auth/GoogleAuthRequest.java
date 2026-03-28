package com.languageapp.language_learning_backend.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class GoogleAuthRequest {
    @NotBlank
    private String idToken;   // token lấy từ Google Sign-In SDK (Android/Web)
}
