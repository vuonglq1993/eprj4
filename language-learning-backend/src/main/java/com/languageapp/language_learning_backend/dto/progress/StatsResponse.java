package com.languageapp.language_learning_backend.dto.progress;

import lombok.*;
import java.time.LocalDate;
import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class StatsResponse {
    private String          period;   // WEEK / MONTH / YEAR
    private int             totalLessons;
    private int             totalMinutes;
    private double          averageScore;
    private List<PeriodStat> data;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class PeriodStat {
        private LocalDate date;
        private String    label;
        private int       studyMinutes;
        private int       lessonsCompleted;
    }
}
