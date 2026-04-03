package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;
import java.util.UUID;

/**
 * Một bước trong LearningPath — ánh xạ tới một Course.
 */
@Entity
@Table(name = "learning_path_steps", indexes = {
        @Index(name = "idx_lps_path",   columnList = "learning_path_id"),
        @Index(name = "idx_lps_course", columnList = "course_id"),
        @Index(name = "idx_lps_order",  columnList = "learning_path_id,step_order", unique = true)
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LearningPathStep {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "learning_path_id", nullable = false)
    private LearningPath learningPath;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @Column(name = "step_order", nullable = false)
    private Integer stepOrder;

    /** Ghi chú cho bước này: "Hoàn thành trước khi qua bước 2" */
    @Column(length = 300)
    private String note;

    /** Có bắt buộc hoàn thành bước này trước khi unlock bước tiếp? */
    @Column(nullable = false) @Builder.Default
    private Boolean isRequired = true;
}
