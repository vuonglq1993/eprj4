package com.languageapp.language_learning_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
import org.hibernate.type.SqlTypes;
import org.hibernate.annotations.UuidGenerator;
import org.hibernate.annotations.JdbcTypeCode;

@Entity
@Table(name = "payment_transactions", indexes = {
        @Index(name = "idx_payment_user",   columnList = "user_id"),
        @Index(name = "idx_payment_status", columnList = "status"),
        @Index(name = "idx_payment_gw_ref", columnList = "gateway_ref")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class PaymentTransaction {

    @Id
    @UuidGenerator
    @JdbcTypeCode(SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 10)
    private String currency;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Gateway gateway;

    /** Order ID / Transaction ID từ cổng thanh toán */
    @Column(length = 200)
    private String gatewayRef;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private TxStatus status = TxStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Plan plan;

    private LocalDateTime paidAt;

    @Column(columnDefinition = "TEXT")
    private String rawWebhook;      // raw JSON từ webhook — để debug

    @Column(columnDefinition = "TEXT")
    private String failureReason;

    @CreationTimestamp private LocalDateTime createdAt;

    public enum Gateway  { MOMO, ZALOPAY, VNPAY, PAYPAL, STRIPE }
    public enum TxStatus { PENDING, SUCCESS, FAILED, REFUNDED, CANCELLED }
    public enum Plan     { MONTHLY, YEARLY }
}
