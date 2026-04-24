package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpRequest {

    @NotBlank
    @Email
    private String email;

    @NotBlank
    private String type; // VERIFY_EMAIL | RESET_PASSWORD
}