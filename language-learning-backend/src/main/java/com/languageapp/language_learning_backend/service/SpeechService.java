package com.languageapp.language_learning_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.core.io.ByteArrayResource;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SpeechService {

    private final ObjectMapper mapper;

    // 👉 đặt trong env sau này
    private static final String OPENAI_API_KEY = "YOUR_OPENAI_KEY";
    private static final String URL = "https://api.openai.com/v1/audio/transcriptions";

    public String transcribeFromUrl(String audioUrl) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            byte[] audioBytes = restTemplate.getForObject(audioUrl, byte[].class);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.setBearerAuth(OPENAI_API_KEY);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

            ByteArrayResource resource = new ByteArrayResource(audioBytes) {
                @Override
                public String getFilename() {
                    return "audio.mp3";
                }
            };

            body.add("file", resource);
            body.add("model", "whisper-1");

            HttpEntity<MultiValueMap<String, Object>> request =
                    new HttpEntity<>(body, headers);

            ResponseEntity<String> response =
                    restTemplate.postForEntity(URL, request, String.class);

            JsonNode json = mapper.readTree(response.getBody());

            return json.get("text").asText();

        } catch (Exception e) {
            throw new RuntimeException("Speech-to-text failed", e);
        }
    }
}