package com.languageapp.language_learning_backend.dto.exercise;

import jakarta.validation.constraints.*;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubmitRequest {
    @NotNull  private UUID   exerciseId;
    @NotBlank private String answer;
    private Long clientStartTime;   // ms, FE gửi lúc hiện câu hỏi
    private Long clientSubmitTime;  // ms, FE gửi lúc bấm submit / hết giờ
}