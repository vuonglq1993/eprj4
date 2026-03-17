package com.languageapp.language_learning_backend.dto.language;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LanguageRequest {
    @NotBlank @Size(min=2, max=10) private String  code;
    @NotBlank @Size(max=100)       private String  name;
    @NotBlank @Size(max=100)       private String  nativeName;
    @Size(max=20)                  private String  flag;
    private Boolean isActive = true;
}
