package com.languageapp.language_learning_backend.ai.guard;

import com.languageapp.language_learning_backend.ai.AiTier;
import com.languageapp.language_learning_backend.entity.AIInteractionLog;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.ForbiddenException;
import com.languageapp.language_learning_backend.repository.AIInteractionLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.time.*;
import java.time.LocalDate;
import java.util.UUID;

/**
 * Rate limit dựa trên DB — đếm số lần gọi AI trong ngày từ ai_interaction_logs.
 * Không cần Redis.
 */
@Component
@RequiredArgsConstructor
public class AiRateLimitGuard {

    private final AIInteractionLogRepository logRepo;

    public void check(UUID userId, AIInteractionLog.InteractionType type, AiTier tier) {
        int limit = switch (type) {
            case CHAT_EXPLAIN    -> tier.chatLimit();
            case GRAMMAR_CHECK   -> tier.grammarLimit();
            case PRONUNCIATION   -> tier.pronunciationLimit();
            case RECOMMENDATION  -> tier.recommendLimit();
            default              -> tier.vocabLimit();
        };

        // ✅ Tính khoảng thời gian trong ngày
        LocalDate today = LocalDate.now();
        Instant start = today.atStartOfDay(ZoneId.systemDefault()).toInstant();
        Instant end   = today.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant();

        long used = logRepo.countTodayByUserAndType(
                userId,
                type,
                AIInteractionLog.AIStatus.SUCCESS,
                start,
                end
        );

        if (used >= limit) {
            String upgrade = tier == AiTier.FREE
                    ? " — nâng cấp lên MONTHLY hoặc UNLIMITED để dùng nhiều hơn"
                    : tier == AiTier.MONTHLY
                    ? " — nâng cấp lên UNLIMITED (3 tháng / 1 năm) để dùng nhiều hơn"
                    : "";

            throw new ForbiddenException(
                    "Đã đạt giới hạn " + limit + " lần/ngày cho " + type.name() + upgrade);
        }
    }
}
