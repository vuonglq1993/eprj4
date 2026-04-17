package com.languageapp.language_learning_backend.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiChatResponse {
    private String reply;
    private String model;
    private int    inputTokens;
    private int    outputTokens;
    private long   remainingToday;  // số lần còn lại trong ngày theo plan
}
