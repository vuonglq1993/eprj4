package com.languageapp.language_learning_backend.ai.client;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.*;

/**
 * Gemini Client - FREE tier.
 * Active khi: ai.provider=gemini (mặc định trong dev)
 * Lấy key tại: aistudio.google.com
 */
@Component
@ConditionalOnProperty(name = "ai.provider", havingValue = "gemini")
public class GeminiClient implements AiClient {

    private static final Logger log = LoggerFactory.getLogger(GeminiClient.class);

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.model:gemini-1.5-flash}")
    private String model;

    @Value("${gemini.base-url}")
    private String baseUrl;

    @Value("${ai.max-tokens:1024}")
    private int maxTokens;

    @Value("${ai.timeout-seconds:30}")
    private int timeoutSeconds;

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public GeminiClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    public AiResult chat(String systemPrompt, String userMessage) {
        List<Map<String, String>> history = new ArrayList<>();
        history.add(Map.of("role", "user", "content", userMessage));
        return chatWithHistory(systemPrompt, history);
    }

    @Override
    public AiResult chatWithHistory(String systemPrompt, List<Map<String, String>> history) {
        try {
            String url = baseUrl + "/" + model + ":generateContent?key=" + apiKey;

            // Build Gemini contents format
            List<Map<String, Object>> contents = new ArrayList<>();
            for (Map<String, String> msg : history) {
                String role = msg.get("role").equals("assistant") ? "model" : "user";
                contents.add(Map.of(
                        "role", role,
                        "parts", List.of(Map.of("text", msg.get("content")))
                ));
            }

            Map<String, Object> requestBody = new LinkedHashMap<>();
            requestBody.put("system_instruction", Map.of(
                    "parts", List.of(Map.of("text", systemPrompt))
            ));
            requestBody.put("contents", contents);
            requestBody.put("generationConfig", Map.of(
                    "maxOutputTokens", maxTokens,
                    "temperature", 0.7
            ));

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(timeoutSeconds))
                    .POST(HttpRequest.BodyPublishers.ofString(
                            objectMapper.writeValueAsString(requestBody)))
                    .build();

            HttpResponse<String> response = httpClient.send(request,
                    HttpResponse.BodyHandlers.ofString());

            log.debug("Gemini status: {}", response.statusCode());

            if (response.statusCode() != 200) {
                log.error("Gemini error: {}", response.body());
                throw new RuntimeException("Gemini API error: " + response.statusCode());
            }

            JsonNode root = objectMapper.readTree(response.body());
            String text = root.path("candidates").get(0)
                    .path("content").path("parts").get(0)
                    .path("text").asText();

            return AiResult.builder()
                    .text(text)
                    .model(model)
                    .inTokens(0)      // Gemini free không trả → để 0
                    .outTokens(0)
                    .cost(null)
                    .latencyMs(null)
                    .build();

        } catch (Exception e) {
            log.error("GeminiClient error", e);
            throw new RuntimeException("AI service error: " + e.getMessage(), e);
        }
    }
}

