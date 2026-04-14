package com.languageapp.language_learning_backend.dto.report;

import lombok.*;
import java.time.LocalDate;
import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class WeeklyReportResponse {

    private LocalDate weekStart;
    private LocalDate weekEnd;

    // Tổng quan
    private Integer totalStudyMinutes;
    private Integer totalLessonsCompleted;
    private Integer totalExercisesDone;
    private Double  averageScore;
    private Integer currentStreak;
    private Integer xpEarnedThisWeek;

    // So với tuần trước
    private Integer minutesVsLastWeek;    // + hoặc -
    private Integer lessonsVsLastWeek;
    private Double  scoreVsLastWeek;

    // Chi tiết từng ngày
    private List<DailyReport> daily;

    // Kỹ năng mạnh/yếu
    private String strongestSkill;
    private String weakestSkill;

    // Khoá đang học + tiến độ
    private List<CourseProgress> courses;

    // Badge mới đạt được tuần này
    private List<String> newBadges;

    // Thông điệp động viên
    private String motivationMessage;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class DailyReport {
        private LocalDate date;
        private String    dayLabel;        // "Mon", "Tue"...
        private Integer   studyMinutes;
        private Integer   lessonsCompleted;
        private Double    averageScore;
        private Boolean   studiedToday;
    }

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class CourseProgress {
        private String  courseTitle;
        private Integer progressPercent;
        private Integer lessonsThisWeek;
    }
}