package com.languageapp.language_learning_backend.dto.ai;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabGameRequest {
    @NotBlank
    private String word;
    private String gameType  = "MULTIPLE_CHOICE"; // MULTIPLE_CHOICE, SPELLING, SENTENCE
    private String cefrLevel = "B1";
}
