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
 * Lưu kết quả Onboarding của user sau khi hoàn thành flow setup ban đầu.
 * Dùng để recommend Learning Path phù hợp.
 */
@Entity
@Table(name = "user_onboardings",
        indexes = @Index(name = "idx_onboarding_user", columnList = "user_id", unique = true))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserOnboarding {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    /** Ngôn ngữ muốn học (language.id) */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_language_id")
    private Language targetLanguage;

    /** Ngôn ngữ mẹ đẻ (language.code: "vi", "en"...) */
    @Column(length = 10)
    private String nativeLanguageCode;

    /** Trình độ tự đánh giá */
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private SelfLevel selfLevel;

    /** Mục tiêu học */
    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private LearningGoal goal;

    /** Số phút học mỗi ngày */
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private DailyTime dailyTime;

    /** Nhóm tuổi */
    @Column(length = 20)
    private String ageGroup;    // "Under 18", "18-24"...

    /** Nguồn biết app */
    @Column(length = 50)
    private String heardFrom;

    /** Đã hoàn thành onboarding chưa */
    @Column(nullable = false) @Builder.Default
    private Boolean completed = false;

    /** Learning Path được gợi ý sau onboarding */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recommended_path_id")
    private LearningPath recommendedPath;

    @CreationTimestamp private Instant createdAt;
    @UpdateTimestamp   private Instant updatedAt;

    // ── Enums ─────────────────────────────────────────────────
    public enum SelfLevel {
        COMPLETE_BEGINNER,   // "I don't know anything"
        BEGINNER,            // "I know a little"
        INTERMEDIATE,        // "I can have basic conversations"
        ADVANCED             // "I know a lot"
    }

    public enum LearningGoal {
        TRAVEL, SCHOOL, WORK, FAMILY_FRIENDS, SKILL_IMPROVEMENT, OTHERS
    }

    public enum DailyTime {
        FIVE_MIN,     // 5 min/day
        FIFTEEN_MIN,  // 15 min/day
        THIRTY_MIN,   // 30 min/day
        SIXTY_MIN     // 60 min/day
    }
}
