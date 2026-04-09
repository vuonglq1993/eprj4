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
// Grammar Service
// ==========================================
@Slf4j
@Service
@RequiredArgsConstructor
public class GrammarService {

    private final AiClient         aiClient;
    private final PromptBuilder    promptBuilder;
    private final AiRateLimitGuard rateLimitGuard;
    private final AiLogHelper      logHelper;
    private final UserRepository   userRepo;
    private final ObjectMapper     objectMapper;

    public GrammarCheckResponse checkGrammar(GrammarCheckRequest req, UserPrincipal p) {
        AiTier tier = getTier(p);
        rateLimitGuard.check(p.getUserId(), InteractionType.GRAMMAR_CHECK, tier);

        String system = promptBuilder.forGrammar(req.getCefrLevel());
        log.info("Grammar check - user: {}, tier: {}, length: {}", p.getUserId(), tier, req.getText().length());

        AiResult result;
        try {
            result = aiClient.chat(system, req.getText());
        } catch (Exception e) {
            logHelper.saveFailure(p.getUserId(), InteractionType.GRAMMAR_CHECK, req.getText(), e.getMessage(), null);
            throw e;
        }

        logHelper.saveSuccess(p.getUserId(), InteractionType.GRAMMAR_CHECK, req.getText(), result, null);

        try {
            String clean = cleanJson(result.getText());
            return objectMapper.readValue(clean, GrammarCheckResponse.class);
        } catch (Exception e) {
            log.warn("Grammar JSON parse failed, returning fallback: {}", e.getMessage());
            // Fallback: trả về response hợp lệ thay vì crash
            return GrammarCheckResponse.builder()
                    .original(req.getText()).corrected(req.getText())
                    .isCorrect(false).errors(java.util.List.of())
                    .tip(result.getText()).build();
        }
    }

    private AiTier getTier(UserPrincipal p) {
        if ("ADMIN".equals(p.getRole()) || "TEACHER".equals(p.getRole())) return AiTier.UNLIMITED;
        return userRepo.findById(p.getUserId())
                .map(u -> AiTier.from(u.getSubscription() != null
                        ? u.getSubscription().getPlan() : Subscription.Plan.FREE))
                .orElse(AiTier.FREE);
    }

    private String cleanJson(String s) {
        return s.replaceAll("(?s)```json\\s*", "").replaceAll("```", "").trim();
    }
}