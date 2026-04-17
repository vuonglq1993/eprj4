package com.languageapp.language_learning_backend.dto.onboarding;

import com.languageapp.language_learning_backend.dto.learningpath.LearningPathResponse;
import com.languageapp.language_learning_backend.entity.UserOnboarding.*;
import lombok.*;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OnboardingResponse {

    private UUID          onboardingId;

    private UUID targetLanguageId;
    private String        targetLanguageName;
    private String        targetLanguageCode;
    private String        targetLanguageFlag;
    private SelfLevel     selfLevel;
    private LearningGoal  goal;
    private DailyTime     dailyTime;
    private Boolean       completed;

    /**
     * Learning Path được gợi ý tốt nhất dựa trên level + goal + language.
     * null nếu không tìm được path phù hợp.
     */
    private LearningPathResponse recommendedPath;

    /**
     * Danh sách thêm các path liên quan (tối đa 3).
     */
    private List<LearningPathResponse> otherSuggestedPaths;

    /** Thông điệp động viên cá nhân hóa */
    private String motivationMessage;
}
