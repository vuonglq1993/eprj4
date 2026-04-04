package com.languageapp.language_learning_backend.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.languageapp.language_learning_backend.dto.auth.GoogleAuthRequest;
import com.languageapp.language_learning_backend.entity.User;
import com.languageapp.language_learning_backend.dto.user.AuthResponse;
import com.languageapp.language_learning_backend.entity.User.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.UserRepository;
import com.languageapp.language_learning_backend.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Collections;

@Slf4j
@Service
@RequiredArgsConstructor
public class GoogleAuthService {

    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Value("${google.client-id}")
    private String googleClientId;



    // ── VERIFY idToken và trả về JWT ─────────────────────────
    @Transactional
    public AuthResponse loginWithGoogle(GoogleAuthRequest req) {

        // 1. Verify idToken với Google
        GoogleIdToken.Payload payload = verifyIdToken(req.getIdToken());

        String googleId = payload.getSubject();
        String email = payload.getEmail();
        String firstName = (String) payload.get("given_name");
        String lastName = (String) payload.get("family_name");
        String avatar = (String) payload.get("picture");
        boolean verified = Boolean.TRUE.equals(payload.getEmailVerified());

        if (!verified)
            throw new BadRequestException("Google email is not verified");

        // 2. Tìm hoặc tạo User
        User user = userRepository
                .findByProviderAndProviderId(AuthProvider.GOOGLE, googleId)
                .orElseGet(() -> userRepository.findByEmail(email)
                        .map(existing -> linkGoogle(existing, googleId, avatar))
                        .orElseGet(() -> createUser(email, firstName, lastName, avatar, googleId)));

        if (!user.getIsActive())
            throw new UnauthorizedException("Account is disabled");

        // 3. Tạo JWT
        return buildTokens(user);
    }

    // ── HELPERS ───────────────────────────────────────────────
    private GoogleIdToken.Payload verifyIdToken(String idToken) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier
                    .Builder(new NetHttpTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            GoogleIdToken token = verifier.verify(idToken);
            if (token == null)
                throw new UnauthorizedException("Invalid Google idToken");

            return token.getPayload();
        } catch (UnauthorizedException e) {
            throw e;
        } catch (Exception e) {
            log.error("Google token verify failed: {}", e.getMessage());
            throw new UnauthorizedException("Google token verification failed");
        }
    }

    private User linkGoogle(User user, String googleId, String avatar) {
        user.setProvider(AuthProvider.GOOGLE);
        user.setProviderId(googleId);
        user.setEmailVerified(true);
        if (user.getAvatarUrl() == null && avatar != null)
            user.setAvatarUrl(avatar);
        return userRepository.save(user);
    }

    private User createUser(String email, String firstName, String lastName,
                            String avatar, String googleId) {
        return userRepository.save(User.builder()
                .email(email)
                .firstName(firstName != null ? firstName : email.split("@")[0])
                .lastName(lastName)
                .avatarUrl(avatar)
                .provider(AuthProvider.GOOGLE)
                .providerId(googleId)
                .emailVerified(true)
                .role(Role.STUDENT)
                .isActive(true)
                .build());
    }

    private AuthResponse buildTokens(User user) {
        String at = jwtTokenProvider.generateAccessToken(
                user.getId(), user.getEmail(), user.getRole().name());

        String rt = jwtTokenProvider.generateRefreshToken(user.getId());

        return AuthResponse.builder()
                .accessToken(at)
                .refreshToken(rt)
                .expiresIn(900L)
                .user(AuthResponse.UserInfo.builder()
                        .id(user.getId())
                        .email(user.getEmail())
                        .firstName(user.getFirstName())
                        .lastName(user.getLastName())
                        .avatarUrl(user.getAvatarUrl())
                        .role(user.getRole().name())
                        .build())
                .build();
    }
}
