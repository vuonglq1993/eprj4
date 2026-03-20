package com.languageapp.language_learning_backend.dto.exercise;

import com.languageapp.language_learning_backend.entity.Exercise.ExerciseType;
import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ExerciseRequest {
    @NotBlank @Size(min=3, max=150) private String       title;
    @NotNull                        private ExerciseType type;
    @NotBlank                       private String       questionData;   // JSON string
    @Min(0)                         private Integer      orderIndex       = 0;
    @Min(1)                         private Integer      points           = 10;
    @Min(0)                         private Integer      timeLimitSeconds = 0;
}
