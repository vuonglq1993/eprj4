package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Index;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;
import java.time.Instant;
import java.util.*;

@Entity
@Table(name = "courses", indexes = {
        @Index(name = "idx_courses_language",  columnList = "language_id"),
        @Index(name = "idx_courses_level",     columnList = "level"),
        @Index(name = "idx_courses_published", columnList = "is_published"),
        @Index(name = "idx_courses_creator",   columnList = "created_by")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Course {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_id", nullable = false)
    private Language language;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @Column(nullable = false, length = 150)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private Level level;

    @Column(length = 500)
    private String thumbnailUrl;

    @Column(nullable = false) @Builder.Default private Boolean isPublished  = false;
    @Column(nullable = false) @Builder.Default private Integer totalLessons = 0;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("orderIndex ASC")
    @Builder.Default
    private List<Lesson> lessons = new ArrayList<>();

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;
    /** Danh sách chủ đề của khoá học */
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "course_topics",
            joinColumns        = @JoinColumn(name = "course_id"),
            inverseJoinColumns = @JoinColumn(name = "topic_id")
    )
    @Builder.Default
    private List<Topic> topics = new ArrayList<>();

    /** Các bước lộ trình chứa khoá học này */
    @OneToMany(mappedBy = "course", fetch = FetchType.LAZY)
    @Builder.Default
    private List<LearningPathStep> learningPathSteps = new ArrayList<>();
    public enum Level { BEGINNER, ELEMENTARY, INTERMEDIATE, UPPER_INTERMEDIATE, ADVANCED }
}