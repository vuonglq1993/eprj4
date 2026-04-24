package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationRequest {

    @NotBlank
    private String userId; // gửi theo user

    @NotBlank
    private String title;

    @NotBlank
    private String body;

    private String imageUrl; // optional
}