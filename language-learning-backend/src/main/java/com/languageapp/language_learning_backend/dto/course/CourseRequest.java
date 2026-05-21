package com.languageapp.language_learning_backend.dto.course;

import com.languageapp.language_learning_backend.entity.Course.Level;
import jakarta.validation.constraints.*;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CourseRequest {
    @NotBlank @Size(min=3, max=150) private String  title;
    @Size(max=5000)                 private String  description;
    @NotNull                        private UUID    languageId;
    @NotNull                        private Level   level;
    private Boolean isPublished = false;
}
