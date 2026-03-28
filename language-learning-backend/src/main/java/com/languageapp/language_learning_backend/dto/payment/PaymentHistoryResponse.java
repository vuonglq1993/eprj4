package com.languageapp.language_learning_backend.dto.payment;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class PaymentHistoryResponse {
    private UUID          id;
    private String        gateway;
    private BigDecimal    amount;
    private String        currency;
    private String        plan;
    private String        status;
    private String        gatewayRef;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
}
