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

@Component
@ConditionalOnProperty(name = "ai.provider", havingValue = "groq")
public class GroqClient implements AiClient {

    private static final Logger log = LoggerFactory.getLogger(GroqClient.class);

    @Value("${groq.api-key}")
    private String apiKey;

    @Value("${groq.model}")
    private String model;

    @Value("${groq.base-url}")
    private String baseUrl;

    @Value("${ai.max-tokens:1024}")
    private int maxTokens;

    @Value("${ai.timeout-seconds:30}")
    private int timeoutSeconds;

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public GroqClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    public AiResult chat(String systemPrompt, String userMessage) {
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "system", "content", systemPrompt));
        messages.add(Map.of("role", "user", "content", userMessage));
        return callApi(messages);
    }

    @Override
    public AiResult chatWithHistory(String systemPrompt, List<Map<String, String>> history) {
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "system", "content", systemPrompt));
        messages.addAll(history);
        return callApi(messages);
    }

    private AiResult callApi(List<Map<String, String>> messages) {
        try {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("model", model);
            body.put("messages", messages);
            body.put("max_tokens", maxTokens);
            body.put("temperature", 0.7);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(baseUrl))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(timeoutSeconds))
                    .POST(HttpRequest.BodyPublishers.ofString(
                            objectMapper.writeValueAsString(body)))
                    .build();

            HttpResponse<String> response = httpClient.send(request,
                    HttpResponse.BodyHandlers.ofString());

            log.debug("Groq status: {}", response.statusCode());

            if (response.statusCode() != 200) {
                log.error("Groq error: {}", response.body());
                throw new RuntimeException("Groq API error: " + response.statusCode());
            }

            JsonNode root = objectMapper.readTree(response.body());
            String text = root.path("choices").get(0)
                    .path("message").path("content").asText();

            return AiResult.builder()
                    .text(text)
                    .model(model)
                    .inTokens(0)
                    .outTokens(0)
                    .cost(null)
                    .latencyMs(null)
                    .build();

        } catch (Exception e) {
            log.error("GroqClient error", e);
            throw new RuntimeException("Groq API error: " + e.getMessage(), e);
        }
    }
}