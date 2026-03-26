package com.languageapp.language_learning_backend.dto.progress;

import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CertificateResponse {
    private UUID          courseId;
    private String        courseTitle;
    private String        languageName;
    private String        userName;
    private double        finalScore;
    private String        cefrLevel;       // A1 / A2 / B1 / B2 / C1
    private LocalDateTime completedAt;
    private String        certificateCode; // LN-XXXXXX-XXXXXX-2025
}
