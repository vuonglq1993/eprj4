package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class FcmTokenRequest {
    @NotBlank(message = "FCM token không được để trống")
    private String token;

    @NotBlank(message = "Device type không được để trống")
    @Pattern(regexp = "ANDROID|IOS|WEB", message = "Device type phải là ANDROID, IOS hoặc WEB")
    private String deviceType;
}