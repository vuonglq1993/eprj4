package com.languageapp.language_learning_backend.dto.user;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ChangePasswordRequest {
    private String currentPassword;   // nullable — Google user chưa có password bỏ qua
    @NotBlank @Size(min=8) private String newPassword;
}
