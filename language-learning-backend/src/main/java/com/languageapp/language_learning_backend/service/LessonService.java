package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.lesson.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LessonService {

    private final LessonRepository       lessonRepo;
    private final CourseRepository       courseRepo;
    private final UserRepository         userRepo;
    private final UserProgressRepository progressRepo;
    private final CourseService          courseService;

    // ── GET DETAIL ────────────────────────────────────────────
    @Transactional(readOnly = true)
    public LessonDetailResponse getDetail(UUID courseId, UUID lessonId, UserPrincipal p) {
        Course course = courseService.findOrThrow(courseId);
        Lesson lesson = findOrThrow(lessonId, courseId);

        boolean canAccess = lesson.getIsFree()
                || courseService.isAdminOrOwner(p, course)
                || isPremium(p);
        if (!canAccess) throw new ForbiddenException("Premium subscription required");

        UserProgress progress = (p != null)
                ? progressRepo.findByUserIdAndLessonId(p.getUserId(), lessonId).orElse(null) : null;

        return toDetailResponse(lesson, progress);
    }

    // ── CREATE ────────────────────────────────────────────────
    @Transactional
    public LessonDetailResponse create(UUID courseId, LessonRequest req, UserPrincipal p) {
        Course course = courseService.findOrThrow(courseId);
        courseService.checkOwnerOrAdmin(p, course);

        int order = (req.getOrderIndex() != null && req.getOrderIndex() > 0)
                ? req.getOrderIndex() : lessonRepo.maxOrderIndex(courseId) + 1;

        Lesson saved = lessonRepo.save(Lesson.builder()
                .course(course).title(req.getTitle()).content(req.getContent())
                .type(req.getType()).videoUrl(req.getVideoUrl()).audioUrl(req.getAudioUrl())
                .orderIndex(order)
                .durationMinutes(req.getDurationMinutes() != null ? req.getDurationMinutes() : 0)
                .isFree(Boolean.TRUE.equals(req.getIsFree())).build());

        course.setTotalLessons(course.getTotalLessons() + 1);
        courseRepo.save(course);
        return toDetailResponse(saved, null);
    }

    // ── UPDATE ────────────────────────────────────────────────
    @Transactional
    public LessonDetailResponse update(UUID courseId, UUID lessonId, LessonRequest req, UserPrincipal p) {
        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        Lesson l = findOrThrow(lessonId, courseId);
        l.setTitle(req.getTitle());   l.setContent(req.getContent());
        l.setType(req.getType());     l.setVideoUrl(req.getVideoUrl());
        l.setAudioUrl(req.getAudioUrl());
        if (req.getOrderIndex()      != null) l.setOrderIndex(req.getOrderIndex());
        if (req.getDurationMinutes() != null) l.setDurationMinutes(req.getDurationMinutes());
        if (req.getIsFree()          != null) l.setIsFree(req.getIsFree());
        return toDetailResponse(lessonRepo.save(l), null);
    }

    // ── DELETE ────────────────────────────────────────────────
    @Transactional
    public void delete(UUID courseId, UUID lessonId, UserPrincipal p) {
        Course course = courseService.findOrThrow(courseId);
        courseService.checkOwnerOrAdmin(p, course);
        lessonRepo.delete(findOrThrow(lessonId, courseId));
        course.setTotalLessons(Math.max(0, course.getTotalLessons() - 1));
        courseRepo.save(course);
    }

    // ── PUBLIC HELPERS ────────────────────────────────────────
    public Lesson findOrThrow(UUID lessonId, UUID courseId) {
        return lessonRepo.findById(lessonId)
                .filter(l -> l.getCourse().getId().equals(courseId))
                .orElseThrow(() -> new NotFoundException("Lesson not found: " + lessonId));
    }

    // ── PRIVATE ───────────────────────────────────────────────
    private boolean isPremium(UserPrincipal p) {
        if (p == null) return false;
        if ("ADMIN".equals(p.getRole()) || "TEACHER".equals(p.getRole())) return true;
        return userRepo.findById(p.getUserId())
                .map(u -> u.isPremium()).orElse(false);
    }

    private LessonDetailResponse toDetailResponse(Lesson l, UserProgress pr) {
        return LessonDetailResponse.builder()
                .id(l.getId()).courseId(l.getCourse().getId())
                .title(l.getTitle()).content(l.getContent()).type(l.getType())
                .videoUrl(l.getVideoUrl()).audioUrl(l.getAudioUrl())
                .orderIndex(l.getOrderIndex()).durationMinutes(l.getDurationMinutes())
                .isFree(l.getIsFree()).totalExercises(lessonRepo.countExercises(l.getId()))
                .createdAt(l.getCreatedAt())
                .progressStatus(pr != null ? pr.getStatus().name() : "NOT_STARTED")
                .score(pr != null ? pr.getScore() : 0).build();
    }
}
