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
        Course course = lesson.getCourse();
        UserProgress progress = progressRepo
                .findByUserIdAndLessonId(user.getId(), lesson.getId())
                .orElse(UserProgress.builder()
                        .user(user)
                        .lesson(lesson)
                        .course(course)
                        .build()
                );

// update time
        progress.setTimeSpentSeconds(
                progress.getTimeSpentSeconds() + req.getDurationSeconds()
        );

        progress.setAttempts(progress.getAttempts() + 1);

        if (progress.getStartedAt() == null) {
            progress.setStartedAt(Instant.now());
        }

        progressRepo.save(progress);
    }

    // ── STREAK ────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public StreakResponse getStreak(UserPrincipal p) {
        UUID uid = p.getUserId();
        List<LocalDate> dates = logRepo.studyDates(uid, LocalDate.now().minusDays(30));
        Set<LocalDate>  all   = new HashSet<>(logRepo.studyDates(uid, LocalDate.now().minusDays(365)));

        LocalDate today = LocalDate.now();
        int cur = 0;
        LocalDate check = all.contains(today) ? today : (all.contains(today.minusDays(1)) ? today.minusDays(1) : null);
        if (check != null) { for (; all.contains(check); check = check.minusDays(1)) cur++; }

        List<LocalDate> sorted = new ArrayList<>(all); Collections.sort(sorted);
        int longest = sorted.isEmpty() ? 0 : 1, tmp = 1;
        for (int i = 1; i < sorted.size(); i++) {
            tmp = sorted.get(i).equals(sorted.get(i-1).plusDays(1)) ? tmp + 1 : 1;
            longest = Math.max(longest, tmp);
        }

        return StreakResponse.builder()
                .currentStreak(cur).longestStreak(Math.max(longest, cur))
                .lastStudyDate(dates.isEmpty() ? null : dates.get(0))
                .studiedToday(logRepo.existsByUserIdAndStudyDate(uid, today))
                .studyDates(dates).build();
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
}


