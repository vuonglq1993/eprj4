package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "records", indexes = {
        @Index(name = "idx_record_user", columnList = "user_id"),
        @Index(name = "idx_record_lesson", columnList = "lesson_id"),
        @Index(name = "idx_record_type", columnList = "type")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Record {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @Column(length = 150)
    private String title;

    @Column(length = 500, nullable = false)
    private String audioUrl;

    @Column(length = 255)
    private String publicId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private RecordType type;

    //  USER (cho USER_PRACTICE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    //  LESSON (cho LESSON_AUDIO + LISTENING)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id")
    private Exercise exercise;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    public enum RecordType {
        LESSON_AUDIO,
        LISTENING,
        USER_PRACTICE
    }
}