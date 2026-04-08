package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.UUID;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "users", indexes = {
        @Index(name = "idx_users_email",    columnList = "email"),
        @Index(name = "idx_users_provider", columnList = "provider,provider_id")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class User {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @Column(unique = true, nullable = false, length = 100)
    private String email;

    @Column(length = 255)
    private String password;           // null nếu OAuth2

    @Column(length = 25)
    private String phone;

    @Column(nullable = false, length = 50)
    private String firstName;

    @Column(length = 50)
    private String lastName;

    @Column(length = 500)
    private String avatarUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private Role role = Role.STUDENT;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private AuthProvider provider = AuthProvider.LOCAL;

    @Column(length = 100)
    private String providerId;         // Google/Facebook user ID

    @Column(nullable = false) @Builder.Default private Boolean emailVerified = false;
    @Column(nullable = false) @Builder.Default private Boolean isActive      = true;

    @Column(length = 10) @Builder.Default
    private String uiLanguage = "vi";

    @CreationTimestamp @Column(updatable = false) private Instant createdAt;
    @UpdateTimestamp private Instant updatedAt;

    // Quan hệ — lazy để tránh N+1
    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Subscription subscription;

    public enum Role         { STUDENT, TEACHER, ADMIN }
    public enum AuthProvider { LOCAL, GOOGLE, FACEBOOK, APPLE }

    public String  getFullName() { return firstName + (lastName != null ? " " + lastName : ""); }
    public boolean isPremium()   { return subscription != null && subscription.isPremium(); }
}
