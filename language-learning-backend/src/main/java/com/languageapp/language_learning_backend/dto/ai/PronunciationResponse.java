package com.languageapp.language_learning_backend.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PronunciationResponse {
    private int    score;           // 0-100
    private String cefrLevel;
    private String feedback;
    private String phonemeErrors;
    private String improvement;
}
