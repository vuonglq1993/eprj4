package com.languageapp.language_learning_backend.dto.firebase;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OtpRequest {
    @NotBlank
    @Email(message = "Email không hợp lệ")
    private String email;

    @NotBlank
    @Pattern(regexp = "\\d{6}", message = "OTP phải là 6 chữ số")
    private String otp;

    @NotBlank
    @Pattern(regexp = "VERIFICATION|RESET_PASSWORD", message = "Type không hợp lệ")
    private String type;
}