package com.languageapp.language_learning_backend.dto.user;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class RegisterRequest {
    @NotBlank @Email                   private String email;
    @NotBlank @Size(min = 8, max = 50) private String password;
    @NotBlank @Size(min = 1, max = 50) private String firstName;
    @Size(max = 50)                    private String lastName;
    @NotBlank @Size(min = 10, max = 25) private String phone;
}
