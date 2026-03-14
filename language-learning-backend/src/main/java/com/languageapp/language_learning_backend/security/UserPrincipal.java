package com.languageapp.language_learning_backend.security;
import lombok.*;
import java.util.UUID;

@Getter @AllArgsConstructor
public class UserPrincipal {
    private final UUID   userId;
    private final String email;
    private final String role;
}