package com.languageapp.language_learning_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.languageapp.language_learning_backend.dto.review.MistakeResponse;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.repository.ExerciseAttemptRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ExerciseAttemptRepository attemptRepo;
    private final ObjectMapper mapper;

    @Transactional(readOnly = true)
    public List<MistakeResponse> getMistakes(UserPrincipal p, int page, int size) {

        // 👉 lấy attempts sai
        List<ExerciseAttempt> attempts = attemptRepo.findMistakesByUser(
                p.getUserId(),
                PageRequest.of(page, size)
        );

        // 👉 lấy map count sai (1 query duy nhất)
        Map<UUID, Long> wrongMap = attemptRepo.countWrongGrouped(p.getUserId())
                .stream()
                .collect(Collectors.toMap(
                        r -> (UUID) r[0],
                        r -> (Long) r[1]
                ));

        return attempts.stream().map(a -> {

            Exercise ex = a.getExercise();
            Lesson   l  = ex.getLesson();
            Course   c  = l.getCourse();

            return MistakeResponse.builder()
                    .exerciseId(ex.getId())
                    .exerciseTitle(ex.getTitle())
                    .exerciseType(ex.getType())
                    .questionData(ex.getQuestionData())
                    .userAnswer(a.getSelectedAnswer())
                    .correctAnswer(extractCorrectAnswer(ex))
                    .explanation(extractExplanation(ex))
                    .lessonId(l.getId())
                    .lessonTitle(l.getTitle())
                    .courseId(c.getId())
                    .courseTitle(c.getTitle())
                    .attemptedAt(a.getSubmittedAt())
                    .timesWrong(wrongMap.getOrDefault(ex.getId(), 0L).intValue())
                    .build();

        }).collect(Collectors.toList());
    }

    // ── PARSE JSON ───────────────────────────────────────────

    private String extractCorrectAnswer(Exercise ex) {
        try {
            JsonNode q = mapper.readTree(ex.getQuestionData());

            return switch (ex.getType()) {
                case MULTIPLE_CHOICE, LISTENING_CHOICE -> {
                    int idx = q.get("correctIndex").asInt();
                    yield q.get("options").get(idx).asText();
                }
                case FILL_IN_BLANK, TRANSLATION -> q.get("answer").asText();

                case DRAG_DROP -> {
                    if (q.has("correctSentence"))
                        yield q.get("correctSentence").asText();

                    int idx = q.get("correctIndex").asInt();
                    yield q.get("options").get(idx).asText();
                }

                default -> "N/A";
            };

        } catch (Exception e) {
            return "N/A";
        }
    }

    private String extractExplanation(Exercise ex) {
        try {
            JsonNode q = mapper.readTree(ex.getQuestionData());
            return q.has("explanation") ? q.get("explanation").asText() : null;
        } catch (Exception e) {
            return null;
        }
    }
}