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
public class PronunciationAudioRequest {
    @NotBlank
    private String targetText;
    @NotBlank
    private String audioUrl;   // URL Cloudinary của bản ghi âm
    private String cefrLevel = "B1";
}
