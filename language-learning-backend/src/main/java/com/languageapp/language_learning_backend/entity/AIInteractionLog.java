package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
import org.hibernate.type.SqlTypes;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.annotations.JdbcTypeCode;

@Entity
@Table(name = "ai_interaction_logs", indexes = {
        @Index(name = "idx_ai_user",  columnList = "user_id"),
        @Index(name = "idx_ai_type",  columnList = "interaction_type"),
        @Index(name = "idx_ai_date",  columnList = "created_at")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class AIInteractionLog {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private InteractionType interactionType;

    @Column(length = 50)
    private String model;                   // gpt-4o-mini, whisper-1, ...

    @Column(columnDefinition = "TEXT")
    private String prompt;                  // truncated to 2000 chars

    @Column(columnDefinition = "TEXT")
    private String response;                // truncated to 5000 chars

    @Column(nullable = false) @Builder.Default private Integer inputTokens  = 0;
    @Column(nullable = false) @Builder.Default private Integer outputTokens = 0;
    @Column(nullable = false) @Builder.Default private Integer totalTokens  = 0;

    @Column(precision = 10, scale = 6)
    private BigDecimal cost;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private AIStatus status = AIStatus.SUCCESS;

    @Column(columnDefinition = "TEXT")
    private String errorMessage;

    private Integer latencyMs;

    /** Bài học liên quan (optional) */
    @Column(columnDefinition = "VARCHAR(36)")
    private UUID lessonId;

    @CreationTimestamp private LocalDateTime createdAt;

    public enum InteractionType {
        CHAT_EXPLAIN, GRAMMAR_CHECK, PRONUNCIATION, RECOMMENDATION, PLACEMENT_TEST
    }
    public enum AIStatus { SUCCESS, FAILED, TIMEOUT }
}
