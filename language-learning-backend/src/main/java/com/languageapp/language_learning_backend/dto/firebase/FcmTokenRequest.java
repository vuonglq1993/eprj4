package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FcmTokenRequest {

    @NotBlank
    private String token;

    @NotBlank
    private String deviceType; // ANDROID | IOS | WEB
}