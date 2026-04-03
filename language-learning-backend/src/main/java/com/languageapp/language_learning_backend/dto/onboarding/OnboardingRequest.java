package com.languageapp.language_learning_backend.dto.onboarding;

import com.languageapp.language_learning_backend.entity.UserOnboarding.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OnboardingRequest {

    /** Ngôn ngữ muốn học */
    @NotNull
    private UUID targetLanguageId;

    /** Ngôn ngữ mẹ đẻ — code như "vi", "en" */
    private String nativeLanguageCode;

    /** Trình độ tự đánh giá */
    @NotNull
    private SelfLevel selfLevel;

    /** Mục tiêu học */
    @NotNull
    private LearningGoal goal;

    /** Số phút học mỗi ngày */
    @NotNull
    private DailyTime dailyTime;

    /** Nhóm tuổi */
    private String ageGroup;

    /** Nguồn biết app */
    private String heardFrom;
}
