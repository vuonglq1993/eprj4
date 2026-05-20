package com.languageapp.language_learning_backend.dto.payment;

import lombok.*;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubscriptionPlanResponse {
    private UUID         id;
    private String       name;
    private String       description;
    private Integer      price;
    private Integer      durationDays;
    private List<String> features;
    private Boolean      isActive;
}
