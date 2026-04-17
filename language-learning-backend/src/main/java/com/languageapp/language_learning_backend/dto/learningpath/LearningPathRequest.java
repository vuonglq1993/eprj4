package com.languageapp.language_learning_backend.dto.learningpath;

import com.languageapp.language_learning_backend.entity.LearningPath.TargetLevel;
import jakarta.validation.constraints.*;
import lombok.*;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LearningPathRequest {
    @NotNull                        private UUID        languageId;
    @NotBlank @Size(min=3, max=150) private String      title;
    @Size(max=5000)                 private String      description;
    @Size(max=500)                  private String      thumbnailUrl;
    @NotNull                        private TargetLevel targetLevel;
    @Size(max=300)                  private String      goal;
    private Integer estimatedHours = 0;
    private Boolean isPublished    = false;
    private Boolean isOfficial     = false;

    /** Danh sách courseId theo thứ tự */
    @NotEmpty
    private List<StepItem> steps;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class StepItem {
        @NotNull private UUID    courseId;
        @Size(max=300) private String note;
        private Boolean isRequired = true;
    }
}
