package com.languageapp.language_learning_backend.dto.progress;

import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ProgressResponse {
    private UUID           lessonId;
    private String         lessonTitle;
    private String         lessonType;
    private ProgressStatus status;
    private Integer        score;
    private Integer        attempts;
    private Integer        timeSpentMinutes;
    private LocalDateTime  completedAt;
    private LocalDateTime  updatedAt;
}
