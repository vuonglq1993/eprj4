package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.firebase.NotificationResponse;
import com.languageapp.language_learning_backend.firebase.document.NotificationDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseNotificationRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Tag(name = "17 · Push Notifications")
@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class NotificationController {

    private final FirebaseNotificationRepository notifRepo;

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
}