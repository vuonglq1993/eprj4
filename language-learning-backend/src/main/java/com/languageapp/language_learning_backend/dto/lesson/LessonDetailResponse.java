package com.languageapp.language_learning_backend.dto.lesson;

import com.languageapp.language_learning_backend.entity.Lesson.LessonType;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LessonDetailResponse {
    private UUID          id;
    private UUID          courseId;
    private String        title;
    private String        content;
    private LessonType    type;
    private String        videoUrl;
    private String        audioUrl;
    private Integer       orderIndex;
    private Integer       durationMinutes;
    private Boolean       isFree;
    private Integer       totalExercises;
    private Instant       createdAt;
    // Populated nếu user đã login
    private String        progressStatus;
    private Integer       score;
}
