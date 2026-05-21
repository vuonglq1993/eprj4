package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.progress.*;
import com.languageapp.language_learning_backend.dto.progress.DashboardResponse.*;
import com.languageapp.language_learning_backend.dto.progress.DashboardResponse.WeeklySummary.DailyStudy;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Lesson.AccessTier;
import com.languageapp.language_learning_backend.entity.Lesson.LessonType;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.*;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;
import java.time.Instant;

@Service
@RequiredArgsConstructor
public class ProgressService {

    private final UserProgressRepository progressRepo;
    private final StudyLogRepository studyLogRepo;
    private final CourseRepository courseRepo;
    private final UserRepository userRepo;
    private final LessonRepository lessonRepo;
    private final ExerciseRepository exerciseRepo;

    // ================= PLAN =================
    private Subscription.Plan getPlan(UserPrincipal p) {
        if (p == null) return Subscription.Plan.FREE;
        if ("ADMIN".equals(p.getRole()))
            return Subscription.Plan.YEARLY;

        return userRepo.findById(p.getUserId())
                .map(u -> u.getSubscription() != null ? u.getSubscription().getPlan() : Subscription.Plan.FREE)
                .orElse(Subscription.Plan.FREE);
    }

    private List<AccessTier> getAccessibleTiers(Subscription.Plan plan) {
        if (plan == Subscription.Plan.MONTHLY)
            return List.of(AccessTier.PREVIEW, AccessTier.MONTHLY);

        if (plan == Subscription.Plan.THREE_MONTHS || plan == Subscription.Plan.YEARLY)
            return List.of(AccessTier.PREVIEW, AccessTier.MONTHLY, AccessTier.UNLIMITED);

        return List.of(AccessTier.PREVIEW);
    }

    private int calcProgress(UUID userId, Course c, Subscription.Plan plan) {
        var tiers = getAccessibleTiers(plan);

        long total = lessonRepo.countAccessible(c.getId(), tiers);
        if (total == 0) return 0;

        long done = progressRepo.countCompletedAccessible(userId, c.getId(), tiers);
        return (int) (done * 100 / total);
    }

    // ================= DASHBOARD =================
    //@Cacheable(value = "dashboard", key = "#p.userId")
    @Transactional(readOnly = true)
    public DashboardResponse getDashboard(UserPrincipal p) {
        UUID uid = p.getUserId();
        List<UserProgress> all = progressRepo.findByUserId(uid);
        long completed = all.stream().filter(pr -> pr.getStatus() == ProgressStatus.COMPLETED).count();
        int[] streak = calcStreak(uid);

        return DashboardResponse.builder()
                .totalCoursesEnrolled((int) all.stream().map(pr -> pr.getCourse().getId()).distinct().count())
                .totalLessonsCompleted((int) completed)
                .totalExercisesDone((int) progressRepo.sumAttempts(uid))
                .currentStreak(streak[0]).longestStreak(streak[1])
                .totalStudyMinutes((int) (studyLogRepo.sumSeconds(uid,
                        LocalDate.now().minusYears(10), LocalDate.now()) / 60))
                .averageScore(round(progressRepo.avgScore(uid)))
                .activeCourses(buildActiveCourses(uid, all, p))
                .thisWeek(buildWeekly(uid))
                .skills(buildSkills(uid))
                .build();
    }

    // ================= FIXED ACTIVE COURSES =================
    private List<CourseProgressSummary> buildActiveCourses(UUID uid,
                                                           List<UserProgress> all,
                                                           UserPrincipal p) {

        Subscription.Plan plan = getPlan(p);
        List<AccessTier> tiers = getAccessibleTiers(plan);

        return all.stream().collect(Collectors.groupingBy(pr -> pr.getCourse().getId()))
                .entrySet().stream().map(e -> {
                    Course c = e.getValue().get(0).getCourse();

                    int pct = calcProgress(uid, c, plan);

                    double avg = e.getValue().stream()
                            .mapToDouble(this::normalizedScore).average().orElse(0);
                    System.out.println(">>> USER: " + uid);
                    System.out.println(">>> TIERS: " + tiers);
                    Page<Lesson> np = progressRepo.nextAccessibleLesson(
                            uid, c.getId(), tiers, PageRequest.of(0, 1)
                    );

                    Lesson next = np.isEmpty() ? null : np.getContent().get(0);

                    return CourseProgressSummary.builder()
                            .courseId(e.getKey())
                            .courseTitle(c.getTitle())
                            .languageName(c.getLanguage().getName())
                            .totalLessons(c.getTotalLessons())
                            .completedLessons((int) e.getValue().stream()
                                    .filter(pr -> pr.getStatus() == ProgressStatus.COMPLETED).count())
                            .progressPercent(pct)
                            .averageScore(round(avg))
                            .nextLessonId(next != null ? next.getId() : null)
                            .nextLessonTitle(next != null ? next.getTitle() : null)
                            .build();
                })
                .filter(s -> s.getProgressPercent() < 100)
                .sorted(Comparator.comparingInt(CourseProgressSummary::getProgressPercent).reversed())
                .limit(5)
                .collect(Collectors.toList());
    }

