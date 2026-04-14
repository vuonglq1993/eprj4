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
// Vocabulary Service
// ==========================================
@Slf4j
@Service
@RequiredArgsConstructor
public class VocabService {

    private final AiClient         aiClient;
    private final PromptBuilder    promptBuilder;
    private final AiRateLimitGuard rateLimitGuard;
    private final AiLogHelper      logHelper;
    private final UserRepository   userRepo;
    private final ObjectMapper     objectMapper;

    public Object generateWordData(VocabRequest req, UserPrincipal p) {
        AiTier tier = getTier(p);
        rateLimitGuard.check(p.getUserId(), InteractionType.RECOMMENDATION, tier); // dùng chung slot

        String system = promptBuilder.forVocabExamples(req.getWord(), req.getCefrLevel());
        log.info("Vocab generate - user: {}, word: {}", p.getUserId(), req.getWord());

        AiResult result;
        try {
            result = aiClient.chat(system, "Tạo dữ liệu học từ vựng cho từ: " + req.getWord());
        } catch (Exception e) {
            logHelper.saveFailure(p.getUserId(), InteractionType.RECOMMENDATION, req.getWord(), e.getMessage(), null);
            throw e;
        }

        logHelper.saveSuccess(p.getUserId(), InteractionType.RECOMMENDATION, req.getWord(), result, null);

        try {
            String clean = result.getText().replaceAll("(?s)```json\\s*", "").replaceAll("```", "").trim();
            return objectMapper.readTree(clean);
        } catch (Exception e) {
            return java.util.Map.of("word", req.getWord(), "raw", result.getText());
        }
    }

    public Object generateGameQuestion(VocabGameRequest req, UserPrincipal p) {
        String system = promptBuilder.forVocabGame(req.getWord(), req.getGameType(), req.getCefrLevel());
        AiResult result = aiClient.chat(system, "Tạo câu hỏi " + req.getGameType() + " cho từ: " + req.getWord());
        try {
            String clean = result.getText().replaceAll("(?s)```json\\s*", "").replaceAll("```", "").trim();
            return objectMapper.readTree(clean);
        } catch (Exception e) {
            return java.util.Map.of("word", req.getWord(), "raw", result.getText());
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