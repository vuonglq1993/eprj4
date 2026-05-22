package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.studylog.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import com.languageapp.language_learning_backend.entity.UserProgress;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import java.time.Instant;
@Service
@RequiredArgsConstructor
public class StudyLogService {

    private final StudyLogRepository logRepo;
    private final LessonRepository   lessonRepo;
    private final UserRepository     userRepo;
    private final UserProgressRepository progressRepo;
    private final UserGameProfileRepository gameRepo;
    private final GamificationService gamificationService;

    // ── LOG PHIÊN HỌC ─────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "dashboard", key = "#p.userId")
    public void log(LogStudyRequest req, UserPrincipal p) {
        Lesson lesson = lessonRepo.findById(req.getLessonId())
                .orElseThrow(() -> new NotFoundException("Lesson not found"));

        User user = userRepo.getReferenceById(p.getUserId());

        // SAVE STUDY LOG
        logRepo.save(StudyLog.builder()
                .user(user)
                .lesson(lesson)
                .studyDate(LocalDate.now())
                .durationSeconds(req.getDurationSeconds())
                .score(req.getScore())
                .activityType(req.getActivityType())
                .build());

        updateStreak(user);

        Course course = lesson.getCourse();
        UserProgress progress = progressRepo
                .findByUserIdAndLessonId(user.getId(), lesson.getId())
                .orElse(UserProgress.builder()
                        .user(user)
                        .lesson(lesson)
                        .course(course)
                        .build()
                );

        // Lưu thời gian tốt nhất (không cộng dồn)
        progress.setTimeSpentSeconds(
                Math.max(progress.getTimeSpentSeconds(), req.getDurationSeconds())
        );

        if (progress.getStartedAt() == null) {
            progress.setStartedAt(Instant.now());
        }

        progressRepo.save(progress);
    }

    // ── STREAK ────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public StreakResponse getStreak(UserPrincipal p) {

        UserGameProfile gp = gameRepo.findByUserId(p.getUserId())
                .orElseThrow(() -> new NotFoundException("Profile not found"));

        LocalDate today = LocalDate.now();
        LocalDate since35 = today.minusDays(34);

        // Distinct dates for the last 35 days
        List<LocalDate> studyDates = logRepo.studyDates(p.getUserId(), since35);

        // Per-day lesson count (all activity types)
        List<Object[]> rawCounts = logRepo.dailyCount(p.getUserId(), since35, today);
        Map<LocalDate, Integer> dailyCounts = new LinkedHashMap<>();
        for (Object[] row : rawCounts) {
            dailyCounts.put((LocalDate) row[0], ((Number) row[1]).intValue());
        }

        boolean studiedToday = studyDates.contains(today);

        return StreakResponse.builder()
                .currentStreak(gp.getCurrentStreak())
                .longestStreak(gp.getLongestStreak())
                .lastStudyDate(studyDates.isEmpty() ? null : studyDates.get(0))
                .studiedToday(studiedToday)
                .studyDates(studyDates)
                .dailyCounts(dailyCounts)
                .build();
    }

    private void updateStreak(User user) {

        UserGameProfile gp = gameRepo.findByUserId(user.getId())
                .orElseGet(() -> gameRepo.save(
                        UserGameProfile.builder().user(user).build()
                ));

        ZoneId zone = parseUserZone(user.getTimezone());

        Instant now = Instant.now();

        LocalDate today = now.atZone(zone).toLocalDate();

        LocalDate last = gp.getLastActivityAt() == null
                ? null
                : gp.getLastActivityAt().atZone(zone).toLocalDate();

        // ❌ đã học hôm nay → ignore
        if (last != null && last.equals(today)) return;

        // ✅ streak logic
        boolean maintained = last != null && last.plusDays(1).equals(today);
        if (maintained) {
            gp.setCurrentStreak(gp.getCurrentStreak() + 1);
            // Award streak XP for keeping the streak going
            try {
                gamificationService.awardXp(user, GamificationService.XP_DAILY_STREAK);
            } catch (Exception e) {
                // non-fatal
            }
        } else {
            gp.setCurrentStreak(1); // reset, no streak XP
        }

        if (gp.getCurrentStreak() > gp.getLongestStreak()) {
            gp.setLongestStreak(gp.getCurrentStreak());
        }

        gp.setLastActivityAt(now);

        gameRepo.save(gp);
    }

    @Transactional(readOnly = true)
    public int getCurrentStreak(String userId) {
        try {
            UUID uid = UUID.fromString(userId);
            return gameRepo.findByUserId(uid)
                    .map(UserGameProfile::getCurrentStreak)
                    .orElse(0);
        } catch (Exception e) {
            return 0;
        }
    }

    // ── DAILY REMINDER SCHEDULER ──────────────────────────────
    // Gọi bởi StudyReminderScheduler mỗi tối 20:00
    @Transactional(readOnly = true)
    public List<Object[]> getUsersToRemind() {
        return userRepo.findUsersToRemind(LocalDate.now(), LocalDate.now().minusDays(1));
    }
    // ✅ NEW: weekly logs grouped by date
    @Transactional(readOnly = true)
    public Map<LocalDate, List<Map<String, Object>>> getWeeklyLogs(UserPrincipal p) {
        UUID uid = p.getUserId();

        LocalDate today = LocalDate.now();
        LocalDate startOfWeek = today.minusDays(6);

        List<StudyLog> logs = logRepo.findByUserAndDateRange(uid, startOfWeek, today);

        Map<LocalDate, List<Map<String, Object>>> result = new LinkedHashMap<>();

        for (StudyLog log : logs) {
            LocalDate date = log.getStudyDate();

            result.putIfAbsent(date, new ArrayList<>());

            Map<String, Object> item = new HashMap<>();
            item.put("lessonId", log.getLesson().getId());
            item.put("lessonName", log.getLesson().getTitle());
            item.put("duration", log.getDurationSeconds());
            item.put("activityType", log.getActivityType());

            item.put("score", log.getScore()); // thêm điểm

            // nếu entity StudyLog có createdAt / createdDate / loggedAt thì thêm:
            item.put("createdAt", log.getCreatedAt()); // hoặc log.getLoggedAt()

            result.get(date).add(item);
        }

        return result;
    }

    private ZoneId parseUserZone(String timezone) {
        if (timezone == null || timezone.isBlank()) return ZoneId.of("Asia/Ho_Chi_Minh");
        try {
            return ZoneId.of(timezone);
        } catch (Exception e) {
            return ZoneId.of("Asia/Ho_Chi_Minh");
        }
    }
}


