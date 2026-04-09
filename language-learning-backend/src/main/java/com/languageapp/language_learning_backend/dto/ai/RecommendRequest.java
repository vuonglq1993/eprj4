package com.languageapp.language_learning_backend.dto.ai;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecommendRequest {
    private double       avgScore;
    private List<String> weakSkills;             // ["Listening", "Speaking"]
    private String       learningPace;           // "SLOW", "NORMAL", "FAST"
    private List<String> completedLessonIds;
    private List<LessonSummary> availableLessons;


}
