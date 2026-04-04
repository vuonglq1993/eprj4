package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Chủ đề học (Travel, Food, Business, Daily Life...).
 * Một Topic có thể gắn với nhiều Course (qua bảng course_topics).
 */
@Entity
@Table(name = "topics")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Topic {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;           // "Travel", "Business", "Daily Life"

    @Column(length = 500)
    private String description;

    @Column(length = 100)
    private String iconUrl;        // emoji hoặc URL icon

    @Column(nullable = false) @Builder.Default
    private Boolean isActive = true;

    /** Số thứ tự hiển thị */
    @Column(nullable = false) @Builder.Default
    private Integer orderIndex = 0;

    @ManyToMany(mappedBy = "topics", fetch = FetchType.LAZY)
    @Builder.Default
    private List<Course> courses = new ArrayList<>();
}

