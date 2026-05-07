package com.languageapp.language_learning_backend.scheduler;

import com.languageapp.language_learning_backend.firebase.document.ReminderSettingsDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseReminderRepository;
import com.languageapp.language_learning_backend.service.FirebasePushService;
import com.languageapp.language_learning_backend.service.StudyLogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class StudyReminderScheduler {

    private final FirebaseReminderRepository reminderRepo;
    private final FirebasePushService pushService;
    private final StudyLogService logService;

    @Scheduled(cron = "0 * * * * *")
    public void sendReminders() {
        try {
            // Dùng timezone VN làm mặc định; mỗi user có thể có timezone riêng trong Firestore
            ZonedDateTime now = ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
            int hour   = now.getHour();
            int minute = now.getMinute();

            List<ReminderSettingsDocument> targets = reminderRepo.findEnabledAtTime(hour, minute);
            log.info("Reminder check {}:{} → {} user(s)", hour, minute, targets.size());

            for (ReminderSettingsDocument settings : targets) {
                try {
                    sendReminderToUser(settings.getUserId());
                } catch (Exception e) {
                    log.warn("Failed to send reminder to user {}: {}", settings.getUserId(), e.getMessage());
                }
            }
        } catch (Exception e) {
            log.error("Scheduler error: {}", e.getMessage());
        }
    }

    private void sendReminderToUser(String userId) {
        int streak = logService.getCurrentStreak(userId);

        String title;
        String body;

        if (streak >= 7) {
            title = "🔥 Streak " + streak + " ngày!";
            body  = "Tuyệt vời! Đừng để mất streak hôm nay. Học ngay nhé!";
        } else if (streak >= 1) {
            title = "📚 Đến giờ học rồi!";
            body  = "Bạn đang có streak " + streak + " ngày. Tiếp tục nào!";
        } else {
            title = "📚 Học tiếng Anh hôm nay nhé!";
            body  = "Mỗi ngày một ít, kiến thức sẽ tích lũy dần. Bắt đầu ngay!";
        }

        pushService.sendToUser(userId, title, body,
                Map.of("type", "STUDY_REMINDER", "streak", String.valueOf(streak)));

        log.info("✅ Reminder sent → userId={} streak={}", userId, streak);
    }
}
