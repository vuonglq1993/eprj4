package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.*;

@Entity
@Table(name = "lessons", indexes = {
        @Index(name = "idx_lessons_course", columnList = "course_id"),
        @Index(name = "idx_lessons_type",   columnList = "type"),
        @Index(name = "idx_lessons_order",  columnList = "course_id,order_index")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Lesson {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @Column(nullable = false, length = 150)
    private String title;

    /** Nội dung bài học — HTML hoặc Markdown */
    @Column(columnDefinition = "TEXT")
    private String content;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private LessonType type;

    @Column(length = 500) private String  videoUrl;
    @Column(length = 500) private String  audioUrl;

    @Column(nullable = false) @Builder.Default private Integer orderIndex      = 0;
    @Column(nullable = false) @Builder.Default private Integer durationMinutes = 0;
    @Column(nullable = false) @Builder.Default private Boolean isFree          = false;

    @OneToMany(mappedBy = "lesson", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Exercise> exercises = new ArrayList<>();

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;

    public enum LessonType { VOCABULARY, GRAMMAR, LISTENING, SPEAKING, READING, WRITING, MIXED }
}
