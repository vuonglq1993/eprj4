package com.languageapp.language_learning_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.languageapp.language_learning_backend.dto.exercise.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Lesson.AccessTier;
import com.languageapp.language_learning_backend.entity.Record;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ExerciseService {

    private final ExerciseRepository exerciseRepo;
    private final LessonRepository lessonRepo;
    private final CourseRepository courseRepo;
    private final UserProgressRepository progressRepo;
    private final UserRepository userRepo;

    private final CourseService courseService;
    private final LessonService lessonService;

    private final ObjectMapper mapper;

    private final RecordRepository recordRepo;

    private final SpeechService speechService;
    private final ScoringService scoringService;
    private final com.languageapp.language_learning_backend.ai.client.AiClient aiClient;

    // ───────────────────────── LIST
    @Transactional(readOnly = true)
    public List<ExerciseResponse> list(UUID courseId, UUID lessonId, UserPrincipal p) {
        courseService.findOrThrow(courseId);
        lessonService.findOrThrow(lessonId, courseId);

        return exerciseRepo.findByLessonIdOrderByOrderIndexAsc(lessonId)
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    // ───────────────────────── CREATE
    @Transactional
    public ExerciseResponse create(UUID courseId, UUID lessonId, ExerciseRequest req, UserPrincipal p) {

        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        Lesson lesson = lessonService.findOrThrow(lessonId, courseId);

        Exercise ex = Exercise.builder()
                .lesson(lesson)
                .title(req.getTitle())
                .type(req.getType())
                .questionData(req.getQuestionData()) // STRING JSON
                .orderIndex(req.getOrderIndex())
                .points(req.getPoints())
                .timeLimitSeconds(req.getTimeLimitSeconds())
                .build();

        return toResponse(exerciseRepo.save(ex));
    }

    // ───────────────────────── UPDATE
    @Transactional
    public ExerciseResponse update(UUID courseId, UUID lessonId, UUID exerciseId,
                                   ExerciseRequest req, UserPrincipal p) {

        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        lessonService.findOrThrow(lessonId, courseId);

        Exercise ex = findOrThrow(exerciseId, lessonId);

        ex.setTitle(req.getTitle());
        ex.setType(req.getType());
        ex.setQuestionData(req.getQuestionData());
        ex.setOrderIndex(req.getOrderIndex());
        ex.setPoints(req.getPoints());
        ex.setTimeLimitSeconds(req.getTimeLimitSeconds());

        return toResponse(exerciseRepo.save(ex));
    }

    // ───────────────────────── DELETE
    @Transactional
    public void delete(UUID courseId, UUID lessonId, UUID exerciseId, UserPrincipal p) {

        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        lessonService.findOrThrow(lessonId, courseId);

        exerciseRepo.delete(findOrThrow(exerciseId, lessonId));
    }

    // ───────────────────────── SUBMIT
    @Transactional
    public SubmitResponse submit(UUID courseId, UUID lessonId, SubmitRequest req, UserPrincipal p) {

        if (p == null) throw new UnauthorizedException("Login required");

        courseService.findOrThrow(courseId);
        lessonService.findOrThrow(lessonId, courseId);

        Exercise ex = findOrThrow(req.getExerciseId(), lessonId);

        GradeResult grade = grade(ex, req);

        boolean isTimeout = false;
        if (ex.getTimeLimitSeconds() > 0
                && req.getClientStartTime() != null
                && req.getClientSubmitTime() != null) {

            long elapsed = (req.getClientSubmitTime() - req.getClientStartTime()) / 1000;
            isTimeout = elapsed > ex.getTimeLimitSeconds();
        }

        int pointsEarned = (ex.getType() == Exercise.ExerciseType.SPEAKING)
                ? grade.points()
                : (grade.correct ? ex.getPoints() : 0);

        UserProgress progress = progressRepo.findByUserIdAndLessonId(p.getUserId(), lessonId)
                .orElse(UserProgress.builder()
                        .user(userRepo.getReferenceById(p.getUserId()))
                        .course(courseRepo.getReferenceById(courseId))
                        .lesson(lessonRepo.getReferenceById(lessonId))
                        .build());

        // Nếu lesson đã COMPLETED và user làm lại → reset session score
        if (progress.getStatus() == ProgressStatus.COMPLETED) {
            progress.setScore(0);
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            progress.setCompletedAt(null);
        }

        progress.setAttempts(progress.getAttempts() + 1);
        progress.setScore(progress.getScore() + pointsEarned);

        int totalPoints = exerciseRepo.sumPointsByLessonId(lessonId);

        if (progress.getScore() >= totalPoints * 0.8) {
            progress.setStatus(ProgressStatus.COMPLETED);
            progress.setCompletedAt(Instant.now());
        } else {
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            if (progress.getStartedAt() == null) {
                progress.setStartedAt(Instant.now());
            }
        }

        progress.setBestScore(Math.max(progress.getBestScore(), progress.getScore()));
        progressRepo.save(progress);

        return SubmitResponse.builder()
                .correct(grade.correct && !isTimeout)
                .pointsEarned(pointsEarned)
                .correctAnswer(grade.correctAnswer)
                .explanation(grade.explanation)
                .totalLessonScore(progress.getScore())
                .build();
    }

    // ───────────────────────── GRADING
    private GradeResult grade(Exercise ex, SubmitRequest req) {

        try {
            JsonNode q = mapper.readTree(ex.getQuestionData());

            return switch (ex.getType()) {

                case MULTIPLE_CHOICE, LISTENING_CHOICE -> {
                    com.fasterxml.jackson.databind.JsonNode optionsNode = q.path("options");
                    int user = Integer.parseInt(req.getAnswer().trim());

                    // Support both "correctIndex":1 and "correct":"is" formats
                    int correctIndex;
                    String correctText;
                    if (q.has("correctIndex")) {
                        correctIndex = q.path("correctIndex").asInt(0);
                        correctText = (optionsNode.isArray() && correctIndex < optionsNode.size())
                                ? optionsNode.get(correctIndex).asText()
                                : String.valueOf(correctIndex);
                    } else {
                        String correctStr = q.path("correct").asText("");
                        correctIndex = -1;
                        if (optionsNode.isArray()) {
                            for (int i = 0; i < optionsNode.size(); i++) {
                                if (optionsNode.get(i).asText().equals(correctStr)) {
                                    correctIndex = i;
                                    break;
                                }
                            }
                        }
                        correctText = correctStr.isEmpty() ? String.valueOf(correctIndex) : correctStr;
                    }

                    boolean ok = correctIndex >= 0 && correctIndex == user;

                    yield new GradeResult(
                            ok,
                            ex.getPoints(),
                            correctText,
                            q.path("explanation").asText(null)
                    );
                }

                case FILL_IN_BLANK, TRANSLATION -> {
                    // Support both "answer" and "correct" field names
                    String correct = q.has("answer") ? q.path("answer").asText("") : q.path("correct").asText("");
                    boolean ok = !correct.isEmpty() && correct.equalsIgnoreCase(req.getAnswer().trim());

                    yield new GradeResult(
                            ok,
                            ex.getPoints(),
                            correct,
                            q.path("explanation").asText(null)
                    );
                }

                case SPEAKING -> {
                    String target = q.path("targetText").asText(
                            q.path("text").asText(
                                    q.path("sentence").asText("")));

                    if (req.getAudioUrl() == null || req.getAudioUrl().isBlank()) {
                        yield new GradeResult(false, 0, target, "No audio submitted");
                    }

                    String transcript = speechService.transcribeFromUrl(req.getAudioUrl());

                    // AI scoring via Groq LLM
                    String systemPrompt = """
                            You are a language pronunciation evaluator.
                            Given a target sentence and a speech transcript, score the pronunciation accuracy from 0 to 100.
                            Consider: correctness of words, completeness, and naturalness.
                            Respond in JSON only: {"score": <number>, "feedback": "<one short sentence>"}
                            """;
                    String userMessage = "Target: \"" + target + "\"\nTranscript: \"" + transcript + "\"";

                    int aiScore = 0;
                    String feedback = "Could not evaluate";
                    try {
                        String aiReply = aiClient.chat(systemPrompt, userMessage).getText().trim();
                        // Strip markdown code block if present
                        aiReply = aiReply.replaceAll("(?s)```(?:json)?\\s*", "").replaceAll("```", "").trim();
                        com.fasterxml.jackson.databind.JsonNode scoreNode = mapper.readTree(aiReply);
                        aiScore = scoreNode.path("score").asInt(0);
                        feedback = scoreNode.path("feedback").asText("Evaluated");
                    } catch (Exception ignored) {
                        // fallback to Levenshtein
                        double sim = scoringService.similarity(transcript, target);
                        aiScore = (int) (sim * 100);
                        feedback = "Score based on similarity";
                    }

                    int partialPoints = (int) Math.round(aiScore / 100.0 * ex.getPoints());
                    boolean ok = aiScore >= 60;
                    String explanation = "Score: " + aiScore + "/100 — " + feedback
                            + "\nYou said: \"" + transcript + "\""
                            + "\nTarget: \"" + target + "\"";

                    yield new GradeResult(ok, partialPoints, target, explanation);
                }

                case MATCHING, DRAG_DROP -> {
                    // user answer: "right1|right2|..." in order of left items
                    com.fasterxml.jackson.databind.JsonNode pairsNode = q.path("pairs");
                    String[] userRights = req.getAnswer().split("\\|", -1);

                    int total = pairsNode.size();
                    int matched = 0;
                    StringBuilder correctBuilder = new StringBuilder();
                    for (int i = 0; i < total; i++) {
                        String expectedRight = pairsNode.get(i).path("right").asText();
                        if (correctBuilder.length() > 0) correctBuilder.append("|");
                        correctBuilder.append(expectedRight);
                        if (i < userRights.length && userRights[i].trim().equalsIgnoreCase(expectedRight.trim())) {
                            matched++;
                        }
                    }
                    boolean ok = matched == total;
                    yield new GradeResult(ok, ok ? ex.getPoints() : 0, correctBuilder.toString(), null);
                }

                default -> new GradeResult(
                        false,
                        0,
                        "N/A",
                        null
                );
            };

        } catch (Exception e) {
            log.error("Grade error", e);
            return new GradeResult(
                    false,
                    0,
                    "N/A",
                    null
            );
        }
    }

    // ───────────────────────── FIND
    public Exercise findOrThrow(UUID exerciseId, UUID lessonId) {
        return exerciseRepo.findById(exerciseId)
                .filter(e -> e.getLesson().getId().equals(lessonId))
                .orElseThrow(() -> new NotFoundException("Exercise not found"));
    }

    // ───────────────────────── RESPONSE
    private ExerciseResponse toResponse(Exercise e) {

        List<Record> records = recordRepo.findByExercise_Id(e.getId());

        String audioUrl = records.isEmpty() ? null : records.get(0).getAudioUrl();

        return ExerciseResponse.builder()
                .id(e.getId())
                .lessonId(e.getLesson().getId())
                .title(e.getTitle())
                .type(e.getType())
                .questionData(e.getQuestionData())
                .audioUrl(audioUrl)
                .orderIndex(e.getOrderIndex())
                .points(e.getPoints())
                .timeLimitSeconds(e.getTimeLimitSeconds())
                .build();
    }

    // ───────────────────────── INNER CLASS
    private record GradeResult(
            boolean correct,
            int points,
            String correctAnswer,
            String explanation
    ) {}
}