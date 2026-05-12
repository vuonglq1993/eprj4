package com.languageapp.language_learning_backend.dto.user;

import lombok.*;

import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserProfileResponse {
    private UUID          id;
    private String        email;
    private String        firstName;
    private String        lastName;
    private String        avatarUrl;
    private String        role;
    private String        provider;
    private Boolean       emailVerified;
    private Boolean       isActive;
    private Instant createdAt;
    private String        subscriptionPlan;
    private Boolean       isPremium;
    private String    uiLanguage;
    private Boolean   hasPassword;
    private String    phone;
    private String    gender;
    private LocalDate dateOfBirth;
    private String    country;
    private String    timezone;
    private String    bio;
}