    // ================= COURSE PROGRESS =================
    @Transactional(readOnly = true)
    public List<ProgressResponse> getCourseProgress(UUID courseId, UserPrincipal p) {
        courseRepo.findById(courseId).orElseThrow(() -> new NotFoundException("Course not found"));
        return progressRepo.findByUserIdAndCourseId(p.getUserId(), courseId).stream()
                .map(pr -> ProgressResponse.builder()
                        .lessonId(pr.getLesson().getId())
                        .lessonTitle(pr.getLesson().getTitle())
                        .lessonType(pr.getLesson().getType().name())
                        .status(pr.getStatus())
                        .score(pr.getScore())
                        .bestScore(pr.getBestScore())
                        .attempts(pr.getAttempts())
                        .timeSpentMinutes(pr.getTimeSpentSeconds() / 60)
                        .completedAt(pr.getCompletedAt())
                        .updatedAt(pr.getUpdatedAt())
                        .build())
                .collect(Collectors.toList());
    }

    // ================= STATS =================
    @Transactional(readOnly = true)
    public StatsResponse getStats(String period, UserPrincipal p) {
        UUID uid = p.getUserId();
        LocalDate to = LocalDate.now();
        LocalDate from = switch (period.toUpperCase()) {
            case "MONTH" -> to.minusDays(29);
            case "YEAR" -> to.minusMonths(11).withDayOfMonth(1);
            default -> to.minusDays(6);
        };

        Map<LocalDate, Long> sm = studyLogRepo.dailySeconds(uid, from, to)
                .stream().collect(Collectors.toMap(r -> (LocalDate) r[0], r -> (Long) r[1]));
        Map<LocalDate, Long> cm = studyLogRepo.dailyCount(uid, from, to)
                .stream().collect(Collectors.toMap(r -> (LocalDate) r[0], r -> (Long) r[1]));

        List<StatsResponse.PeriodStat> data = new ArrayList<>();
        for (LocalDate d = from; !d.isAfter(to); d = d.plusDays(1)) {
            data.add(StatsResponse.PeriodStat.builder()
                    .date(d)
                    .label(d.getDayOfMonth() + " " + d.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH))
                    .studyMinutes((int) (sm.getOrDefault(d, 0L) / 60))
                    .lessonsCompleted(cm.getOrDefault(d, 0L).intValue())
                    .build());
        }

