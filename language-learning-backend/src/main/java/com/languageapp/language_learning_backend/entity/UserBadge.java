package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

/**
 * Badge user đã đạt được.
 */
@Entity
@Table(name = "user_badges", indexes = {
        @Index(name = "idx_badge_user", columnList = "user_id")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserBadge {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private BadgeType badgeType;

    @CreationTimestamp
    private Instant earnedAt;

    public enum BadgeType {
        // Streak badges
        STREAK_7,       // 7 ngày liên tiếp
        STREAK_30,      // 30 ngày liên tiếp
        STREAK_100,     // 100 ngày liên tiếp

        // Lesson badges
        FIRST_LESSON,   // Hoàn thành bài học đầu tiên
        LESSONS_10,     // Hoàn thành 10 bài
        LESSONS_50,     // Hoàn thành 50 bài
        LESSONS_100,    // Hoàn thành 100 bài

        // Course badges
        FIRST_COURSE,   // Hoàn thành khoá đầu tiên
        COURSES_5,      // Hoàn thành 5 khoá

        // Score badges
        PERFECT_SCORE,  // Đạt 100% 1 bài
        HIGH_SCORER,    // Điểm TB >= 90%

        // XP badges
        XP_1000,        // Đạt 1000 XP
        XP_5000,        // Đạt 5000 XP
        XP_10000,       // Đạt 10000 XP

        // Special
        EARLY_BIRD,     // Học trước 7h sáng
        NIGHT_OWL,      // Học sau 22h
        POLYGLOT        // Học 3+ ngôn ngữ
    }
}
