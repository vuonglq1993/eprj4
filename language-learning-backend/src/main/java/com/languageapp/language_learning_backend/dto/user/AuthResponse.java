package com.languageapp.language_learning_backend.dto.user;

import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class AuthResponse {
    private String   accessToken;
    private String   refreshToken;
    private String   tokenType = "Bearer";
    private Long     expiresIn;
    private UserInfo user;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class UserInfo {
        private UUID   id;
        private String email;
        private String firstName;
        private String lastName;
        private String phone;
        private String avatarUrl;
        private String role;
    }
}
