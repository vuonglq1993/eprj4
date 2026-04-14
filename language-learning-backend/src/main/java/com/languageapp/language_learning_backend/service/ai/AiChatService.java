package com.languageapp.language_learning_backend.service.ai;

import com.languageapp.language_learning_backend.ai.AiLogHelper;
import com.languageapp.language_learning_backend.ai.AiTier;
import com.languageapp.language_learning_backend.ai.client.AiClient;
import com.languageapp.language_learning_backend.ai.client.AiResult;
import com.languageapp.language_learning_backend.ai.guard.AiRateLimitGuard;
import com.languageapp.language_learning_backend.ai.prompt.PromptBuilder;
import com.languageapp.language_learning_backend.dto.ai.AiChatRequest;
import com.languageapp.language_learning_backend.dto.ai.AiChatResponse;
import com.languageapp.language_learning_backend.entity.AIInteractionLog;
import com.languageapp.language_learning_backend.entity.AIInteractionLog.InteractionType;
import com.languageapp.language_learning_backend.entity.Subscription;
import com.languageapp.language_learning_backend.repository.AIInteractionLogRepository;
import com.languageapp.language_learning_backend.repository.LessonRepository;
import com.languageapp.language_learning_backend.repository.UserRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiChatService {

    private final AiClient                   aiClient;
    private final PromptBuilder              promptBuilder;
    private final AiRateLimitGuard           rateLimitGuard;
    private final AiLogHelper                logHelper;
    private final AIInteractionLogRepository logRepo;
    private final LessonRepository           lessonRepo;
    private final UserRepository             userRepo;

    @Value("${ai.max-history-per-session:20}")
    private int maxHistory;

    // ── CHAT ──────────────────────────────────────────────────
    @Transactional
    public AiChatResponse chat(AiChatRequest req, UserPrincipal p) {
        AiTier tier = getTier(p);
        rateLimitGuard.check(p.getUserId(), InteractionType.CHAT_EXPLAIN, tier);

        // Lấy context bài học nếu có
        String lessonTitle = req.getLessonTitle();
        String lessonContent = req.getLessonContent();
        UUID lessonId = req.getLessonId();

        if (lessonId != null && (lessonTitle == null || lessonTitle.isBlank())) {
            lessonRepo.findById(lessonId).ifPresent(l -> {
                req.setLessonTitle(l.getTitle());
                req.setLessonContent(l.getContent());
            });
        }

        // ✅ Khôi phục conversation history từ DB (không cần Redis/in-memory)
        List<Map<String, String>> history = buildHistoryFromDb(p.getUserId(), lessonId);

        // Thêm tin nhắn mới của user vào history
        history.add(Map.of("role", "user", "content", req.getMessage()));

        String systemPrompt = promptBuilder.forChat(
                req.getLessonTitle(), req.getLessonContent(), req.getCefrLevel());

        log.info("AI Chat - user: {}, tier: {}, lesson: {}", p.getUserId(), tier, lessonTitle);

        AiResult result;
        try {
            result = aiClient.chatWithHistory(systemPrompt, history);
        } catch (Exception e) {
            logHelper.saveFailure(p.getUserId(), InteractionType.CHAT_EXPLAIN,
                    req.getMessage(), e.getMessage(), lessonId);
            throw e;
        }

        // Lưu log (mỗi turn là 1 record — prompt = user msg, response = AI reply)
        logHelper.saveSuccess(p.getUserId(), InteractionType.CHAT_EXPLAIN,
                req.getMessage(), result, lessonId);

        return AiChatResponse.builder()
                .reply(result.getText())
                .model(result.getModel())
                .inputTokens(result.getInTokens())
                .outputTokens(result.getOutTokens())
                .remainingToday(getRemainingCount(p.getUserId(), InteractionType.CHAT_EXPLAIN, tier))
                .build();
    }

    // ── HISTORY ───────────────────────────────────────────────

    /**
     * Khôi phục conversation history từ DB thay vì in-memory map.
     * Lấy N tin nhắn gần nhất để tránh vượt context window.
     */
    private List<Map<String, String>> buildHistoryFromDb(UUID userId, UUID lessonId) {
        if (lessonId == null) return new ArrayList<>();

        List<AIInteractionLog> logs = logRepo.findChatHistory(
                userId,
                lessonId,
                InteractionType.CHAT_EXPLAIN,
                AIInteractionLog.AIStatus.SUCCESS
        );

        // Giới hạn maxHistory/2 cặp hội thoại gần nhất
        int skip = Math.max(0, logs.size() - (maxHistory / 2));
        List<Map<String, String>> history = new ArrayList<>();

        for (int i = skip; i < logs.size(); i++) {
            AIInteractionLog entry = logs.get(i);
            if (entry.getPrompt() != null)
                history.add(Map.of("role", "user", "content", entry.getPrompt()));
            if (entry.getResponse() != null)
                history.add(Map.of("role", "assistant", "content", entry.getResponse()));
        }
        return history;
    }

    // ── HELPERS ───────────────────────────────────────────────
    private AiTier getTier(UserPrincipal p) {
        if ("ADMIN".equals(p.getRole()) || "TEACHER".equals(p.getRole())) return AiTier.UNLIMITED;
        return userRepo.findById(p.getUserId())
                .map(u -> AiTier.from(u.getSubscription() != null
                        ? u.getSubscription().getPlan() : Subscription.Plan.FREE))
                .orElse(AiTier.FREE);
    }

    private long getRemainingCount(UUID userId, InteractionType type, AiTier tier) {
        int limit = switch (type) {
            case CHAT_EXPLAIN   -> tier.chatLimit();
            case GRAMMAR_CHECK  -> tier.grammarLimit();
            case PRONUNCIATION  -> tier.pronunciationLimit();
            default             -> tier.vocabLimit();
        };

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

        return Math.max(0, limit - used);
    }
}