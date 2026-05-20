package com.languageapp.language_learning_backend.entity;

import com.languageapp.language_learning_backend.converter.StringListConverter;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "subscription_plans")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubscriptionPlan {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Integer price; // VNĐ (vd: 99000)

    @Column(nullable = false)
    private Integer durationDays; // 30, 90, 365

    @Convert(converter = StringListConverter.class)
    @Column(columnDefinition = "LONGTEXT")
    @Builder.Default
    private List<String> features = new java.util.ArrayList<>();

    @Column(nullable = false)
    @Builder.Default
    private Boolean isActive = true;
}