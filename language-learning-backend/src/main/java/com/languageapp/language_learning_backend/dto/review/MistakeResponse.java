package com.languageapp.language_learning_backend.dto.review;

import com.languageapp.language_learning_backend.entity.Exercise.ExerciseType;
import lombok.*;
import java.time.Instant;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class MistakeResponse {
    private UUID         exerciseId;
    private String       exerciseTitle;
    private ExerciseType exerciseType;
    private String       questionData;    // JSON nguyên để FE render
    private String       userAnswer;      // câu trả lời sai của user
    private String       correctAnswer;   // câu trả lời đúng
    private String       explanation;
    private UUID         lessonId;
    private String       lessonTitle;
    private UUID         courseId;
    private String       courseTitle;
    private Instant      attemptedAt;
    private Integer      timesWrong;      // tổng số lần sai exercise này
}
