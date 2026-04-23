package com.languageapp.language_learning_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
public class SpeechService {

    private final ObjectMapper mapper;

    @Value("${groq.api-key}")
    private String groqApiKey;

    private static final String GROQ_TRANSCRIPTION_URL =
            "https://api.groq.com/openai/v1/audio/transcriptions";

    public String transcribeFromUrl(String audioUrl) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            byte[] audioBytes = restTemplate.getForObject(audioUrl, byte[].class);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.setBearerAuth(groqApiKey);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

            ByteArrayResource resource = new ByteArrayResource(audioBytes) {
                @Override
                public String getFilename() {
                    return "audio.m4a";
                }
            };

            body.add("file", resource);
            body.add("model", "whisper-large-v3");

            HttpEntity<MultiValueMap<String, Object>> request =
                    new HttpEntity<>(body, headers);

            ResponseEntity<String> response =
                    restTemplate.postForEntity(GROQ_TRANSCRIPTION_URL, request, String.class);

            JsonNode json = mapper.readTree(response.getBody());
            return json.get("text").asText();

        } catch (Exception e) {
            throw new RuntimeException("Speech-to-text failed: " + e.getMessage(), e);
        }
    }
}
