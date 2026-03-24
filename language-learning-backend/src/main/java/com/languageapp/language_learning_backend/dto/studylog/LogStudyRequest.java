package com.languageapp.language_learning_backend.dto.studylog;

import com.languageapp.language_learning_backend.entity.StudyLog.ActivityType;
import jakarta.validation.constraints.*;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LogStudyRequest {
    @NotNull                    private UUID         lessonId;
    @Min(0) @Max(7200)          private int          durationSeconds;
    @NotNull                    private ActivityType activityType;
    @Min(0) @Max(100)           private int          score;
}
