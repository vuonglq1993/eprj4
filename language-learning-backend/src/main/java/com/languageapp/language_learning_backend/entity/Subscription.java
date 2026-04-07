package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import jakarta.persistence.Table;
import lombok.*;
import org.hibernate.annotations.*;
import org.hibernate.grammars.hql.HqlParser;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "subscriptions")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Subscription {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private Plan plan = Plan.FREE;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private SubStatus status = SubStatus.ACTIVE;

    private Instant startDate;
    private Instant endDate;

    @Column(nullable = false) @Builder.Default
    private Boolean autoRenew = false;

    /** ID đăng ký từ cổng thanh toán ngoài (nếu có) */
    @Column(length = 100)
    private String externalSubscriptionId;

    @CreationTimestamp private Instant createdAt;
    @UpdateTimestamp   private Instant updatedAt;

    public boolean isPremium() {
        return plan != Plan.FREE
                && status == SubStatus.ACTIVE
                && (endDate == null || endDate.isAfter(Instant.now()));
    }

    public enum Plan      { FREE, MONTHLY, THREE_MONTHS, YEARLY }
    public enum SubStatus { ACTIVE, EXPIRED, CANCELLED, PAUSED }
}
