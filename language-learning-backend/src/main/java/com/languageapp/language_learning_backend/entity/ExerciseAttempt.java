package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "user_exercise_attempts", indexes = {
        @Index(name = "idx_attempt_user_lesson", columnList = "user_id, lesson_id"),
        @Index(name = "idx_attempt_wrong", columnList = "user_id, is_correct")
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
    @JoinColumn(name = "lesson_id", nullable = false)
    private Lesson lesson;

    @Column(columnDefinition = "JSON")
    private String selectedAnswer;

    @Column(nullable = false)
    private Boolean isCorrect;

    @Column(nullable = false) @Builder.Default
    private Integer score = 0;

    private Integer timeSpentSeconds;

    @CreationTimestamp
    private Instant submittedAt;
}
