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

import java.time.Duration;
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
    private final ExerciseRepository exerciseRepository;
    private final ExerciseAttemptRepository attemptRepository;
    private final UserProgressRepository progressRepository;


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
        // cộng điểm
        progress.setScore(progress.getScore() + grade.points());

// lấy tổng điểm lesson
        int totalPoints = exerciseRepo.sumPointsByLessonId(lessonId);

// check hoàn thành (>=80%)
        if (progress.getScore() >= totalPoints * 0.8) {
            progress.setStatus(ProgressStatus.COMPLETED);
            progress.setCompletedAt(Instant.now());
        } else {
            progress.setStatus(ProgressStatus.IN_PROGRESS);
            if (progress.getStartedAt() == null) {
                progress.setStartedAt(Instant.now());
            }
        }
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



        public ExerciseAttempt submitExercise(UUID userId, UUID exerciseId, String userAnswer) {

            Exercise exercise = exerciseRepository.findById(exerciseId)
                    .orElseThrow(() -> new RuntimeException("Exercise not found"));

            UserProgress progress = progressRepository
                    .findByUserIdAndLessonId(userId, exercise.getLesson().getId())
                    .orElseThrow(() -> new RuntimeException("Progress not found"));

            Instant now = Instant.now();

            // ❗ nếu chưa start thì set start
            if (progress.getStartedAt() == null) {
                progress.setStartedAt(now);
            }

            // ⏱ tính thời gian
            Duration duration = Duration.between(progress.getStartedAt(), now);
            int seconds = (int) duration.getSeconds();

            // ❗ check timeout
            boolean isTimeout = seconds > exercise.getTimeLimitSeconds();

            // 🎯 check đúng sai (tùy bạn parse JSON)
            boolean isCorrect = checkAnswer(exercise, userAnswer);

            int score = isTimeout ? 0 : (isCorrect ? exercise.getPoints() : 0);

            // 💾 lưu attempt
            ExerciseAttempt attempt = ExerciseAttempt.builder()
                    .user(progress.getUser())
                    .exercise(exercise)
                    .progress(progress)
                    .startedAt(progress.getStartedAt())
                    .submittedAt(now)
                    .durationSeconds(seconds)
                    .isCorrect(isCorrect)
                    .score(score)
                    .isTimeout(isTimeout)
                    .userAnswer(userAnswer)
                    .build();

            attemptRepository.save(attempt);

            // 🔥 update progress
            progress.setTimeSpentSeconds(progress.getTimeSpentSeconds() + seconds);
            progress.setAttempts(progress.getAttempts() + 1);

            if (!isTimeout && isCorrect) {
                progress.setScore(progress.getScore() + score);
            }

            progress.setCompletedAt(now);
            progressRepository.save(progress);

            return attempt;
        }

        private boolean checkAnswer(Exercise exercise, String userAnswer) {
            // TODO: parse JSON questionData
            return true;
        }
    }

