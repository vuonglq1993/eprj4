package com.languageapp.language_learning_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.languageapp.language_learning_backend.dto.exercise.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Lesson.AccessTier;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.languageapp.language_learning_backend.entity.Record;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ExerciseService {

    private final ExerciseRepository     exerciseRepo;
    private final LessonRepository       lessonRepo;
    private final CourseRepository       courseRepo;
    private final UserProgressRepository progressRepo;
    private final UserRepository         userRepo;
    private final CourseService          courseService;
    private final LessonService          lessonService;
    private final ObjectMapper           mapper;
    private final RecordRepository recordRepo;

    // ── LIST ──────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public List<ExerciseResponse> list(UUID courseId, UUID lessonId, UserPrincipal p) {
        courseService.findOrThrow(courseId);
        lessonService.findOrThrow(lessonId, courseId);
        return exerciseRepo.findByLessonIdOrderByOrderIndexAsc(lessonId)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    // ── CREATE ────────────────────────────────────────────────
    @Transactional
    public ExerciseResponse create(UUID courseId, UUID lessonId, ExerciseRequest req, UserPrincipal p) {
        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        Lesson lesson = lessonService.findOrThrow(lessonId, courseId);
        return toResponse(exerciseRepo.save(Exercise.builder()
                .lesson(lesson).title(req.getTitle()).type(req.getType())
                .questionData(req.getQuestionData()).orderIndex(req.getOrderIndex())
                .points(req.getPoints()).timeLimitSeconds(req.getTimeLimitSeconds()).build()));
    }

    // ── UPDATE ────────────────────────────────────────────────
    @Transactional
    public ExerciseResponse update(UUID courseId, UUID lessonId, UUID exerciseId,
                                   ExerciseRequest req, UserPrincipal p) {
        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        lessonService.findOrThrow(lessonId, courseId);
        Exercise ex = findOrThrow(exerciseId, lessonId);
        ex.setTitle(req.getTitle()); ex.setType(req.getType());
        ex.setQuestionData(req.getQuestionData()); ex.setOrderIndex(req.getOrderIndex());
        ex.setPoints(req.getPoints()); ex.setTimeLimitSeconds(req.getTimeLimitSeconds());
        return toResponse(exerciseRepo.save(ex));
    }

    // ── DELETE ────────────────────────────────────────────────
    @Transactional
    public void delete(UUID courseId, UUID lessonId, UUID exerciseId, UserPrincipal p) {
        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        lessonService.findOrThrow(lessonId, courseId);
        exerciseRepo.delete(findOrThrow(exerciseId, lessonId));
    }

    // ── SUBMIT ────────────────────────────────────────────────
    @Transactional
    public SubmitResponse submit(UUID courseId, UUID lessonId, SubmitRequest req, UserPrincipal p) {
        if (p == null) throw new UnauthorizedException("Login required");
        Course course = courseService.findOrThrow(courseId);
        lessonService.findOrThrow(lessonId, courseId);
        Exercise ex = findOrThrow(req.getExerciseId(), lessonId);

        GradeResult grade = grade(ex, req.getAnswer());

        // Check timeout
        boolean isTimeout = false;
        if (ex.getTimeLimitSeconds() > 0
                && req.getClientStartTime() != null
                && req.getClientSubmitTime() != null) {
            long elapsed = (req.getClientSubmitTime() - req.getClientStartTime()) / 1000;
            isTimeout = elapsed > ex.getTimeLimitSeconds();
        }

        int pointsEarned = isTimeout ? 0 : grade.points();

        // Cập nhật UserProgress
        UserProgress progress = progressRepo.findByUserIdAndLessonId(p.getUserId(), lessonId)
                .orElse(UserProgress.builder()
                        .user(userRepo.getReferenceById(p.getUserId()))
                        .course(courseRepo.getReferenceById(courseId))
                        .lesson(lessonRepo.getReferenceById(lessonId)).build());

        // Nếu lesson đã COMPLETED và user làm lại → reset session score
        if (progress.getStatus() == ProgressStatus.COMPLETED) {
            progress.setScore(0);
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            progress.setCompletedAt(null);
        }

        progress.setAttempts(progress.getAttempts() + 1);
        progress.setScore(progress.getScore() + pointsEarned);

        // Lấy tổng điểm lesson
        int totalPoints = exerciseRepo.sumPointsByLessonId(lessonId);

        // Check hoàn thành (>=80%)
        if (progress.getScore() >= totalPoints * 0.8) {
            progress.setStatus(ProgressStatus.COMPLETED);
            progress.setCompletedAt(Instant.now());
        } else {
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            if (progress.getStartedAt() == null) {
                progress.setStartedAt(Instant.now());
            }
        }

        // Lưu bestScore = điểm tốt nhất qua các lần làm
        progress.setBestScore(Math.max(progress.getBestScore(), progress.getScore()));

        progressRepo.save(progress);

        // ✅ Tính coursePercent theo accessible lessons của plan (không dùng totalLessons)
        Subscription.Plan plan = getPlan(p);
        List<AccessTier> tiers = accessibleTiers(plan);
        long accessibleTotal = lessonRepo.countAccessible(courseId, tiers);
        int coursePercent = 0;
        if (accessibleTotal > 0) {
            long done = progressRepo.countCompletedAccessible(p.getUserId(), courseId, tiers);
            coursePercent = (int)(done * 100 / accessibleTotal);
        }

        return SubmitResponse.builder()
                .correct(grade.correct() && !isTimeout)
                .pointsEarned(pointsEarned)
                .correctAnswer(grade.correctAnswer())
                .explanation(grade.explanation())
                .totalLessonScore(progress.getScore())
                .isTimeout(isTimeout)
                .isCourseCompleted(coursePercent == 100)
                .courseId(coursePercent == 100 ? courseId : null)
                .build();
    }

    // ── HELPERS ───────────────────────────────────────────────

    /**
     * ✅ Lấy plan của user. ADMIN/TEACHER được coi như YEARLY.
     */
    private Subscription.Plan getPlan(UserPrincipal p) {
        if (p == null) return Subscription.Plan.FREE;
        if ("ADMIN".equals(p.getRole()) || "TEACHER".equals(p.getRole())) return Subscription.Plan.YEARLY;
        return userRepo.findById(p.getUserId())
                .map(u -> u.getSubscription() != null ? u.getSubscription().getPlan() : Subscription.Plan.FREE)
                .orElse(Subscription.Plan.FREE);
    }

    /**
     * ✅ Trả về các AccessTier mà plan này được phép truy cập.
     */
    private List<AccessTier> accessibleTiers(Subscription.Plan plan) {
        return switch (plan) {
            case THREE_MONTHS, YEARLY -> List.of(AccessTier.PREVIEW, AccessTier.MONTHLY, AccessTier.UNLIMITED);
            case MONTHLY              -> List.of(AccessTier.PREVIEW, AccessTier.MONTHLY);
            default                   -> List.of(AccessTier.PREVIEW);
        };
    }

    public Exercise findOrThrow(UUID exerciseId, UUID lessonId) {
        return exerciseRepo.findById(exerciseId)
                .filter(e -> e.getLesson().getId().equals(lessonId))
                .orElseThrow(() -> new NotFoundException("Exercise not found: " + exerciseId));
    }

    private GradeResult grade(Exercise ex, String answer) {
        try {
            JsonNode q = mapper.readTree(ex.getQuestionData());
            return switch (ex.getType()) {
                case MULTIPLE_CHOICE, LISTENING_CHOICE -> {
                    JsonNode opts = q.get("options");
                    int ci;
                    if (q.has("correctIndex") && !q.get("correctIndex").isNull()) {
                        ci = q.get("correctIndex").asInt();
                    } else {
                        // fallback: tìm index theo text "correct"
                        String correctText = q.has("correct") ? q.get("correct").asText() : "";
                        ci = -1;
                        for (int i = 0; i < opts.size(); i++) {
                            if (opts.get(i).asText().equalsIgnoreCase(correctText)) { ci = i; break; }
                        }
                    }
                    boolean ok = ci >= 0 && ci == Integer.parseInt(answer.trim());
                    String correctAnswerText = (ci >= 0 && opts != null) ? opts.get(ci).asText() : "";
                    yield new GradeResult(ok, ok ? ex.getPoints() : 0,
                            correctAnswerText,
                            q.has("explanation") ? q.get("explanation").asText() : null);
                }
                case FILL_IN_BLANK, TRANSLATION -> {
                    // support "answer" hoặc "correct" field
                    String ca = q.has("answer") && !q.get("answer").isNull()
                            ? q.get("answer").asText()
                            : q.has("correct") ? q.get("correct").asText() : "";
                    boolean ok = !ca.isEmpty() && ca.trim().equalsIgnoreCase(answer.trim());
                    yield new GradeResult(ok, ok ? ex.getPoints() : 0, ca,
                            q.has("explanation") ? q.get("explanation").asText() : null);
                }
                case SPEAKING -> new GradeResult(true, ex.getPoints(), "N/A",
                        "Graded by AI pronunciation check");
                case MATCHING, DRAG_DROP -> {
                    // Pairs matching exercise
                    if (q.has("pairs")) {
                        String[] userAnswers = answer.split("\\|", -1);
                        JsonNode pairs = q.get("pairs");
                        boolean allCorrect = pairs.size() == userAnswers.length;
                        if (allCorrect) {
                            for (int i = 0; i < pairs.size(); i++) {
                                String correctRight = pairs.get(i).get("right").asText();
                                if (!correctRight.trim().equalsIgnoreCase(userAnswers[i].trim())) {
                                    allCorrect = false; break;
                                }
                            }
                        }
                        yield new GradeResult(allCorrect, allCorrect ? ex.getPoints() : 0,
                                "All pairs matched correctly",
                                q.has("explanation") ? q.get("explanation").asText() : null);
                    }
                    String type = q.has("type") ? q.get("type").asText() : "FILL_BLANK";
                    if ("WORD_ORDER".equals(type)) {
                        String correctOrder = q.get("correctOrder").toString()
                                .replaceAll("[\\[\\] ]", "");
                        boolean ok = correctOrder.equals(answer.trim());
                        yield new GradeResult(ok, ok ? ex.getPoints() : 0,
                                q.get("correctSentence").asText(),
                                q.has("explanation") ? q.get("explanation").asText() : null);
                    } else {
                        int ci = q.get("correctIndex").asInt();
                        boolean ok = ci == Integer.parseInt(answer.trim());
                        yield new GradeResult(ok, ok ? ex.getPoints() : 0,
                                q.get("options").get(ci).asText(),
                                q.has("explanation") ? q.get("explanation").asText() : null);
                    }
                }
                default -> new GradeResult(false, 0, "N/A", null);
            };
        } catch (Exception e) {
            log.warn("Grade error: {}", e.getMessage());
            return new GradeResult(false, 0, "N/A", null);
        }
    }

    private record GradeResult(boolean correct, int points, String correctAnswer, String explanation) {}

    private ExerciseResponse toResponse(Exercise e) {

        List<Record> records = recordRepo.findByExercise_Id(e.getId());

        String audioUrl = records.isEmpty()
                ? null
                : records.get(0).getAudioUrl();

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
}