package com.languageapp.language_learning_backend.dto.subscription;

import lombok.*;

import java.time.Instant;
import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubscriptionStatusResponse {
    private String        plan;
    private String        status;
    private Instant startDate;
    private Instant endDate;
    private boolean       autoRenew;
    private boolean       isPremium;
    private long          daysRemaining;
}
