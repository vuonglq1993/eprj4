package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.gamification.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.UserBadge.BadgeType;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class GamificationService {

    private final UserGameProfileRepository gameRepo;
    private final UserBadgeRepository       badgeRepo;
    private final UserRepository            userRepo;
    private final UserProgressRepository    progressRepo;
    private final StudyLogRepository        studyLogRepo;

    // ── XP TABLE ─────────────────────────────────────────────
    // XP nhận được cho từng hành động
    private static final int XP_COMPLETE_LESSON   = 20;
    private static final int XP_CORRECT_EXERCISE  = 5;
    private static final int XP_PERFECT_LESSON    = 15;  // bonus nếu 100%
    private static final int XP_DAILY_STREAK      = 10;  // bonus mỗi ngày có streak

    // ── LEVEL TABLE ───────────────────────────────────────────
    // Level = floor(sqrt(totalXp / 100)) + 1  (công thức đơn giản)
    // Level 1: 0 XP, Level 2: 100 XP, Level 3: 400 XP, Level 4: 900 XP...
    private static final String[] LEVEL_TITLES = {
            "",           // 0 (không dùng)
            "Beginner",   // 1
            "Explorer",   // 2
            "Learner",    // 3
            "Scholar",    // 4
            "Achiever",   // 5
            "Expert",     // 6
            "Master",     // 7
            "Champion",   // 8
            "Legend",     // 9
            "Grandmaster" // 10+
    };

    // ── GET PROFILE ───────────────────────────────────────────
    @Transactional(readOnly = true)
    public GameProfileResponse getProfile(UserPrincipal p) {
        User user = userRepo.findById(p.getUserId())
                .orElseThrow(() -> new NotFoundException("User not found"));
        UserGameProfile g = getOrCreate(user);
        List<UserBadge> badges = badgeRepo.findByUserIdOrderByEarnedAtDesc(p.getUserId());

        int level        = calcLevel(g.getTotalXp());
        int xpCurrent    = g.getTotalXp() - xpForLevel(level);
        int xpNext       = xpForLevel(level + 1) - xpForLevel(level);
        int pct          = xpNext > 0 ? (xpCurrent * 100 / xpNext) : 100;

        return GameProfileResponse.builder()
                .userId(user.getId())
                .userName(user.getFullName())
                .avatarUrl(user.getAvatarUrl())
                .totalXp(g.getTotalXp())
                .level(level)
                .weeklyXp(g.getWeeklyXp())
                .levelTitle(levelTitle(level))
                .xpToNextLevel(xpNext - xpCurrent)
                .xpCurrentLevel(xpCurrent)
                .progressPercent(pct)
                .badges(badges.stream().map(this::toBadgeResponse).collect(Collectors.toList()))
                .build();
    }

    // ── LEADERBOARD ───────────────────────────────────────────
    @Transactional(readOnly = true)
    public LeaderboardResponse getLeaderboard(UserPrincipal p) {
        List<UserGameProfile> topWeekly  = gameRepo.findTopWeekly(PageRequest.of(0, 20));
        List<UserGameProfile> topAllTime = gameRepo.findTopAllTime(PageRequest.of(0, 20));

        UserGameProfile mine = getOrCreate(userRepo.getReferenceById(p.getUserId()));
        int myWeeklyRank  = gameRepo.rankWeekly(mine.getWeeklyXp());
        int myAllTimeRank = gameRepo.rankAllTime(mine.getTotalXp());

        return LeaderboardResponse.builder()
                .weekly(toEntries(topWeekly, true))
                .allTime(toEntries(topAllTime, false))
                .myRank(LeaderboardResponse.LeaderboardEntry.builder()
                        .rank(myWeeklyRank)
                        .userId(p.getUserId())
                        .xp(mine.getWeeklyXp())
                        .level(calcLevel(mine.getTotalXp()))
                        .levelTitle(levelTitle(calcLevel(mine.getTotalXp())))
                        .build())
                .build();
    }

    // ── AWARD XP (gọi từ StudyLogService sau mỗi phiên học) ──
    @Transactional
    public XpEarnedResponse awardXp(User user, int xpEarned) {
        UserGameProfile g = getOrCreate(user);

        int oldLevel = calcLevel(g.getTotalXp());

        // Reset weeklyXp nếu sang tuần mới
        resetWeeklyIfNeeded(g);

        g.setTotalXp(g.getTotalXp() + xpEarned);
        g.setWeeklyXp(g.getWeeklyXp() + xpEarned);

        int newLevel  = calcLevel(g.getTotalXp());
        boolean levelUp = newLevel > oldLevel;
        if (levelUp) g.setLevel(newLevel);

        gameRepo.save(g);

        // Kiểm tra badge mới
        List<UserBadge> newBadges = checkAndAwardBadges(user, g);

        return XpEarnedResponse.builder()
                .xpEarned(xpEarned)
                .totalXp(g.getTotalXp())
                .level(newLevel)
                .leveledUp(levelUp)
                .newLevel(levelUp ? newLevel : null)
                .levelTitle(levelTitle(newLevel))
                .newBadges(newBadges.stream().map(this::toBadgeResponse).collect(Collectors.toList()))
                .build();
    }

    // ── CALCULATE XP CHO 1 PHIÊN HỌC ─────────────────────────
    public int calcXpForSession(boolean lessonCompleted, int score, int totalPoints, int streakDays) {
        int xp = 0;
        if (lessonCompleted) {
            xp += XP_COMPLETE_LESSON;
            if (totalPoints > 0 && score >= totalPoints) xp += XP_PERFECT_LESSON;
        }
        xp += XP_CORRECT_EXERCISE;
        if (streakDays > 1) xp += XP_DAILY_STREAK;
        return xp;
    }

    // ── PRIVATE HELPERS ───────────────────────────────────────
    private UserGameProfile getOrCreate(User user) {
        return gameRepo.findByUserId(user.getId())
                .orElseGet(() -> gameRepo.save(UserGameProfile.builder()
                        .user(user).totalXp(0).level(1).weeklyXp(0)
                        .weeklyXpResetAt(Instant.now()).build()));
    }

    private void resetWeeklyIfNeeded(UserGameProfile g) {
        if (g.getWeeklyXpResetAt() == null) {
            g.setWeeklyXpResetAt(Instant.now());
            return;
        }
        LocalDate resetDate = g.getWeeklyXpResetAt().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate monday    = LocalDate.now().with(DayOfWeek.MONDAY);
        if (resetDate.isBefore(monday)) {
            g.setWeeklyXp(0);
            g.setWeeklyXpResetAt(Instant.now());
        }
    }

    /** Level = floor(sqrt(totalXp / 100)) + 1 */
    private int calcLevel(int totalXp) {
        return (int) Math.floor(Math.sqrt(totalXp / 100.0)) + 1;
    }

    /** XP tối thiểu để đạt level n */
    private int xpForLevel(int level) {
        int l = level - 1;
        return l * l * 100;
    }

    private String levelTitle(int level) {
        int idx = Math.min(level, LEVEL_TITLES.length - 1);
        return LEVEL_TITLES[idx];
    }

    // ── BADGE CHECKER ─────────────────────────────────────────
    private List<UserBadge> checkAndAwardBadges(User user, UserGameProfile g) {
        List<UserBadge> earned = new ArrayList<>();

        // XP badges
        if (g.getTotalXp() >= 10000) tryAward(user, BadgeType.XP_10000, earned);
        else if (g.getTotalXp() >= 5000) tryAward(user, BadgeType.XP_5000, earned);
        else if (g.getTotalXp() >= 1000) tryAward(user, BadgeType.XP_1000, earned);

        // Lesson badges
        long completed = progressRepo.findByUserId(user.getId()).stream()
                .filter(p -> p.getStatus() == UserProgress.ProgressStatus.COMPLETED).count();
        if (completed >= 100) tryAward(user, BadgeType.LESSONS_100, earned);
        else if (completed >= 50) tryAward(user, BadgeType.LESSONS_50, earned);
        else if (completed >= 10) tryAward(user, BadgeType.LESSONS_10, earned);
        else if (completed >= 1)  tryAward(user, BadgeType.FIRST_LESSON, earned);

        // Streak badges
        List<LocalDate> dates = studyLogRepo.studyDates(user.getId(), LocalDate.now().minusDays(365));
        int streak = calcStreak(dates);
        if (streak >= 100) tryAward(user, BadgeType.STREAK_100, earned);
        else if (streak >= 30) tryAward(user, BadgeType.STREAK_30, earned);
        else if (streak >= 7)  tryAward(user, BadgeType.STREAK_7, earned);

        return earned;
    }

    private void tryAward(User user, BadgeType type, List<UserBadge> earned) {
        if (!badgeRepo.existsByUserIdAndBadgeType(user.getId(), type)) {
            earned.add(badgeRepo.save(UserBadge.builder().user(user).badgeType(type).build()));
            log.info("Badge awarded: {} → {}", user.getEmail(), type);
        }
    }

    private int calcStreak(List<LocalDate> dates) {
        if (dates.isEmpty()) return 0;
        Set<LocalDate> set = new HashSet<>(dates);
        LocalDate check = set.contains(LocalDate.now()) ? LocalDate.now()
                : set.contains(LocalDate.now().minusDays(1)) ? LocalDate.now().minusDays(1) : null;
        if (check == null) return 0;
        int streak = 0;
        for (; set.contains(check); check = check.minusDays(1)) streak++;
        return streak;
    }

    private BadgeResponse toBadgeResponse(UserBadge b) {
        return BadgeResponse.builder()
                .badgeType(b.getBadgeType())
                .name(badgeName(b.getBadgeType()))
                .description(badgeDesc(b.getBadgeType()))
                .iconUrl(badgeIcon(b.getBadgeType()))
                .earnedAt(b.getEarnedAt())
                .build();
    }

    private List<LeaderboardResponse.LeaderboardEntry> toEntries(
            List<UserGameProfile> list, boolean weekly) {
        List<LeaderboardResponse.LeaderboardEntry> result = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            UserGameProfile g = list.get(i);
            result.add(LeaderboardResponse.LeaderboardEntry.builder()
                    .rank(i + 1)
                    .userId(g.getUser().getId())
                    .userName(g.getUser().getFullName())
                    .avatarUrl(g.getUser().getAvatarUrl())
                    .xp(weekly ? g.getWeeklyXp() : g.getTotalXp())
                    .level(calcLevel(g.getTotalXp()))
                    .levelTitle(levelTitle(calcLevel(g.getTotalXp())))
                    .build());
        }
        return result;
    }

    // ── BADGE META ────────────────────────────────────────────
    private String badgeName(BadgeType t) {
        return switch (t) {
            case STREAK_7    -> "Week Warrior";
            case STREAK_30   -> "Monthly Master";
            case STREAK_100  -> "Century Streak";
            case FIRST_LESSON -> "First Step";
            case LESSONS_10  -> "Dedicated Learner";
            case LESSONS_50  -> "Knowledge Seeker";
            case LESSONS_100 -> "Century Scholar";
            case FIRST_COURSE -> "Course Completer";
            case COURSES_5   -> "Multi-Course Master";
            case PERFECT_SCORE -> "Perfectionist";
            case HIGH_SCORER -> "High Achiever";
            case XP_1000     -> "Rising Star";
            case XP_5000     -> "XP Hunter";
            case XP_10000    -> "XP Legend";
            case EARLY_BIRD  -> "Early Bird";
            case NIGHT_OWL   -> "Night Owl";
            case POLYGLOT    -> "Polyglot";
        };
    }

    private String badgeDesc(BadgeType t) {
        return switch (t) {
            case STREAK_7    -> "Học 7 ngày liên tiếp";
            case STREAK_30   -> "Học 30 ngày liên tiếp";
            case STREAK_100  -> "Học 100 ngày liên tiếp";
            case FIRST_LESSON -> "Hoàn thành bài học đầu tiên";
            case LESSONS_10  -> "Hoàn thành 10 bài học";
            case LESSONS_50  -> "Hoàn thành 50 bài học";
            case LESSONS_100 -> "Hoàn thành 100 bài học";
            case FIRST_COURSE -> "Hoàn thành khoá học đầu tiên";
            case COURSES_5   -> "Hoàn thành 5 khoá học";
            case PERFECT_SCORE -> "Đạt điểm tuyệt đối";
            case HIGH_SCORER -> "Điểm trung bình >= 90%";
            case XP_1000     -> "Tích lũy 1,000 XP";
            case XP_5000     -> "Tích lũy 5,000 XP";
            case XP_10000    -> "Tích lũy 10,000 XP";
            case EARLY_BIRD  -> "Học trước 7h sáng";
            case NIGHT_OWL   -> "Học sau 22h tối";
            case POLYGLOT    -> "Học 3 ngôn ngữ trở lên";
        };
    }

    private String badgeIcon(BadgeType t) {
        return switch (t) {
            case STREAK_7    -> "🔥";
            case STREAK_30   -> "🔥🔥";
            case STREAK_100  -> "💯🔥";
            case FIRST_LESSON -> "⭐";
            case LESSONS_10  -> "📚";
            case LESSONS_50  -> "🎓";
            case LESSONS_100 -> "🏆";
            case FIRST_COURSE -> "🎯";
            case COURSES_5   -> "🌟";
            case PERFECT_SCORE -> "💎";
            case HIGH_SCORER -> "🥇";
            case XP_1000     -> "⚡";
            case XP_5000     -> "⚡⚡";
            case XP_10000    -> "👑";
            case EARLY_BIRD  -> "🌅";
            case NIGHT_OWL   -> "🦉";
            case POLYGLOT    -> "🌍";
        };
    }
}
