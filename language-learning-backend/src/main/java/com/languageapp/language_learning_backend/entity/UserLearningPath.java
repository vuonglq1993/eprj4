package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

/**
 * User đăng ký theo dõi một LearningPath.
 */
@Entity
@Table(name = "user_learning_paths", indexes = {
        @Index(name = "idx_ulp_user",          columnList = "user_id"),
        @Index(name = "idx_ulp_user_path",     columnList = "user_id,learning_path_id", unique = true)
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserLearningPath {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "learning_path_id", nullable = false)
    private LearningPath learningPath;

    /** Bước hiện tại đang học (stepOrder) */
    @Column(nullable = false) @Builder.Default
    private Integer currentStep = 0;

    /** % hoàn thành toàn bộ path */
    @Column(nullable = false) @Builder.Default
    private Integer progressPercent = 0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20) @Builder.Default
    private PathStatus status = PathStatus.IN_PROGRESS;

    private Instant completedAt;

    @CreationTimestamp private Instant enrolledAt;
    @UpdateTimestamp   private Instant updatedAt;

    public enum PathStatus { IN_PROGRESS, COMPLETED, PAUSED }
}
