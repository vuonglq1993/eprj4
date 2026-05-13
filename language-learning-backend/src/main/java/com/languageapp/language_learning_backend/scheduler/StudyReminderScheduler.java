package com.languageapp.language_learning_backend.scheduler;

import com.languageapp.language_learning_backend.firebase.document.ReminderSettingsDocument;
import com.languageapp.language_learning_backend.firebase.repository.FirebaseReminderRepository;
import com.languageapp.language_learning_backend.service.FirebasePushService;
import com.languageapp.language_learning_backend.service.StudyLogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

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
            ZonedDateTime utcNow = ZonedDateTime.now(ZoneId.of("UTC"));

            List<ReminderSettingsDocument> allEnabled = reminderRepo.findAllEnabled();
            log.info("Reminder tick UTC {}:{} — checking {} enabled setting(s)",
                    utcNow.getHour(), utcNow.getMinute(), allEnabled.size());

            for (ReminderSettingsDocument settings : allEnabled) {
                try {
                    // Convert current UTC time to each user's own timezone
                    ZoneId userZone = parseZone(settings.getTimezone());
                    ZonedDateTime userNow = utcNow.withZoneSameInstant(userZone);

                    if (userNow.getHour() == settings.getHour()
                            && userNow.getMinute() == settings.getMinute()) {
                        log.info("Sending reminder → userId={} tz={} localTime={}:{}",
                                settings.getUserId(), userZone,
                                settings.getHour(), settings.getMinute());
                        sendReminderToUser(settings.getUserId());
                    }
                } catch (Exception e) {
                    log.warn("Failed reminder for user {}: {}", settings.getUserId(), e.getMessage());
                }
            }
        } catch (Exception e) {
            log.error("Scheduler error: {}", e.getMessage());
        }
    }

    private ZoneId parseZone(String timezone) {
        if (timezone == null || timezone.isBlank()) return ZoneId.of("Asia/Ho_Chi_Minh");
        try {
            return ZoneId.of(timezone);
        } catch (Exception e) {
            log.warn("Invalid timezone '{}', falling back to Asia/Ho_Chi_Minh", timezone);
            return ZoneId.of("Asia/Ho_Chi_Minh");
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
