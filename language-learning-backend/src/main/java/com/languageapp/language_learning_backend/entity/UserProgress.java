package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "user_progress", indexes = {
        @Index(name = "idx_progress_user",         columnList = "user_id"),
        @Index(name = "idx_progress_user_lesson",  columnList = "user_id,lesson_id", unique = true),
        @Index(name = "idx_progress_user_course",  columnList = "user_id,course_id")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserProgress {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    private Lesson lesson;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private ProgressStatus status = ProgressStatus.NOT_STARTED;

    @Column(nullable = false) @Builder.Default private Integer score            = 0;
    @Column(nullable = false) @Builder.Default private Integer attempts         = 0;
    @Column(nullable = false) @Builder.Default private Integer timeSpentSeconds = 0;


    private Instant startedAt;
    private Instant completedAt;

    @UpdateTimestamp
    private Instant updatedAt;


    public enum ProgressStatus { NOT_STARTED, IN_PROGRESS, COMPLETED }
}
