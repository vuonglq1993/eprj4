package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

/**
 * Lưu điểm XP, level, badge của user.
 * 1 user → 1 bản ghi (OneToOne với User).
 */
@Entity
@Table(name = "user_game_profiles")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserGameProfile {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    /** Tổng XP tích lũy */
    @Column(nullable = false) @Builder.Default
    private Integer totalXp = 0;

    /** Level hiện tại (tính từ totalXp) */
    @Column(nullable = false) @Builder.Default
    private Integer level = 1;

    /** XP trong tuần này (reset mỗi thứ 2) */
    @Column(nullable = false) @Builder.Default
    private Integer weeklyXp = 0;

    /** Ngày reset weeklyXp gần nhất */
    private Instant weeklyXpResetAt;

    @Column(nullable = false)
    @Builder.Default
    private Integer currentStreak = 0;

    @Column(nullable = false)
    @Builder.Default
    private Integer longestStreak = 0;

    private Instant lastActivityAt;

    @Column(nullable = false)
    @Builder.Default
    private Integer streakFreezeCount = 3;

    @CreationTimestamp private Instant createdAt;
    @UpdateTimestamp   private Instant updatedAt;


}
