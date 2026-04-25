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
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.fasterxml.jackson.databind.JsonNode;
import com.languageapp.language_learning_backend.repository.UserRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.SpeechService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.util.Map;
import java.util.stream.StreamSupport;

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
    private final SpeechService    speechService;
    private final Cloudinary       cloudinary;

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
            JsonNode node = objectMapper.readTree(clean);
            return PronunciationResponse.builder()
                    .score(node.path("score").asInt(0))
                    .cefrLevel(node.path("cefrLevel").asText("B1"))
                    .feedback(nodeAsString(node.get("feedback")))
                    .phonemeErrors(nodeAsString(node.get("phonemeErrors")))
                    .improvement(nodeAsString(node.get("improvement")))
                    .build();
        } catch (Exception e) {
            log.warn("Pronunciation JSON parse failed: {}", e.getMessage());
            int score = req.getTargetText().trim().equalsIgnoreCase(req.getRecognizedText().trim()) ? 95 : 60;
            return PronunciationResponse.builder()
                    .score(score).cefrLevel("B1")
                    .feedback("Không thể phân tích chi tiết. Vui lòng thử lại.").build();
        }
    }

    public String uploadAudio(MultipartFile file) {
        try {
            Map result = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap("resource_type", "auto")
            );
            return (String) result.get("secure_url");
        } catch (Exception e) {
            throw new RuntimeException("Audio upload failed: " + e.getMessage(), e);
        }
    }

    public PronunciationResponse analyzeFromAudio(PronunciationAudioRequest req, UserPrincipal p) {
        log.info("Pronunciation(audio) - user: {}, transcribing audioUrl: {}", p.getUserId(), req.getAudioUrl());
        String recognizedText;
        try {
            recognizedText = speechService.transcribeFromUrl(req.getAudioUrl());
        } catch (Exception e) {
            log.warn("Transcription failed: {}", e.getMessage());
            throw new RuntimeException("Không thể chuyển giọng nói thành văn bản. Vui lòng thử lại.");
        }
        log.info("Transcribed: '{}'", recognizedText);

        PronunciationRequest inner = PronunciationRequest.builder()
                .targetText(req.getTargetText())
                .recognizedText(recognizedText)
                .cefrLevel(req.getCefrLevel())
                .build();
        return analyzePronunciation(inner, p);
    }

    private String nodeAsString(JsonNode node) {
        if (node == null || node.isNull()) return "";
        if (node.isTextual()) return node.asText();
        if (node.isArray()) {
            return StreamSupport.stream(node.spliterator(), false)
                    .map(n -> "• " + n.asText())
                    .reduce((a, b) -> a + "\n" + b)
                    .orElse("");
        }
        return node.toString();
    }

    private AiTier getTier(UserPrincipal p) {
        if ("ADMIN".equals(p.getRole()) || "TEACHER".equals(p.getRole())) return AiTier.UNLIMITED;
        return userRepo.findById(p.getUserId())
                .map(u -> AiTier.from(u.getSubscription() != null
                        ? u.getSubscription().getPlan() : Subscription.Plan.FREE))
                .orElse(AiTier.FREE);
    }
}
