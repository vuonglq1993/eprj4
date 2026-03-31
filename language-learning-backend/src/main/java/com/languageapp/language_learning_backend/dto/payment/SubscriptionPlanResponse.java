package com.languageapp.language_learning_backend.dto.payment;

import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubscriptionPlanResponse {
    private UUID    id;
    private String  name;
    private String  description;
    private Integer price;
    private Integer durationDays;
    private Boolean isActive;
}
