package com.languageapp.language_learning_backend.dto.user;

import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDate;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UpdateProfileRequest {
    @Size(max = 100)          private String    displayName;
    @Size(min = 1, max = 50)  private String    firstName;
    @Size(max = 50)           private String    lastName;
    @Size(max = 500)          private String    avatarUrl;
    @Size(min = 2, max = 10)  private String    uiLanguage;
    @Size(max = 25)           private String    phone;
    @Size(max = 10)           private String    gender;
    private LocalDate                           dateOfBirth;
    @Size(max = 100)          private String    country;
    @Size(max = 50)           private String    timezone;
    @Size(max = 300)          private String    bio;
}
