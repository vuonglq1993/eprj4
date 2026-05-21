package com.languageapp.language_learning_backend.dto.exercise;

import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubmitResponse {
    private Boolean correct;
    private Integer pointsEarned;
    private String  correctAnswer;
    private String  explanation;
    private Integer totalLessonScore;   // tổng điểm bài học sau khi nộp
    @Builder.Default private Boolean isTimeout = false;
    @Builder.Default private Boolean isCourseCompleted = false;
    private UUID courseId;
    @Builder.Default private Boolean isLessonCompleted = false;
    private String lessonStatus;
}
