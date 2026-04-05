package com.languageapp.language_learning_backend.dto.user;

import jakarta.validation.constraints.Size;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UpdateProfileRequest {
    @Size(min = 1, max = 50) private String firstName;
    @Size(max = 50)          private String lastName;
    @Size(max = 500)         private String avatarUrl;
    @Size(min = 2, max = 10) private String uiLanguage;

}
