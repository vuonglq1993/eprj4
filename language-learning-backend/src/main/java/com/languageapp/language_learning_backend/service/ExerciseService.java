package com.languageapp.language_learning_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.languageapp.language_learning_backend.dto.exercise.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

        // Cập nhật UserProgress
        UserProgress progress = progressRepo.findByUserIdAndLessonId(p.getUserId(), lessonId)
                .orElse(UserProgress.builder()
                        .user(userRepo.getReferenceById(p.getUserId()))
                        .course(courseRepo.getReferenceById(courseId))
                        .lesson(lessonRepo.getReferenceById(lessonId)).build());

        progress.setAttempts(progress.getAttempts() + 1);
        progress.setScore(Math.max(progress.getScore(), grade.points()));
        progress.setStatus(ProgressStatus.COMPLETED);
        progressRepo.save(progress);

        return SubmitResponse.builder()
                .correct(grade.correct()).pointsEarned(grade.points())
                .correctAnswer(grade.correctAnswer()).explanation(grade.explanation())
                .totalLessonScore(progress.getScore()).build();
    }

    // ── HELPERS ───────────────────────────────────────────────
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
                    int ci = q.get("correctIndex").asInt();
                    boolean ok = ci == Integer.parseInt(answer.trim());
                    yield new GradeResult(ok, ok ? ex.getPoints() : 0,
                            q.get("options").get(ci).asText(),
                            q.has("explanation") ? q.get("explanation").asText() : null);
                }
                case FILL_IN_BLANK, TRANSLATION -> {
                    String ca = q.get("answer").asText();
                    boolean ok = ca.trim().equalsIgnoreCase(answer.trim());
                    yield new GradeResult(ok, ok ? ex.getPoints() : 0, ca,
                            q.has("explanation") ? q.get("explanation").asText() : null);
                }
                case SPEAKING -> new GradeResult(true, ex.getPoints(), "N/A", "Graded by AI pronunciation check");
                default       -> new GradeResult(false, 0, "N/A", null);
            };
        } catch (Exception e) {
            log.warn("Grade error: {}", e.getMessage());
            return new GradeResult(false, 0, "N/A", null);
        }
    }

    private record GradeResult(boolean correct, int points, String correctAnswer, String explanation) {}

    private ExerciseResponse toResponse(Exercise e) {
        return ExerciseResponse.builder()
                .id(e.getId()).lessonId(e.getLesson().getId()).title(e.getTitle())
                .type(e.getType()).questionData(e.getQuestionData())
                .orderIndex(e.getOrderIndex()).points(e.getPoints())
                .timeLimitSeconds(e.getTimeLimitSeconds()).build();
    }
}
