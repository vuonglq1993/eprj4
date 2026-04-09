package com.languageapp.language_learning_backend.dto.ai;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiChatRequest {
    private UUID lessonId;                  // optional — giới hạn context trong bài học
    private String lessonTitle;               // optional — client có thể gửi trực tiếp
    private String lessonContent;             // optional
    private String cefrLevel = "B1";

    @NotBlank
    @Size(max = 2000)
    private String message;
}