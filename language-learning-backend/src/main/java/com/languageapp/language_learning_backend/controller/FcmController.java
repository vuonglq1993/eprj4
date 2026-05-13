package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.firebase.*;
import com.languageapp.language_learning_backend.firebase.document.BroadcastHistoryDocument;
import com.languageapp.language_learning_backend.firebase.repository.BroadcastHistoryRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.FirebasePushService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Slf4j
@Tag(name = "17 \u00b7 Push Notifications")
@RestController
@RequestMapping("/api/v1/fcm")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
public class FcmController {

    private final FirebasePushService pushService;
    private final BroadcastHistoryRepository historyRepo;

    // ─── REGISTER FCM TOKEN ───────────────────────────────────
    @Operation(summary = "Đăng ký FCM token")
    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<FcmTokenResponse> registerToken(
            @Valid @RequestBody FcmTokenRequest req,
            @AuthenticationPrincipal UserPrincipal principal) {
        String userId = principal.getUserId().toString();
        try {
            pushService.saveToken(userId, req.getToken(), req.getDeviceType());
            return ResponseEntity.ok(FcmTokenResponse.builder()
                    .success(true)
                    .message("FCM token đã được đăng ký thành công")
                    .userId(userId)
                    .deviceType(req.getDeviceType())
                    .build());
        } catch (Exception e) {
            log.error("FCM register failed for user {}: {}", userId, e.getMessage());
            return ResponseEntity.internalServerError().body(FcmTokenResponse.builder()
                    .success(false)
                    .message("Đăng ký FCM token thất bại")
                    .userId(userId)
                    .build());
        }
    }

    // ─── BROADCAST ───────────────────────────────────────────
    @Operation(summary = "Broadcast notification đến tất cả user")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/broadcast")
    public ResponseEntity<Map<String, Object>> broadcast(@Valid @RequestBody NotificationRequest req) {
        try {
            CompletableFuture<Integer> future = pushService.sendToTopic(req.getTitle(), req.getBody(), req.getType());
            int sent = future.get(); // chờ async hoàn tất

            BroadcastHistoryDocument history = BroadcastHistoryDocument.builder()
                    .title(req.getTitle())
                    .body(req.getBody())
                    .type(req.getType() != null ? req.getType() : "SYSTEM")
                    .sentAt(new Date())
                    .target("ALL_USERS")
                    .recipientCount(sent)
                    .build();
            historyRepo.save(history);

            log.info("📢 Broadcast sent: {} → {} devices", req.getTitle(), sent);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", String.format("Broadcast đã gửi đến %d thiết bị!", sent),
                    "recipientCount", sent
            ));
        } catch (Exception e) {
            log.error("❌ Broadcast failed: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "success", false,
                    "message", "Gửi thất bại: " + e.getMessage()
            ));
        }
    }

    // ─── SEND TO SINGLE USER ─────────────────────────────────
    @Operation(summary = "Gửi notification đến 1 user cụ thể (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/send")
    public ResponseEntity<Map<String, Object>> sendToUser(@RequestBody Map<String, String> body) {
        try {
            String userId = body.get("userId");
            String title = body.get("title");
            String bodyText = body.get("body");
            String type = body.get("type");

            if (userId == null || userId.isBlank()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "userId là bắt buộc"
                ));
            }

            pushService.sendToUser(userId, title, bodyText, type);
            log.info("📨 Sent to user {}: {}", userId, title);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã gửi đến user"
            ));
        } catch (Exception e) {
            log.error("❌ Send failed: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of(
                    "success", false,
                    "message", "Gửi thất bại: " + e.getMessage()
            ));
        }
    }

    // ─── BROADCAST HISTORY ───────────────────────────────────
    @Operation(summary = "Lấy lịch sử broadcast")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/broadcast/history")
    public ResponseEntity<List<Map<String, Object>>> getHistory(
            @RequestParam(defaultValue = "20") int limit) {
        try {
            List<com.languageapp.language_learning_backend.firebase.document.BroadcastHistoryDocument> list =
                    historyRepo.findRecent(limit);

            List<Map<String, Object>> result = list.stream().map(doc -> {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id", doc.getId());
                m.put("title", doc.getTitle());
                m.put("body", doc.getBody());
                m.put("type", doc.getType());
                m.put("sentAt", doc.getSentAt());
                m.put("recipientCount", doc.getRecipientCount());
                return m;
            }).toList();

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("❌ History fetch failed: {}", e.getMessage());
            return ResponseEntity.ok(List.of());
        }
    }

    // ─── TEST SEND ──────────────────────────────────────────
    @Operation(summary = "Test gửi notification cho chính mình")
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

    // ─── UNREGISTER ──────────────────────────────────────────
    @Operation(summary = "Xóa FCM token (logout)")
    @DeleteMapping("/unregister")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<FcmTokenResponse> unregisterToken(
            @RequestParam String deviceType,
            @AuthenticationPrincipal UserPrincipal principal) {
        String userId = principal.getUserId().toString();
        pushService.deleteToken(userId, deviceType);
        return ResponseEntity.ok(FcmTokenResponse.builder()
                .success(true)
                .message("FCM token đã được xóa")
                .userId(userId)
                .deviceType(deviceType)
                .build());
    }
}
