package com.languageapp.language_learning_backend.dto.lesson;

import com.languageapp.language_learning_backend.entity.Lesson.LessonType;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LessonDetailResponse {
    private UUID          id;
    private UUID          courseId;
    private String        title;
    private String        content;
    private LessonType    type;
    private Integer       orderIndex;
    private Integer       durationMinutes;
    private Boolean       isFree;
    /** FE dùng để render lock + CTA mua gói */
    private Boolean       isAccessible;
    /** Gói tối thiểu để truy cập (MONTHLY hoặc UNLIMITED). Null nếu ai cũng xem được */
    private String        requiredPlan;
    private Integer       totalExercises;
    private Instant       createdAt;
    // Populated nếu user đã login
    private String        progressStatus;
    private Integer       score;
}