        return StatsResponse.builder()
                .period(period.toUpperCase())
                .totalMinutes((int) (sm.values().stream().mapToLong(Long::longValue).sum() / 60))
                .totalLessons((int) cm.values().stream().mapToLong(Long::longValue).sum())
                .averageScore(round(progressRepo.avgScore(uid)))
                .data(data)
                .build();
    }

    // ================= CERTIFICATE =================
    @Transactional(readOnly = true)
    public CertificateResponse getCertificate(UUID courseId, UserPrincipal p) {
        UUID uid = p.getUserId();
        Course c = courseRepo.findById(courseId).orElseThrow(() -> new NotFoundException("Course not found"));

        int pct = calcProgress(uid, c, getPlan(p)); // FIXED

        if (pct < 100)
            throw new BadRequestException("Course not completed yet. Progress: " + pct + "%");

        User user = userRepo.findById(uid).orElseThrow(() -> new NotFoundException("User not found"));

        double avg = progressRepo.findByUserIdAndCourseId(uid, courseId)
                .stream().mapToDouble(this::normalizedScore).average().orElse(0);

        Instant completedAt = progressRepo.findByUserIdAndCourseId(uid, courseId)
                .stream().map(UserProgress::getCompletedAt)
                .filter(Objects::nonNull)
                .max(Comparator.naturalOrder())
                .orElse(Instant.now());

        return CertificateResponse.builder()
                .courseId(courseId)
                .courseTitle(c.getTitle())
                .languageName(c.getLanguage().getName())
                .userName(user.getFullName())
                .finalScore(round(avg))
                .cefrLevel(courseToCefr(c.getLevel()))
                .completedAt(completedAt)
                .certificateCode("LN-" + uid.toString().substring(0, 6).toUpperCase())
                .build();
    }

    // ================= HELPERS =================
    private int[] calcStreak(UUID uid) {
        Set<LocalDate> dates = new HashSet<>(studyLogRepo.studyDates(uid, LocalDate.now().minusDays(365)));
        if (dates.isEmpty()) return new int[]{0, 0};

        LocalDate today = LocalDate.now();
        int cur = 0;
        LocalDate check = dates.contains(today) ? today :
                (dates.contains(today.minusDays(1)) ? today.minusDays(1) : null);

        if (check != null) {
            for (; dates.contains(check); check = check.minusDays(1)) cur++;
        }

        List<LocalDate> sorted = new ArrayList<>(dates);
        Collections.sort(sorted);

        int longest = 1, tmp = 1;
        for (int i = 1; i < sorted.size(); i++) {
            tmp = sorted.get(i).equals(sorted.get(i - 1).plusDays(1)) ? tmp + 1 : 1;
            longest = Math.max(longest, tmp);
        }

        return new int[]{cur, Math.max(longest, cur)};
    }

    private WeeklySummary buildWeekly(UUID uid) {
        LocalDate monday = LocalDate.now().with(DayOfWeek.MONDAY);
        LocalDate today = LocalDate.now();

        Map<LocalDate, Long> sm = studyLogRepo.dailySeconds(uid, monday, today)
                .stream().collect(Collectors.toMap(r -> (LocalDate) r[0], r -> (Long) r[1]));
        Map<LocalDate, Long> cm = studyLogRepo.dailyCount(uid, monday, today)
                .stream().collect(Collectors.toMap(r -> (LocalDate) r[0], r -> (Long) r[1]));

        List<DailyStudy> daily = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = monday.plusDays(i);
            daily.add(DailyStudy.builder()
                    .date(d)
                    .dayLabel(d.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH))
                    .studyMinutes((int) (sm.getOrDefault(d, 0L) / 60))
                    .lessonsCompleted(cm.getOrDefault(d, 0L).intValue())
                    .build());
        }

        return WeeklySummary.builder()
                .studyMinutes((int) (sm.values().stream().mapToLong(Long::longValue).sum() / 60))
                .lessonsCompleted((int) cm.values().stream().mapToLong(Long::longValue).sum())
                .averageScore(round(progressRepo.avgScore(uid)))
                .daily(daily)
                .build();
    }

    private SkillBreakdown buildSkills(UUID uid) {
        Map<LessonType, double[]> m = new HashMap<>();
        progressRepo.avgScoreByType(uid).forEach(r ->
                m.put((LessonType) r[0],
                        new double[]{((Number) r[1]).doubleValue(), ((Number) r[2]).doubleValue()}));

        return SkillBreakdown.builder()
                .listening(skill(LessonType.LISTENING, m))
                .speaking(skill(LessonType.SPEAKING, m))
                .reading(skill(LessonType.READING, m))
                .writing(skill(LessonType.WRITING, m))
                .vocabulary(skill(LessonType.VOCABULARY, m))
                .grammar(skill(LessonType.GRAMMAR, m))
                .build();
    }

    private SkillBreakdown.SkillScore skill(LessonType t, Map<LessonType, double[]> m) {
        double[] s = m.getOrDefault(t, new double[]{0, 0});
        double avg = round(s[0]);

        return SkillBreakdown.SkillScore.builder()
                .averageScore(avg)
                .lessonsCompleted((int) s[1])
                .level(avg >= 80 ? "Advanced" : avg >= 60 ? "Intermediate" : "Beginner")
                .build();
    }

    private double round(double v) {
        return Math.round(v * 10.0) / 10.0;
    }

    private double normalizedScore(UserProgress pr) {
        int total = exerciseRepo.sumPointsByLessonId(pr.getLesson().getId());
        return total > 0 ? pr.getBestScore() * 100.0 / total : 0;
    }

    private String courseToCefr(Course.Level level) {
        if (level == null) return "A1";
        return switch (level) {
            case BEGINNER -> "A1";
            case ELEMENTARY -> "A2";
            case INTERMEDIATE -> "B1";
            case UPPER_INTERMEDIATE -> "B2";
            case ADVANCED -> "C1";
        };
    }

}