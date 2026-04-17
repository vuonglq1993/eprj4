package com.languageapp.language_learning_backend.dto.exercise;

import com.languageapp.language_learning_backend.entity.Exercise.ExerciseType;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ExerciseResponse {
    private UUID         id;
    private UUID         lessonId;
    private String       title;
    private ExerciseType type;
    private String       questionData;
    private String       audioUrl;
    private Integer      orderIndex;
    private Integer      points;
    private Integer      timeLimitSeconds;
}