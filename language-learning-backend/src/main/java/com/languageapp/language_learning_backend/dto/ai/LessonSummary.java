package com.languageapp.language_learning_backend.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LessonSummary {
    private String id;
    private String title;
    private String skill;
    private String cefrLevel;
    private int    estimatedMinutes;
}
