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
// Recommendation Service
// ==========================================
@Slf4j
@Service
@RequiredArgsConstructor
public class RecommendService {

    private final AiClient         aiClient;
    private final PromptBuilder    promptBuilder;
    private final AiRateLimitGuard rateLimitGuard;
    private final AiLogHelper      logHelper;
    private final UserRepository   userRepo;
    private final ObjectMapper     objectMapper;

    public Object recommend(RecommendRequest req, UserPrincipal p) {
        AiTier tier = getTier(p);
        rateLimitGuard.check(p.getUserId(), InteractionType.RECOMMENDATION, tier);

        String userDataJson;
        try {
            userDataJson = objectMapper.writeValueAsString(req);
        } catch (Exception e) {
            userDataJson = req.toString();
        }

        String userMessage = "Dữ liệu học của học viên:\n" + userDataJson + "\n\nHãy gợi ý bài học phù hợp nhất.";
        log.info("AI Recommend - user: {}, tier: {}", p.getUserId(), tier);

        AiResult result;
        try {
            result = aiClient.chat(promptBuilder.forRecommendation(), userMessage);
        } catch (Exception e) {
            logHelper.saveFailure(p.getUserId(), InteractionType.RECOMMENDATION, userMessage, e.getMessage(), null);
            throw e;
        }

        logHelper.saveSuccess(p.getUserId(), InteractionType.RECOMMENDATION, userMessage, result, null);

        try {
            String clean = result.getText().replaceAll("(?s)```json\\s*", "").replaceAll("```", "").trim();
            return objectMapper.readTree(clean);
        } catch (Exception e) {
            return java.util.Map.of("raw", result.getText());
        }
    }

    private AiTier getTier(UserPrincipal p) {
        if ("ADMIN".equals(p.getRole())) return AiTier.UNLIMITED;
        return userRepo.findById(p.getUserId())
                .map(u -> AiTier.from(u.getSubscription() != null
                        ? u.getSubscription().getPlan() : Subscription.Plan.FREE))
                .orElse(AiTier.FREE);
    }
}