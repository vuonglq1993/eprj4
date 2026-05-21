package com.languageapp.language_learning_backend.dto.progress;

import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import lombok.*;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ProgressResponse {
    private UUID           lessonId;
    private String         lessonTitle;
    private String         lessonType;
    private ProgressStatus status;
    private Integer        score;
    private Integer        bestScore;
    private Integer        scorePercent;
    private Integer        attempts;
    private Integer        timeSpentMinutes;
    private Instant completedAt;
    private Instant  updatedAt;
}
