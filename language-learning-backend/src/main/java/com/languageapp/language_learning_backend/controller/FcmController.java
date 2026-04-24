package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.firebase.SendRequest;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.FirebasePushService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Tag(name = "17 · Push Notifications")
@RestController
@RequestMapping("/api/v1/fcm")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class FcmController {

    private final FirebasePushService pushService;

    @Operation(summary = "Đăng ký FCM token để nhận push notification")
    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> registerToken(
            @Valid @RequestBody RegisterTokenRequest req,
            @AuthenticationPrincipal UserPrincipal p) {

        pushService.saveToken(p.getUserId().toString(), req.getToken(), req.getDeviceType());

        return ResponseEntity.ok(Map.of(
                "message", "FCM token registered successfully",
                "userId", p.getUserId().toString()
        ));
    }
    @PostMapping("/send")
    public ResponseEntity<?> sendNotification(
            @RequestBody SendRequest req,
            @AuthenticationPrincipal UserPrincipal p) {

        pushService.sendToUser(
                p.getUserId().toString(),
                req.getTitle(),
                req.getBody(),
                req.getData()
        );

        return ResponseEntity.ok(Map.of("message", "Notification sent"));
    }

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor
    public static class RegisterTokenRequest {
        @NotBlank private String token;
        @NotBlank private String deviceType; // ANDROID, IOS, WEB
    }
}