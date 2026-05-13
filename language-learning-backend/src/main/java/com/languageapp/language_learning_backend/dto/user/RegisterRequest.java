package com.languageapp.language_learning_backend.dto.user;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class RegisterRequest {
    @NotBlank @Email                   private String email;
    @NotBlank @Size(min = 8, max = 50)
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d).+$", message = "Password must contain at least one letter and one number")
    private String password;
    @NotBlank @Size(min = 1, max = 50) private String firstName;
    @Size(max = 50)                    private String lastName;
    @NotBlank @Size(min = 10, max = 25) private String phone;
}
