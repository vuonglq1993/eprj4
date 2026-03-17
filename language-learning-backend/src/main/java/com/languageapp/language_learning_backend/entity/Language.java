package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.type.SqlTypes;

import java.util.*;

@Entity
@Table(name = "languages")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Language {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    /** ISO 639-1: en, ja, ko, zh, fr, vi */
    @Column(nullable = false, unique = true, length = 10)
    private String code;

    /** Tiếng Anh: English, Japanese */
    @Column(nullable = false, length = 100)
    private String name;

    /** Bản ngữ: English, 日本語, 한국어 */
    @Column(nullable = false, length = 100)
    private String nativeName;

    /** Emoji cờ: 🇺🇸 🇯🇵 */
    @Column(length = 20)
    private String flag;

    @Column(nullable = false) @Builder.Default
    private Boolean isActive = true;

    @OneToMany(mappedBy = "language", fetch = FetchType.LAZY)
    @Builder.Default
    private List<Course> courses = new ArrayList<>();
}
