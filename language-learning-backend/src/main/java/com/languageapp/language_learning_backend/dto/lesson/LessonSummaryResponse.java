package com.languageapp.language_learning_backend.dto.lesson;

import com.languageapp.language_learning_backend.entity.Lesson.LessonType;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LessonSummaryResponse {
    private UUID       id;
    private String     title;
    private LessonType type;
    private Integer    orderIndex;
    private Integer    durationMinutes;
    private Boolean    isFree;
    private String     progressStatus;   // NOT_STARTED / IN_PROGRESS / COMPLETED
}
