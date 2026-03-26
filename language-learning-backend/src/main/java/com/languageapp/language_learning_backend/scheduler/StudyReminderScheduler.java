package com.languageapp.language_learning_backend.scheduler;

import com.languageapp.language_learning_backend.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class StudyReminderScheduler {

    private final StudyLogService logService;
    // private final EmailService emailService; // ❌ tạm thời không dùng

    /** Mỗi tối 20:00 — nhắc user có streak nhưng chưa học hôm nay */
    @Scheduled(cron = "0 0 20 * * *")
    public void sendReminders() {
        var users = logService.getUsersToRemind();

        int count = 0;

        for (Object[] row : users) {
            try {
                String email = (String) row[0];
                String name  = (String) row[1];
                int streak   = ((Long) row[2]).intValue();

                // ===== OLD (EMAIL VERSION) =====
                /*
                emailService.sendStudyReminder(email, name, streak);
                */

                // ===== NEW (NO EMAIL VERSION) =====
                log.info("Reminder → User: {}, Email: {}, Streak: {}",
                        name, email, streak);

                count++;

            } catch (Exception e) {
                log.warn("Reminder failed for {}: {}", row[0], e.getMessage());
            }
        }

        log.info("Processed {} study reminders (email disabled)", count);
    }
}
