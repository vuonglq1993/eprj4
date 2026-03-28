package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "exercises", indexes = {
        @Index(name = "idx_exercises_lesson", columnList = "lesson_id"),
        @Index(name = "idx_exercises_type",   columnList = "type"),
        @Index(name = "idx_exercises_order",  columnList = "lesson_id,order_index")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Exercise {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    private Lesson lesson;

    @Column(nullable = false, length = 150)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ExerciseType type;

    /**
     * JSON chứa nội dung câu hỏi theo từng loại:
     *
     * MULTIPLE_CHOICE / LISTENING_CHOICE:
     *   {"question":"...", "options":["a","b","c","d"],
     *    "correctIndex":0, "explanation":"..."}
     *
     * FILL_IN_BLANK / TRANSLATION:
     *   {"question":"...", "answer":"...",
     *    "hints":["..."], "explanation":"..."}
     *
     * MATCHING:
     *   {"pairs":[{"left":"...","right":"..."}]}
     *
     * SPEAKING:
     *   {"targetText":"...", "language":"en"}
     */
    @Column(nullable = false, columnDefinition = "JSON")
    private String questionData;

    @Column(nullable = false) @Builder.Default private Integer orderIndex       = 0;
    @Column(nullable = false) @Builder.Default private Integer points           = 10;
    @Column(nullable = false) @Builder.Default private Integer timeLimitSeconds = 0;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;
    public enum ExerciseType {
        MULTIPLE_CHOICE, FILL_IN_BLANK, LISTENING_CHOICE, SPEAKING, TRANSLATION, MATCHING
    }
}
