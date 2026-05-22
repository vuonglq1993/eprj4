package com.languageapp.language_learning_backend.service;

import com.google.firebase.messaging.*;
import com.languageapp.language_learning_backend.firebase.document.*;
import com.languageapp.language_learning_backend.firebase.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Slf4j
@Service
@RequiredArgsConstructor
public class FirebasePushService {

    private final FirebaseFcmRepository fcmRepo;
    private final FirebaseNotificationRepository notifRepo;
    private final BroadcastHistoryRepository historyRepo;

    // ══════════════════════════════════════════════
    // SAVE FCM TOKEN
    // ══════════════════════════════════════════════
    public void saveToken(String userId, String token, String deviceType) {
        try {
            FcmTokenDocument doc = FcmTokenDocument.builder()
                    .userId(userId)
                    .token(token)
                    .deviceType(deviceType != null ? deviceType : "ANDROID")
                    .createdAt(Instant.now())
                    .lastUsedAt(Instant.now())
                    .active(true)
                    .build();

            fcmRepo.save(doc);
            log.info("✅ FCM token registered for user={} deviceType={}", userId, doc.getDeviceType());

        } catch (Exception e) {
            log.error("❌ Failed to register FCM token for user {}: {}", userId, e.getMessage());
            throw new RuntimeException("FCM token registration failed", e);
        }
    }

    // ══════════════════════════════════════════════
    // OVERLOAD FIX (QUAN TRỌNG)
    // ══════════════════════════════════════════════
    public void sendToUser(String userId, String title, String body) {
        sendToUser(userId, title, body, Collections.emptyMap());
    }

    // ══════════════════════════════════════════════
    // SEND TO USER (MAIN)
    // ══════════════════════════════════════════════
    @Async
    public void sendToUser(String userId, String title, String body, Map<String, String> data) {

        try {
            List<String> tokens = fcmRepo.getTokensByUserId(userId);

            if (tokens == null || tokens.isEmpty()) {
                log.warn("⚠️ No FCM tokens for user {}", userId);
                return;
            }

            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            AndroidConfig androidConfig = AndroidConfig.builder()
                    .setNotification(AndroidNotification.builder()
                            .setChannelId("study_reminder")
                            .build())
                    .build();

            for (String token : tokens) {
                Message message = Message.builder()
                        .setToken(token)
                        .setNotification(notification)
                        .setAndroidConfig(androidConfig)
                        .putAllData(data != null ? data : Collections.emptyMap())
                        .build();

                try {
                    String response = FirebaseMessaging.getInstance().send(message);
                    log.info("✅ Notification sent: {}", response);

                } catch (FirebaseMessagingException e) {

                    // Token chết → xóa luôn
                    if (e.getMessagingErrorCode() == MessagingErrorCode.UNREGISTERED) {
                        fcmRepo.deleteByToken(token);
                        log.warn("🧹 Removed invalid token: {}", token);
                    }

                    log.error("❌ Failed to send: {}", e.getMessage());
                }
            }

            // ════════════════════════════════════════
            // SAVE NOTIFICATION HISTORY
            // ════════════════════════════════════════
            notifRepo.save(NotificationDocument.builder()
                    .userId(userId)
                    .title(title)
                    .body(body)
                    .type(data != null && data.containsKey("type")
                            ? data.get("type")
                            : "SYSTEM")
                    .sentAt(Instant.now())
                    .read(false)
                    .data(data != null ? data : Collections.emptyMap())
                    .build());

        } catch (Exception e) {
            log.error("❌ Error sending notification: {}", e.getMessage());
        }
    }

    // ══════════════════════════════════════════════
    // CONVENIENCE METHODS
    // ══════════════════════════════════════════════

    public void sendStudyReminder(String userId, String userName, int streak) {
        Map<String, String> data = new HashMap<>();
        data.put("type", "STUDY_REMINDER");
        data.put("streak", String.valueOf(streak));

        sendToUser(
                userId,
                "🔥 Đừng quên học hôm nay!",
                "Streak " + streak + " ngày đang chờ bạn duy trì!",
                data
        );
    }

    public void sendAchievement(String userId, String badgeName) {
        Map<String, String> data = new HashMap<>();
        data.put("type", "ACHIEVEMENT");
        data.put("badge", badgeName);

        sendToUser(
                userId,
                "🎉 Huy hiệu mới!",
                "Chúc mừng! Bạn đạt: " + badgeName,
                data
        );
    }

    // ══════════════════════════════════════════════
    // SEND TO USER (with String type)
    // ══════════════════════════════════════════════
    public void sendToUser(String userId, String title, String body, String type) {
        Map<String, String> data = new HashMap<>();
        data.put("type", type != null ? type : "SYSTEM");
        sendToUser(userId, title, body, data);
    }

    // ══════════════════════════════════════════════
    // BROADCAST — gửi trực tiếp đến TẤT CẢ token
    // ══════════════════════════════════════════════
    @Async
    public CompletableFuture<Integer> sendToTopic(String title, String body, String type) {
        int sent = 0;
        try {
            List<FcmTokenDocument> tokens = fcmRepo.getAllActiveTokens();

            if (tokens.isEmpty()) {
                log.warn("⚠️ No active FCM tokens found for broadcast");
                return CompletableFuture.completedFuture(0);
            }

            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            Map<String, String> data = new HashMap<>();
            data.put("type", type != null ? type : "SYSTEM");

            AndroidConfig androidConfig = AndroidConfig.builder()
                    .setNotification(AndroidNotification.builder()
                            .setChannelId("study_reminder")
                            .build())
                    .build();

            for (FcmTokenDocument tokenDoc : tokens) {
                Message message = Message.builder()
                        .setToken(tokenDoc.getToken())
                        .setNotification(notification)
                        .setAndroidConfig(androidConfig)
                        .putAllData(data)
                        .build();

                try {
                    FirebaseMessaging.getInstance().send(message);
                    sent++;
                } catch (FirebaseMessagingException e) {
                    if (e.getMessagingErrorCode() == MessagingErrorCode.UNREGISTERED) {
                        fcmRepo.deleteByToken(tokenDoc.getToken());
                        log.warn("🧹 Removed invalid token during broadcast: {}", tokenDoc.getToken());
                    } else {
                        log.error("❌ Broadcast send failed for token: {}", e.getMessage());
                    }
                }
            }

            log.info("✅ Broadcast sent to {}/{} devices", sent, tokens.size());

        } catch (Exception e) {
            log.error("❌ Broadcast error: {}", e.getMessage(), e);
        }
        return CompletableFuture.completedFuture(sent);
    }

    // ══════════════════════════════════════════════
    // DELETE FCM TOKEN
    // ══════════════════════════════════════════════
    public void deleteToken(String userId, String deviceType) {
        try {
            fcmRepo.deleteByUserIdAndDeviceType(userId, deviceType);
            log.info("✅ FCM token deleted for user {} (device: {})", userId, deviceType);
        } catch (Exception e) {
            log.error("❌ Failed to delete FCM token: {}", e.getMessage());
        }
    }
}