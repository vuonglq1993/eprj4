package com.languageapp.language_learning_backend.dto.learningpath;

import com.languageapp.language_learning_backend.entity.LearningPath.TargetLevel;
import lombok.*;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LearningPathResponse {
    private UUID        id;
    private String      title;
    private String      description;
    private String      thumbnailUrl;
    private String      languageCode;
    private String      languageName;
    private TargetLevel targetLevel;
    private String      goal;
    private Integer     estimatedHours;
    private Boolean     isPublished;
    private Boolean     isOfficial;
    private Integer     totalSteps;
    private Integer     totalCourses;  // alias cho totalSteps (để tương thích frontend)
    private String      createdByName;
    private Instant     createdAt;

    // Chỉ có khi user đã login
    private Integer     progressPercent;
    private Integer     currentStep;
    private String      enrollStatus;       // null / IN_PROGRESS / COMPLETED / PAUSED

    private List<StepResponse> steps;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class StepResponse {
        private UUID    stepId;
        private Integer stepOrder;
        private UUID    courseId;
        private String  courseTitle;
        private String  courseLevel;
        private String  thumbnailUrl;
        private Integer totalLessons;
        private String  note;
        private Boolean isRequired;
        // Tiến độ của user trong course này
        private Integer courseProgressPercent;
        private Boolean isUnlocked;         // false nếu bước trước chưa complete
        /** FE dùng để render khóa theo gói (không phụ thuộc isUnlocked) */
        private Boolean canAccess;
        /** Gói tối thiểu để học được course trong step (MONTHLY hoặc UNLIMITED) */
        private String  requiredPlan;
    }
}
