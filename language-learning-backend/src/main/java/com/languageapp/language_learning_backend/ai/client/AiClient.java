package com.languageapp.language_learning_backend.ai.client;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Interface chung cho tất cả AI providers.
 * Thay đổi provider chỉ cần đổi ai.provider trong application.properties,
 * không cần sửa bất kỳ service hay controller nào.
 */
public interface AiClient {

    /**
     * Gửi message đơn giản (không có history)
     */
    AiResult chat(String systemPrompt, String userMessage);

    /**
     * Gửi với conversation history (dùng cho AI Chat Teacher)
     */
    AiResult chatWithHistory(String systemPrompt, List<Map<String, String>> history);
}

