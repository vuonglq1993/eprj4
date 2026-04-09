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
public class PronunciationRequest {
    @NotBlank
    private String targetText;
    @NotBlank private String recognizedText; // từ Whisper hoặc Web Speech API
    private String cefrLevel = "B1";
}


