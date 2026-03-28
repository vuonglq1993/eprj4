package com.languageapp.language_learning_backend.dto.course;

import com.languageapp.language_learning_backend.entity.Course.Level;
import lombok.*;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CourseResponse {
    private UUID          id;
    private String        title;
    private String        description;
    private String        languageCode;
    private String        languageName;
    private Level         level;
    private String        thumbnailUrl;
    private Boolean       isPublished;
    private Integer       totalLessons;
    private String        createdByName;
    private Instant       createdAt;
    private Instant       updatedAt;
    private Integer       progressPercent;   // null nếu chưa login
}
