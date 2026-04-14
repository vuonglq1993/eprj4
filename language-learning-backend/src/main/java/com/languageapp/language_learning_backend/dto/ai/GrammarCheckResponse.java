package com.languageapp.language_learning_backend.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GrammarCheckResponse {
    private String             original;
    private String             corrected;
    private boolean            isCorrect;
    private List<GrammarError> errors;
    private String             betterExpression;
    private String             tip;

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class GrammarError {
        private String type;          // GRAMMAR / SPELLING / PUNCTUATION
        private String wrong;
        private String correct;
        private String explanation;
        private String rule;
    }
}
