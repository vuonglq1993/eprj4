package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.firebase.NotificationResponse;
import com.languageapp.language_learning_backend.dto.firebase.ReminderSettingsRequest;
import com.languageapp.language_learning_backend.dto.firebase.ReminderSettingsResponse;
import com.languageapp.language_learning_backend.firebase.document.NotificationDocument;
import com.languageapp.language_learning_backend.firebase.document.ReminderSettingsDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseNotificationRepository;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseReminderRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.FirebasePushService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Tag(name = "17 · Push Notifications")
@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class NotificationController {

    private final FirebaseNotificationRepository notifRepo;
    private final FirebaseReminderRepository reminderRepo;
    private final FirebasePushService pushService;

    @Operation(summary = "Lấy danh sách notifications chưa đọc")
    @GetMapping("/unread")
    public ResponseEntity<List<NotificationResponse>> getUnread(
            @AuthenticationPrincipal UserPrincipal principal) {

        try {
            String userId = principal.getUserId().toString();

            List<NotificationDocument> docs = notifRepo.findUnreadByUserId(userId);

            List<NotificationResponse> responses = docs.stream()
                    .map(doc -> NotificationResponse.builder()
                            .userId(doc.getUserId())
                            .title(doc.getTitle())
                            .body(doc.getBody())
                            .type(doc.getType())
                            .sentAt(doc.getSentAt())
                            .read(doc.isRead())
                            .data(doc.getData())
                            .build())
                    .collect(Collectors.toList());

            return ResponseEntity.ok(responses);

        } catch (Exception e) {
            return ResponseEntity.ok(List.of());
        }
    }

    @Operation(summary = "Đánh dấu notification đã đọc")
    @PutMapping("/{id}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable String id) {
        try {
            notifRepo.markAsRead(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @Operation(summary = "Lấy reminder settings của user")
    @GetMapping("/reminder-settings")
    public ResponseEntity<ReminderSettingsResponse> getReminderSettings(
            @AuthenticationPrincipal UserPrincipal principal) {
        try {
            String userId = principal.getUserId().toString();
            return reminderRepo.findByUserId(userId)
                    .map(doc -> ResponseEntity.ok(ReminderSettingsResponse.builder()
                            .enabled(doc.isEnabled())
                            .hour(doc.getHour())
                            .minute(doc.getMinute())
                            .timezone(doc.getTimezone())
                            .build()))
                    .orElse(ResponseEntity.ok(ReminderSettingsResponse.builder()
                            .enabled(false).hour(20).minute(0).timezone("Asia/Ho_Chi_Minh")
                            .build()));
        } catch (Exception e) {
            return ResponseEntity.ok(ReminderSettingsResponse.builder()
                    .enabled(false).hour(20).minute(0).timezone("Asia/Ho_Chi_Minh").build());
        }
    }

    @Operation(summary = "Cập nhật reminder settings")
    @PutMapping("/reminder-settings")
    public ResponseEntity<Void> updateReminderSettings(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestBody ReminderSettingsRequest req) {
        try {
            String userId = principal.getUserId().toString();
            reminderRepo.save(ReminderSettingsDocument.builder()
                    .userId(userId)
                    .enabled(req.isEnabled())
                    .hour(req.getHour())
                    .minute(req.getMinute())
                    .timezone(req.getTimezone() != null ? req.getTimezone() : "Asia/Ho_Chi_Minh")
                    .build());
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @Operation(summary = "Gửi test notification cho chính mình")
    @PostMapping("/test")
    public ResponseEntity<Void> sendTest(@AuthenticationPrincipal UserPrincipal principal) {
        try {
            String userId = principal.getUserId().toString();
            pushService.sendToUser(userId, "🔔 Test Notification",
                    "Notification đang hoạt động tốt!",
                    Map.of("type", "TEST"));
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}