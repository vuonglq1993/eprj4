package com.languageapp.language_learning_backend.dto.payment;

import com.languageapp.language_learning_backend.entity.PaymentTransaction.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CreatePaymentRequest {
    @NotNull private Plan    plan;
    @NotNull private Gateway gateway;
}
