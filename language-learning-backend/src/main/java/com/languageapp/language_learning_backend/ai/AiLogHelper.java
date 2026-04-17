package com.languageapp.language_learning_backend.ai;

import com.languageapp.language_learning_backend.ai.client.AiResult;
import com.languageapp.language_learning_backend.entity.AIInteractionLog;
import com.languageapp.language_learning_backend.entity.AIInteractionLog.AIStatus;
import com.languageapp.language_learning_backend.entity.AIInteractionLog.InteractionType;
import com.languageapp.language_learning_backend.repository.AIInteractionLogRepository;
import com.languageapp.language_learning_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Helper dùng chung giữa các AI service để lưu log vào ai_interaction_logs.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AiLogHelper {

    private final AIInteractionLogRepository logRepo;
    private final UserRepository             userRepo;

    /**
     * Lưu log sau khi gọi AI thành công.
     */
    public void saveSuccess(UUID userId, InteractionType type,
                            String prompt, AiResult result, UUID lessonId) {
        save(userId, type, prompt, result.getText(), result.getModel(),
                result.getInTokens(), result.getOutTokens(), result.getCost(), result.getLatencyMs(),
                AIStatus.SUCCESS, null, lessonId);
    }

    /**
     * Lưu log khi AI thất bại.
     */
    public void saveFailure(UUID userId, InteractionType type,
                            String prompt, String errorMessage, UUID lessonId) {
        save(userId, type, prompt, null, null,
                0, 0, null, null,
                AIStatus.FAILED, errorMessage, lessonId);
    }

    // ── PRIVATE ───────────────────────────────────────────────
    private void save(UUID userId, InteractionType type,
                      String prompt, String response, String model,
                      int inTokens, int outTokens, java.math.BigDecimal cost, Integer latencyMs,
                      AIStatus status, String errorMessage, UUID lessonId) {
        try {
            logRepo.save(AIInteractionLog.builder()
                    .user(userRepo.getReferenceById(userId))
                    .interactionType(type)
                    .model(model)
                    .prompt(truncate(prompt, 2000))
                    .response(truncate(response, 5000))
                    .inputTokens(inTokens)
                    .outputTokens(outTokens)
                    .totalTokens(inTokens + outTokens)
                    .cost(cost)
                    .latencyMs(latencyMs)
                    .status(status)
                    .errorMessage(truncate(errorMessage, 500))
                    .lessonId(lessonId)
                    .build());
        } catch (Exception e) {
            // Log lỗi nhưng không throw — không để logging làm hỏng flow chính
            log.error("Failed to save AI log for user {}: {}", userId, e.getMessage());
        }
    }

    private String truncate(String s, int max) {
        if (s == null) return null;
        return s.length() > max ? s.substring(0, max) : s;
    }
}