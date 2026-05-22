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
    private final ExerciseAttemptRepository attemptRepo;

    private final SpeechService speechService;
    private final ScoringService scoringService;
    private final com.languageapp.language_learning_backend.ai.client.AiClient aiClient;
    private final GamificationService gamificationService;

    // ───────────────────────── LIST
    @Transactional(readOnly = true)
    public List<ExerciseResponse> list(UUID courseId, UUID lessonId, String lang, UserPrincipal p) {
        courseService.findOrThrow(courseId);
        lessonService.findOrThrow(lessonId, courseId);

        String l = (lang != null && !lang.isBlank()) ? lang : "vi";
        return exerciseRepo.findByLessonIdOrderByOrderIndexAsc(lessonId)
                .stream()
                .map(e -> toResponse(e, l))
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

        String lang = (req.getLang() != null && !req.getLang().isBlank()) ? req.getLang() : "vi";
        GradeResult grade = grade(ex, req, lang);

        boolean isTimeout = false;
        if (ex.getTimeLimitSeconds() > 0
                && req.getClientStartTime() != null
                && req.getClientSubmitTime() != null) {

            long elapsed = (req.getClientSubmitTime() - req.getClientStartTime()) / 1000;
            isTimeout = elapsed > ex.getTimeLimitSeconds();
        }

        boolean effectivelyCorrect = grade.correct && !isTimeout;
        int pointsEarned = (ex.getType() == Exercise.ExerciseType.SPEAKING)
                ? grade.points()
                : (effectivelyCorrect ? ex.getPoints() : 0);

        UserProgress progress = progressRepo.findByUserIdAndLessonId(p.getUserId(), lessonId)
                .orElse(UserProgress.builder()
                        .user(userRepo.getReferenceById(p.getUserId()))
                        .course(courseRepo.getReferenceById(courseId))
                        .lesson(lessonRepo.getReferenceById(lessonId))
                        .build());

        // Track whether lesson was already completed before this session (replay = no new XP)
        boolean wasAlreadyCompleted = progress.getStatus() == ProgressStatus.COMPLETED
                && Boolean.TRUE.equals(req.getResetSession());

        // Reset only when user explicitly starts a new session (resetSession=true on first exercise)
        if (Boolean.TRUE.equals(req.getResetSession())) {
            progress.setScore(0);
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            progress.setCompletedAt(null);
        }

        ProgressStatus statusBeforeSubmit = progress.getStatus();

        progress.setAttempts(progress.getAttempts() + 1);
        progress.setScore(progress.getScore() + pointsEarned);

        Integer rawTotal = exerciseRepo.sumPointsByLessonId(lessonId);
        int totalPoints = (rawTotal != null) ? rawTotal : 0;

        if (totalPoints > 0 && progress.getScore() >= totalPoints * 0.8) {
            progress.setStatus(ProgressStatus.COMPLETED);
            progress.setCompletedAt(Instant.now());
        } else {
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            if (progress.getStartedAt() == null) {
                progress.setStartedAt(Instant.now());
            }
        }

        boolean justCompleted = statusBeforeSubmit != ProgressStatus.COMPLETED
                && progress.getStatus() == ProgressStatus.COMPLETED;

        progress.setBestScore(Math.max(progress.getBestScore(), progress.getScore()));
        progressRepo.save(progress);

        // Save exercise attempt for history / AI review
        try {
            String selectedAnswerJson = mapper.writeValueAsString(req.getAnswer());
            Integer timeSpent = (req.getClientStartTime() != null && req.getClientSubmitTime() != null)
                    ? (int) ((req.getClientSubmitTime() - req.getClientStartTime()) / 1000) : null;
            attemptRepo.save(ExerciseAttempt.builder()
                    .user(userRepo.getReferenceById(p.getUserId()))
                    .exercise(ex)
                    .lesson(lessonRepo.getReferenceById(lessonId))
                    .selectedAnswer(selectedAnswerJson)
                    .isCorrect(effectivelyCorrect)
                    .score(pointsEarned)
                    .timeSpentSeconds(timeSpent)
                    .build());
        } catch (Exception e) {
            log.warn("Failed to save exercise attempt: {}", e.getMessage());
        }

        // Award XP per correct exercise (not on replays)
        if (pointsEarned > 0 && !wasAlreadyCompleted) {
            try {
                User user = userRepo.getReferenceById(p.getUserId());
                gamificationService.awardXp(user, pointsEarned);
            } catch (Exception e) {
                log.warn("Failed to award XP to user {}: {}", p.getUserId(), e.getMessage());
            }
        }

        // Award lesson completion bonus (first time only)
        if (justCompleted) {
            try {
                User user = userRepo.getReferenceById(p.getUserId());
                boolean isPerfect = totalPoints > 0 && progress.getScore() >= totalPoints;
                int lessonXp = GamificationService.XP_COMPLETE_LESSON
                        + (isPerfect ? GamificationService.XP_PERFECT_LESSON : 0);
                gamificationService.awardXp(user, lessonXp);
                if (isPerfect) gamificationService.awardPerfectScoreBadge(user);
                log.info("Lesson completed XP: user={} xp={} perfect={}", p.getUserId(), lessonXp, isPerfect);
            } catch (Exception e) {
                log.warn("Failed to award lesson XP: {}", e.getMessage());
            }
        }

        boolean isLessonCompleted = progress.getStatus() == ProgressStatus.COMPLETED;
        return SubmitResponse.builder()
                .correct(effectivelyCorrect)
                .pointsEarned(pointsEarned)
                .correctAnswer(grade.correctAnswer)
                .explanation(grade.explanation)
                .totalLessonScore(progress.getScore())
                .isLessonCompleted(isLessonCompleted)
                .lessonStatus(progress.getStatus().name())
                .build();
    }

    // ───────────────────────── GRADING
    private GradeResult grade(Exercise ex, SubmitRequest req, String lang) {

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
                            resolveText(q.path("explanation"), lang)
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
                            resolveText(q.path("explanation"), lang)
                    );
                }

                case SPEAKING -> {
                    // Support both old format (targetText/sentence) and new format (question/sample_answer)
                    String question = resolveText(q.path("question"), lang);
                    if (question == null || question.isBlank()) {
                        question = q.path("targetText").asText(
                                q.path("text").asText(
                                        q.path("sentence").asText("")));
                    }
                    String sampleAnswer = q.path("sample_answer").asText("");
                    String hint         = q.path("hint").asText("");

                    // Build keyword list from expected_keywords array
                    com.fasterxml.jackson.databind.JsonNode kwNode = q.path("expected_keywords");
                    java.util.List<String> keywords = new java.util.ArrayList<>();
                    if (kwNode.isArray()) {
                        kwNode.forEach(kw -> keywords.add(kw.asText()));
                    }

                    if (req.getAudioUrl() == null || req.getAudioUrl().isBlank()) {
                        yield new GradeResult(false, 0, question, "No audio submitted");
                    }

                    String transcript = speechService.transcribeFromUrl(req.getAudioUrl());

                    // Build context-aware AI prompt
                    String keywordList = keywords.isEmpty() ? "(none)" : String.join(", ", keywords);
                    String systemPrompt = """
                            You are an English speaking exercise evaluator.
                            Score the learner's spoken response from 0 to 100 based on:
                            - Relevance: does the response address the question/topic? (40 pts)
                            - Keywords: how many expected keywords are mentioned? (30 pts)
                            - Completeness: is the response sufficiently developed? (20 pts)
                            - Fluency/Naturalness: does it sound natural in English? (10 pts)
                            Respond ONLY in JSON: {"score": <0-100>, "feedback": "<one encouraging sentence in Vietnamese>", "keywords_found": [<list of matched keywords>]}
                            """;

                    String userMessage = String.format(
                            """
                            Question: "%s"
                            Hint: "%s"
                            Sample answer: "%s"
                            Expected keywords: [%s]
                            Learner's transcript: "%s"
                            """,
                            question, hint, sampleAnswer, keywordList, transcript);

                    int aiScore = 0;
                    String feedback = "Could not evaluate";
                    java.util.List<String> foundKeywords = new java.util.ArrayList<>();

                    try {
                        String aiReply = aiClient.chat(systemPrompt, userMessage).getText().trim();
                        aiReply = aiReply.replaceAll("(?s)```(?:json)?\\s*", "").replaceAll("```", "").trim();
                        com.fasterxml.jackson.databind.JsonNode scoreNode = mapper.readTree(aiReply);
                        aiScore  = Math.min(100, Math.max(0, scoreNode.path("score").asInt(0)));
                        feedback = scoreNode.path("feedback").asText("Evaluated");
                        scoreNode.path("keywords_found").forEach(k -> foundKeywords.add(k.asText()));
                    } catch (Exception ignored) {
                        // Fallback: count keyword matches in transcript
                        String lower = transcript.toLowerCase();
                        for (String kw : keywords) {
                            if (lower.contains(kw.toLowerCase())) {
                                foundKeywords.add(kw);
                            }
                        }
                        int kwScore  = keywords.isEmpty() ? 50 : (int)(foundKeywords.size() * 100.0 / keywords.size());
                        double sim   = sampleAnswer.isBlank() ? 0 : scoringService.similarity(transcript, sampleAnswer);
                        aiScore      = (int)((kwScore * 0.5) + (sim * 100 * 0.5));
                        feedback     = "Chấm dựa trên từ khoá: " + foundKeywords.size() + "/" + keywords.size();
                    }

                    int partialPoints = (int) Math.round(aiScore / 100.0 * ex.getPoints());
                    boolean ok = aiScore >= 60;
                    String explanation = "Score: " + aiScore + "/100 — " + feedback
                            + "\nKeywords found: " + (foundKeywords.isEmpty() ? "none" : String.join(", ", foundKeywords))
                            + "\nYou said: \"" + transcript + "\""
                            + "\nSample: \"" + sampleAnswer + "\"";

                    yield new GradeResult(ok, partialPoints, question, explanation);
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
        return toResponse(e, "vi");
    }

    private ExerciseResponse toResponse(Exercise e, String lang) {
        List<Record> records = recordRepo.findByExercise_Id(e.getId());
        String audioUrl = records.isEmpty() ? null : records.get(0).getAudioUrl();

        return ExerciseResponse.builder()
                .id(e.getId())
                .lessonId(e.getLesson().getId())
                .title(e.getTitle())
                .type(e.getType())
                .questionData(resolveI18n(e.getQuestionData(), lang))
                .audioUrl(audioUrl)
                .orderIndex(e.getOrderIndex())
                .points(e.getPoints())
                .timeLimitSeconds(e.getTimeLimitSeconds())
                .build();
    }

    // ───────────────────────── I18N RESOLVER
    private String resolveText(JsonNode node, String lang) {
        if (node == null || node.isMissingNode() || node.isNull()) return null;
        if (node.isObject()) {
            JsonNode v = node.path(lang);
            if (v.isMissingNode() || v.isNull()) v = node.path("en");
            if (v.isMissingNode() || v.isNull()) v = node.path("vi");
            return (v.isMissingNode() || v.isNull()) ? null : v.asText();
        }
        return node.asText(null);
    }

    // Nếu question/explanation/hints là object {vi, en, ja} → lấy đúng lang.
    // Nếu là plain string/array (format cũ) → giữ nguyên (backward compatible).
    private String resolveI18n(String questionData, String lang) {
        try {
            JsonNode root = mapper.readTree(questionData);
            if (!root.isObject()) return questionData;

            com.fasterxml.jackson.databind.node.ObjectNode out =
                    ((com.fasterxml.jackson.databind.node.ObjectNode) root).deepCopy();

            for (String field : new String[]{"question", "explanation", "hints"}) {
                JsonNode node = root.path(field);
                if (!node.isObject()) continue; // plain string/array → không chạm

                // Lấy lang → fallback en → fallback vi
                JsonNode resolved = node.path(lang);
                if (resolved.isMissingNode() || resolved.isNull()) resolved = node.path("en");
                if (resolved.isMissingNode() || resolved.isNull()) resolved = node.path("vi");
                if (!resolved.isMissingNode() && !resolved.isNull()) out.set(field, resolved);
            }

            return mapper.writeValueAsString(out);
        } catch (Exception e) {
            return questionData;
        }
    }

    // ───────────────────────── INNER CLASS
    private record GradeResult(
            boolean correct,
            int points,
            String correctAnswer,
            String explanation
    ) {}
}