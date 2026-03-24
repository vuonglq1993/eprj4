package com.languageapp.language_learning_backend.dto.studylog;

import lombok.*;
import java.time.LocalDate;
import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class StreakResponse {
    private int             currentStreak;
    private int             longestStreak;
    private LocalDate       lastStudyDate;
    private boolean         studiedToday;
    private List<LocalDate> studyDates;     // 30 ngày gần nhất
}
