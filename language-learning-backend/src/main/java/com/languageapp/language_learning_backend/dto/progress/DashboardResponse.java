package com.languageapp.language_learning_backend.dto.progress;

import lombok.*;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DashboardResponse {
    private int                        totalCoursesEnrolled;
    private int                        totalLessonsCompleted;
    private int                        totalExercisesDone;
    private int                        currentStreak;
    private int                        longestStreak;
    private int                        totalStudyMinutes;
    private double                     averageScore;
    private List<CourseProgressSummary> activeCourses;
    private WeeklySummary              thisWeek;
    private SkillBreakdown             skills;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class CourseProgressSummary {
        private UUID    courseId;
        private String  courseTitle;
        private String  languageName;
        private String  thumbnailUrl;
        private int     totalLessons;
        private int     completedLessons;
        private int     progressPercent;
        private double  averageScore;
        private UUID    nextLessonId;
        private String  nextLessonTitle;
    }

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class WeeklySummary {
        private int             studyMinutes;
        private int             lessonsCompleted;
        private double          averageScore;
        private List<DailyStudy> daily;

        @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
        public static class DailyStudy {
            private LocalDate date;
            private String    dayLabel;
            private int       studyMinutes;
            private int       lessonsCompleted;
        }
    }

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class SkillBreakdown {
        private SkillScore listening;
        private SkillScore speaking;
        private SkillScore reading;
        private SkillScore writing;
        private SkillScore vocabulary;
        private SkillScore grammar;

        @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
        public static class SkillScore {
            private double averageScore;
            private int    lessonsCompleted;
            private String level;   // Beginner / Intermediate / Advanced
        }
    }
}
