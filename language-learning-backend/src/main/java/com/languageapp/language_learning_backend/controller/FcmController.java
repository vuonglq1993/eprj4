package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.firebase.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.FirebasePushService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "17 · Push Notifications")
@RestController
@RequestMapping("/api/v1/fcm")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
public class FcmController {

    private final FirebasePushService pushService;

    @Operation(summary = "Đăng ký FCM token để nhận push notification")
    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<FcmTokenResponse> registerToken(
            @Valid @RequestBody FcmTokenRequest req,
            @AuthenticationPrincipal UserPrincipal principal) {

        String userId = principal.getUserId().toString();

        pushService.saveToken(userId, req.getToken(), req.getDeviceType());

        return ResponseEntity.ok(FcmTokenResponse.builder()
                .success(true)
                .message("FCM token đã được đăng ký thành công")
                .userId(userId)
                .deviceType(req.getDeviceType())
                .build());
    }

    @Operation(summary = "Test gửi notification (Dev only)")
    @PostMapping("/test-send")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<FcmTokenResponse> testSend(
            @Valid @RequestBody NotificationRequest req,
            @AuthenticationPrincipal UserPrincipal principal) {

        String userId = principal.getUserId().toString();

        pushService.sendToUser(userId, req.getTitle(), req.getBody(), req.getData());

        return ResponseEntity.ok(FcmTokenResponse.builder()
                .success(true)
                .message("Test notification sent")
                .userId(userId)
                .build());
    }

    @Operation(summary = "Xóa FCM token (logout)")
    @DeleteMapping("/unregister")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<FcmTokenResponse> unregisterToken(
            @RequestParam String deviceType,
            @AuthenticationPrincipal UserPrincipal principal) {

        String userId = principal.getUserId().toString();

        // TODO: Implement delete in FirebaseFcmRepository

        return ResponseEntity.ok(FcmTokenResponse.builder()
                .success(true)
                .message("FCM token đã được xóa")
                .userId(userId)
                .deviceType(deviceType)
                .build());
    }
}