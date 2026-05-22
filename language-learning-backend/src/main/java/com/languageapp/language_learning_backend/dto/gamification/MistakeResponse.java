package com.languageapp.language_learning_backend.dto.gamification;

import com.languageapp.language_learning_backend.entity.Exercise.ExerciseType;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Data @Builder
public class MistakeResponse {
    private UUID   exerciseId;
    private String exerciseTitle;
    private ExerciseType exerciseType;
    private String lessonTitle;
    private String questionData;
    private String selectedAnswer;
    private Instant submittedAt;
}
