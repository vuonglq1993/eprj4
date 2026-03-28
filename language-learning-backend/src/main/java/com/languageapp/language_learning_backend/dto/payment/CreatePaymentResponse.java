package com.languageapp.language_learning_backend.dto.payment;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CreatePaymentResponse {
    private String        transactionId;
    private String        paymentUrl;
    private String        gateway;
    private BigDecimal    amount;
    private String        currency;
    private String        plan;
    private LocalDateTime expiredAt;
}
