package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Lộ trình học — tập hợp các Course theo thứ tự.
 * Ví dụ: "English từ 0 đến B2", "Nhật ngữ JLPT N5 → N3"
 */
@Entity
@Table(name = "learning_paths", indexes = {
        @Index(name = "idx_lp_language",  columnList = "language_id"),
        @Index(name = "idx_lp_published", columnList = "is_published")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LearningPath {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_id", nullable = false)
    private Language language;

    @Column(nullable = false, length = 150)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 500)
    private String thumbnailUrl;

    /** BEGINNER / INTERMEDIATE / ADVANCED */
    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private TargetLevel targetLevel;

    /** Mục tiêu: "Đạt JLPT N3", "Giao tiếp B2"... */
    @Column(length = 300)
    private String goal;

    /** Thời gian ước tính (giờ) */
    @Column(nullable = false) @Builder.Default
    private Integer estimatedHours = 0;

    @Column(nullable = false) @Builder.Default
    private Boolean isPublished = false;

    @Column(nullable = false) @Builder.Default
    private Boolean isOfficial = false;   // true = do Admin tạo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    /** Danh sách course trong lộ trình (có thứ tự) */
    @OneToMany(mappedBy = "learningPath", cascade = CascadeType.ALL,
            fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("stepOrder ASC")
    @Builder.Default
    private List<LearningPathStep> steps = new ArrayList<>();

    @CreationTimestamp private Instant createdAt;
    @UpdateTimestamp   private Instant updatedAt;

    public enum TargetLevel { BEGINNER, INTERMEDIATE, ADVANCED }
}
