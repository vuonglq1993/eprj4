package com.languageapp.language_learning_backend.dto.payment;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubscriptionPlanRequest {
    @NotBlank @Size(max = 100) private String  name;
    private String  description;
    @NotNull @Min(0)           private Integer price;
    @NotNull @Min(1)           private Integer durationDays;
    private Boolean isActive = true;
}
