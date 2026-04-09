package com.languageapp.language_learning_backend.service.ai;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.languageapp.language_learning_backend.ai.AiLogHelper;
import com.languageapp.language_learning_backend.ai.AiTier;
import com.languageapp.language_learning_backend.ai.client.AiClient;
import com.languageapp.language_learning_backend.ai.client.AiResult;
import com.languageapp.language_learning_backend.ai.guard.AiRateLimitGuard;
import com.languageapp.language_learning_backend.ai.prompt.PromptBuilder;
import com.languageapp.language_learning_backend.dto.ai.*;
import com.languageapp.language_learning_backend.entity.AIInteractionLog.InteractionType;
import com.languageapp.language_learning_backend.entity.Subscription;
import com.languageapp.language_learning_backend.repository.UserRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

// ==========================================
// Pronunciation Service
// ==========================================
@Slf4j
@Service
@RequiredArgsConstructor
public class PronunciationService {

    private final AiClient         aiClient;
    private final PromptBuilder    promptBuilder;
    private final AiRateLimitGuard rateLimitGuard;
    private final AiLogHelper      logHelper;
    private final UserRepository   userRepo;
    private final ObjectMapper     objectMapper;

    public PronunciationResponse analyzePronunciation(PronunciationRequest req, UserPrincipal p) {
        AiTier tier = getTier(p);
        rateLimitGuard.check(p.getUserId(), InteractionType.PRONUNCIATION, tier);

        String system = promptBuilder.forPronunciation(
                req.getTargetText(), req.getRecognizedText(), req.getCefrLevel());

        log.info("Pronunciation - user: {}, tier: {}, target: '{}'",
                p.getUserId(), tier, req.getTargetText());

        String promptLog = "target=" + req.getTargetText() + " | recognized=" + req.getRecognizedText();

        AiResult result;
        try {
            result = aiClient.chat(system, "Phân tích phát âm và cho điểm.");
        } catch (Exception e) {
            logHelper.saveFailure(p.getUserId(), InteractionType.PRONUNCIATION, promptLog, e.getMessage(), null);
            throw e;
        }

        logHelper.saveSuccess(p.getUserId(), InteractionType.PRONUNCIATION, promptLog, result, null);

        try {
            String clean = result.getText().replaceAll("(?s)```json\\s*", "").replaceAll("```", "").trim();
            return objectMapper.readValue(clean, PronunciationResponse.class);
        } catch (Exception e) {
            log.warn("Pronunciation JSON parse failed: {}", e.getMessage());
            // Fallback đơn giản: so sánh text
            int score = req.getTargetText().trim().equalsIgnoreCase(req.getRecognizedText().trim()) ? 95 : 60;
            return PronunciationResponse.builder()
                    .score(score).cefrLevel("B1")
                    .feedback(result.getText()).build();
        }
    }

    private AiTier getTier(UserPrincipal p) {
        if ("ADMIN".equals(p.getRole()) || "TEACHER".equals(p.getRole())) return AiTier.UNLIMITED;
        return userRepo.findById(p.getUserId())
                .map(u -> AiTier.from(u.getSubscription() != null
                        ? u.getSubscription().getPlan() : Subscription.Plan.FREE))
                .orElse(AiTier.FREE);
    }
}
