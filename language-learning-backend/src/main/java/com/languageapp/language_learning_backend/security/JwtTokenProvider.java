package com.languageapp.language_learning_backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.UUID;

@Slf4j
@Component
public class JwtTokenProvider {

    private final SecretKey secretKey;
    private final long accessExp;
    private final long refreshExp;

    public JwtTokenProvider(@Value("${jwt.secret}") String secret,
                            @Value("${jwt.access-token-expiration}") long accessExp,
                            @Value("${jwt.refresh-token-expiration}") long refreshExp) {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes());
        this.accessExp = accessExp;
        this.refreshExp = refreshExp;
    }

    // ✅ ROLE = ADMIN (KHÔNG có ROLE_)
    public String generateAccessToken(UUID userId, String email, String role) {
        return Jwts.builder()
                .subject(userId.toString())
                .claim("email", email)
                .claim("role", role) // 👈 ADMIN
                .claim("type", "ACCESS")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + accessExp))
                .signWith(secretKey)
                .compact();
    }

    public String generateRefreshToken(UUID userId) {
        return Jwts.builder()
                .subject(userId.toString())
                .claim("type", "REFRESH")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + refreshExp))
                .signWith(secretKey)
                .compact();
    }

    private Claims parse(String t) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(t)
                .getPayload();
    }

    public UUID getUserId(String t) {
        return UUID.fromString(parse(t).getSubject());
    }

    public String getEmail(String t) {
        return parse(t).get("email", String.class);
    }

    public String getRole(String t) {
        return parse(t).get("role", String.class); // ADMIN
    }

    public boolean isRefreshToken(String t) {
        return "REFRESH".equals(parse(t).get("type", String.class));
    }

    public long getRefreshExp() {
        return refreshExp;
    }

    public boolean validate(String t) {
        try {
            parse(t);
            return true;
        } catch (Exception e) {
            log.warn("JWT invalid: {}", e.getMessage());
            return false;
        }
    }
}