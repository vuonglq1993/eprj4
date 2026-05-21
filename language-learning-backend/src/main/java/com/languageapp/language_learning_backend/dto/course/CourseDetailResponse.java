package com.languageapp.language_learning_backend.dto.course;

import com.languageapp.language_learning_backend.entity.Course.Level;
import com.languageapp.language_learning_backend.dto.lesson.LessonSummaryResponse;
import lombok.*;

import java.time.Instant;
import java.util.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CourseDetailResponse {
    private UUID                       id;
    private String                     title;
    private String                     description;
    private String                     languageCode;
    private String                     languageName;
    private Level                      level;
    private Boolean                    isPublished;
    private Integer                    totalLessons;
    private String                     createdByName;
    private Instant                    createdAt;
    private List<LessonSummaryResponse> lessons;
    private Integer                    progressPercent;
}
