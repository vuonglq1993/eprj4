package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

/**
 * Thẻ flashcard — 1 mặt là từ/câu, mặt kia là nghĩa/dịch.
 * Gắn với Lesson hoặc standalone.
 */
@Entity
@Table(name = "flashcards", indexes = {
        @Index(name = "idx_fc_lesson", columnList = "lesson_id"),
        @Index(name = "idx_fc_lang",   columnList = "language_id")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Flashcard {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id")
    private Lesson lesson;              // null nếu standalone

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_id", nullable = false)
    private Language language;

    @Column(nullable = false, length = 300)
    private String front;               // từ / câu gốc

    @Column(nullable = false, length = 500)
    private String back;                // nghĩa / bản dịch

    @Column(length = 200)
    private String pronunciation;       // phiên âm: /ˈæp.əl/

    @Column(length = 500)
    private String example;             // câu ví dụ

    @Column(length = 500)
    private String imageUrl;

    @Column(length = 500)
    private String audioUrl;

    @Enumerated(EnumType.STRING)
    @Column(length = 20) @Builder.Default
    private CardType cardType = CardType.VOCABULARY;

    @Column(nullable = false) @Builder.Default
    private Boolean isActive = true;

    @CreationTimestamp private Instant createdAt;

    public enum CardType { VOCABULARY, PHRASE, GRAMMAR, SENTENCE }
}
