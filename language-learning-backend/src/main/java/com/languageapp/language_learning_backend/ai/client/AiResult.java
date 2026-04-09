package com.languageapp.language_learning_backend.ai.client;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
public class AiResult {
     String text;
     String model;
     int inTokens;
     int outTokens;
     BigDecimal cost;
     Integer latencyMs;
}