package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.time.*;
import java.util.UUID;

@Entity
@Table(name = "study_logs", indexes = {
        @Index(name = "idx_study_user_date", columnList = "user_id,study_date"),
        @Index(name = "idx_study_date",      columnList = "study_date")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class StudyLog {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id")
    private Lesson lesson;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id")
    private Course course;

    @Column(nullable = false)
    private LocalDate studyDate;

    @Column(nullable = false) @Builder.Default private Integer durationSeconds = 0;
    @Column(nullable = false) @Builder.Default private Integer score           = 0;

    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private ActivityType activityType;

    @CreationTimestamp private LocalDateTime createdAt;

    public enum ActivityType {
        LESSON_VIEW, EXERCISE_SUBMIT, AI_CHAT, PRONUNCIATION_PRACTICE
    }
}
