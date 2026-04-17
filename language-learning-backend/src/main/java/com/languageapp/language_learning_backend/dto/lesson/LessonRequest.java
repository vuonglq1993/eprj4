package com.languageapp.language_learning_backend.dto.lesson;
import com.languageapp.language_learning_backend.entity.Lesson.LessonType;
import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LessonRequest {
    @NotBlank @Size(min=3, max=150) private String     title;
    private String     content;
    @NotNull                        private LessonType type;
    private String     videoUrl;
    private String     audioUrl;
    @Min(0)                         private Integer    orderIndex      = 0;
    @Min(0)                         private Integer    durationMinutes = 0;
    private Boolean    isFree          = false;
    /**
     * PREVIEW / MONTHLY / UNLIMITED.
     * Nếu null: backend sẽ tự map PREVIEW khi isFree=true, ngược lại UNLIMITED.
     */
    private String     accessTier;
}
