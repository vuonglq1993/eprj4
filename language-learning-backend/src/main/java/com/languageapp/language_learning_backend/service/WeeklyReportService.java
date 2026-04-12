package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.report.WeeklyReportResponse;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WeeklyReportService {

    private final StudyLogRepository     studyLogRepo;
    private final UserProgressRepository progressRepo;
    private final UserRepository         userRepo;
    private final UserGameProfileRepository gameRepo;

    @Transactional(readOnly = true)
    public WeeklyReportResponse getReport(UserPrincipal p) {
        UUID uid = p.getUserId();

        // Tuần này (thứ 2 → CN)
        LocalDate monday = LocalDate.now().with(DayOfWeek.MONDAY);
        LocalDate sunday = monday.plusDays(6);

        // Tuần trước
        LocalDate lastMonday = monday.minusWeeks(1);
        LocalDate lastSunday = lastMonday.plusDays(6);

        // Data tuần này
        Map<LocalDate, Long> secMap  = toMap(studyLogRepo.dailySeconds(uid, monday, LocalDate.now()));
        Map<LocalDate, Long> cntMap  = toMap(studyLogRepo.dailyCount(uid, monday, LocalDate.now()));
        Set<LocalDate> studyDates    = new HashSet<>(studyLogRepo.studyDates(uid, monday));

        // Data tuần trước
        long lastWeekSec  = studyLogRepo.sumSeconds(uid, lastMonday, lastSunday);
        Map<LocalDate, Long> lastCnt = toMap(studyLogRepo.dailyCount(uid, lastMonday, lastSunday));
        long lastWeekLessons = lastCnt.values().stream().mapToLong(Long::longValue).sum();

        // Tổng tuần này
        long totalSec     = secMap.values().stream().mapToLong(Long::longValue).sum();
        long totalLessons = cntMap.values().stream().mapToLong(Long::longValue).sum();
        double avgScore   = progressRepo.avgScore(uid);

        // XP tuần này
        int weeklyXp = gameRepo.findByUserId(uid).map(g -> g.getWeeklyXp()).orElse(0);

        // Streak
        List<LocalDate> allDates = studyLogRepo.studyDates(uid, LocalDate.now().minusDays(365));
        int streak = calcStreak(allDates);

        // Chi tiết ngày
        List<WeeklyReportResponse.DailyReport> daily = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = monday.plusDays(i);
            daily.add(WeeklyReportResponse.DailyReport.builder()
                    .date(d)
                    .dayLabel(d.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH))
                    .studyMinutes((int)(secMap.getOrDefault(d, 0L) / 60))
                    .lessonsCompleted(cntMap.getOrDefault(d, 0L).intValue())
                    .averageScore(0.0)
                    .studiedToday(studyDates.contains(d))
                    .build());
        }

        // Tiến độ khoá
        List<UserProgress> allProgress = progressRepo.findByUserId(uid);
        Map<UUID, List<UserProgress>> byCourse = allProgress.stream()
                .collect(Collectors.groupingBy(pr -> pr.getCourse().getId()));

        List<WeeklyReportResponse.CourseProgress> courses = byCourse.entrySet().stream()
                .map(e -> {
                    Course c = e.getValue().get(0).getCourse();
                    long done = e.getValue().stream()
                            .filter(pr -> pr.getStatus() == ProgressStatus.COMPLETED).count();
                    int pct = c.getTotalLessons() > 0
                            ? (int)(done * 100 / c.getTotalLessons()) : 0;
                    long lessonsThisWeek = e.getValue().stream()
                            .filter(pr -> pr.getCompletedAt() != null
                                    && pr.getCompletedAt().isAfter(
                                    monday.atStartOfDay(ZoneOffset.UTC).toInstant()))
                            .count();
                    return WeeklyReportResponse.CourseProgress.builder()
                            .courseTitle(c.getTitle())
                            .progressPercent(pct)
                            .lessonsThisWeek((int) lessonsThisWeek)
                            .build();
                })
                .sorted(Comparator.comparingInt(WeeklyReportResponse.CourseProgress::getLessonsThisWeek).reversed())
                .limit(5)
                .collect(Collectors.toList());

        // So sánh với tuần trước
        int minutesDiff  = (int)(totalSec / 60) - (int)(lastWeekSec / 60);
        long lessonsDiff = totalLessons - lastWeekLessons;

        return WeeklyReportResponse.builder()
                .weekStart(monday).weekEnd(sunday)
                .totalStudyMinutes((int)(totalSec / 60))
                .totalLessonsCompleted((int) totalLessons)
                .totalExercisesDone((int) progressRepo.sumAttempts(uid))
                .averageScore(Math.round(avgScore * 10.0) / 10.0)
                .currentStreak(streak)
                .xpEarnedThisWeek(weeklyXp)
                .minutesVsLastWeek(minutesDiff)
                .lessonsVsLastWeek((int) lessonsDiff)
                .scoreVsLastWeek(0.0)
                .daily(daily)
                .courses(courses)
                .newBadges(Collections.emptyList())
                .motivationMessage(buildMessage(streak, (int) totalLessons, minutesDiff))
                .build();
    }

    private Map<LocalDate, Long> toMap(List<Object[]> rows) {
        return rows.stream().collect(Collectors.toMap(
                r -> (LocalDate) r[0], r -> (Long) r[1]));
    }

    private int calcStreak(List<LocalDate> dates) {
        if (dates.isEmpty()) return 0;
        Set<LocalDate> set = new HashSet<>(dates);
        LocalDate check = set.contains(LocalDate.now()) ? LocalDate.now()
                : set.contains(LocalDate.now().minusDays(1)) ? LocalDate.now().minusDays(1) : null;
        if (check == null) return 0;
        int s = 0;
        for (; set.contains(check); check = check.minusDays(1)) s++;
        return s;
    }

    private String buildMessage(int streak, int lessons, int minutesDiff) {
        if (lessons == 0) return "Tuần này chưa học bài nào. Bắt đầu ngay hôm nay! ";
        if (minutesDiff > 0) return String.format(
                "Xuất sắc! Tuần này bạn học nhiều hơn tuần trước %d phút. Streak %d ngày! ",
                minutesDiff, streak);
        if (streak >= 7) return String.format(
                "Streak %d ngày liên tiếp! Bạn đang làm rất tốt. Tiếp tục nhé! ", streak);
        return String.format("Tuần này hoàn thành %d bài học. Cố gắng thêm tuần tới! ", lessons);
    }
}