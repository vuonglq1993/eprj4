package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "exercise_attempts", indexes = {
        @Index(name = "idx_attempt_user", columnList = "user_id"),
        @Index(name = "idx_attempt_exercise", columnList = "exercise_id"),
        @Index(name = "idx_attempt_progress", columnList = "progress_id")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ExerciseAttempt {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id", nullable = false)
    private Exercise exercise;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "progress_id", nullable = false)
    private UserProgress progress;

    // ⏱ thời gian bắt đầu
    private Instant startedAt;

    // ⏱ thời gian submit
    private Instant submittedAt;

    // ⏱ thời gian làm (seconds)
    private Integer durationSeconds;

    // 🎯 kết quả
    private Boolean isCorrect;

    private Integer score;

    // ❌ timeout hay không
    private Boolean isTimeout;

    // lưu answer user (JSON)
    @Column(columnDefinition = "TEXT")
    private String userAnswer;
}