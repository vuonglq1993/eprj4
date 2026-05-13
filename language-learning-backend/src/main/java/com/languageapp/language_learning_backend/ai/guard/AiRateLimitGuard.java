package com.languageapp.language_learning_backend.ai.guard;

import com.languageapp.language_learning_backend.ai.AiTier;
import com.languageapp.language_learning_backend.entity.AIInteractionLog;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
@RequiredArgsConstructor
public class AiRateLimitGuard {

    private final AiRateLimitService rateLimitService;

    public void check(UUID userId, AIInteractionLog.InteractionType type, AiTier tier) {
        int limit = switch (type) {
            case CHAT_EXPLAIN    -> tier.chatLimit();
            case GRAMMAR_CHECK   -> tier.grammarLimit();
            case PRONUNCIATION   -> tier.pronunciationLimit();
            case RECOMMENDATION  -> tier.recommendLimit();
            default              -> tier.vocabLimit();
        };

        rateLimitService.checkAndIncrement(userId, type.name(), limit);
    }
}
