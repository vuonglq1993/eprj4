package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.lesson.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Lesson.AccessTier;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Locale;
import java.util.UUID;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LessonService {

    private final LessonRepository       lessonRepo;
    private final CourseRepository       courseRepo;
    private final UserRepository         userRepo;
    private final UserProgressRepository progressRepo;
    private final CourseService          courseService;

    private Subscription.Plan getPlan(UserPrincipal p) {
        if (p == null) return Subscription.Plan.FREE;
        if ("ADMIN".equals(p.getRole())) return Subscription.Plan.YEARLY;
        return userRepo.findById(p.getUserId())
                .map(u -> u.getSubscription() != null ? u.getSubscription().getPlan() : Subscription.Plan.FREE)
                .orElse(Subscription.Plan.FREE);
    }

    private boolean canAccess(Lesson lesson, UserPrincipal p) {
        if (Boolean.TRUE.equals(lesson.getIsFree())) return true; // preview
        Subscription.Plan plan = getPlan(p);
        if (plan == Subscription.Plan.THREE_MONTHS || plan == Subscription.Plan.YEARLY) return true;
        if (plan == Subscription.Plan.MONTHLY) {
            return lesson.getAccessTier() == AccessTier.MONTHLY;
        }
        return false;
    }

    private String requiredPlanLabel(Lesson l) {
        if (Boolean.TRUE.equals(l.getIsFree())) return null;
        return (l.getAccessTier() == AccessTier.MONTHLY) ? "MONTHLY" : "UNLIMITED";
    }

    // ── GET DETAIL ────────────────────────────────────────────
    @Transactional(readOnly = true)
    public LessonDetailResponse getDetail(UUID courseId, UUID lessonId, UserPrincipal p) {
        Course course = courseService.findOrThrow(courseId);
        Lesson lesson = findOrThrow(lessonId, courseId);

        boolean ok = canAccess(lesson, p)
                || courseService.isAdminOrOwner(p, course);
        if (!ok) throw new ForbiddenException("Lesson requires plan: " + requiredPlanLabel(lesson));

        UserProgress progress = (p != null)
                ? progressRepo.findByUserIdAndLessonId(p.getUserId(), lessonId).orElse(null) : null;

        return toDetailResponse(lesson, progress, true);
    }

    // ── CREATE ────────────────────────────────────────────────
    @Transactional
    public LessonDetailResponse create(UUID courseId, LessonRequest req, UserPrincipal p) {
        Course course = courseService.findOrThrow(courseId);
        courseService.checkOwnerOrAdmin(p, course);

        int order = (req.getOrderIndex() != null && req.getOrderIndex() > 0)
                ? req.getOrderIndex() : lessonRepo.maxOrderIndex(courseId) + 1;

        AccessTier tier = null;
        if (req.getAccessTier() != null) {
            try {
                tier = AccessTier.valueOf(req.getAccessTier().trim().toUpperCase(Locale.ROOT));
            } catch (Exception ignored) {
                tier = null;
            }
        }

        Lesson saved = lessonRepo.save(Lesson.builder()
                .course(course).title(req.getTitle()).content(req.getContent())
                .type(req.getType())
                .orderIndex(order)
                .durationMinutes(req.getDurationMinutes() != null ? req.getDurationMinutes() : 0)
                .isFree(Boolean.TRUE.equals(req.getIsFree()))
                .accessTier(tier != null ? tier : (Boolean.TRUE.equals(req.getIsFree()) ? AccessTier.PREVIEW : AccessTier.UNLIMITED))
                .build());

        course.setTotalLessons(course.getTotalLessons() + 1);
        courseRepo.save(course);
        return toDetailResponse(saved, null, true);
    }

    // ── UPDATE ────────────────────────────────────────────────
    @Transactional
    public LessonDetailResponse update(UUID courseId, UUID lessonId, LessonRequest req, UserPrincipal p) {
        courseService.checkOwnerOrAdmin(p, courseService.findOrThrow(courseId));
        Lesson l = findOrThrow(lessonId, courseId);
        l.setTitle(req.getTitle());   l.setContent(req.getContent());
        l.setType(req.getType());
        if (req.getOrderIndex()      != null) l.setOrderIndex(req.getOrderIndex());
        if (req.getDurationMinutes() != null) l.setDurationMinutes(req.getDurationMinutes());
        if (req.getIsFree()          != null) l.setIsFree(req.getIsFree());
        if (req.getAccessTier()      != null) {
            try {
                l.setAccessTier(AccessTier.valueOf(req.getAccessTier().trim().toUpperCase(Locale.ROOT)));
            } catch (Exception ignored) {
                // ignore invalid tier
            }
        } else if (Boolean.TRUE.equals(req.getIsFree())) {
            // giữ tương thích: isFree=true thì tier ít nhất là PREVIEW
            l.setAccessTier(AccessTier.PREVIEW);
        }
        return toDetailResponse(lessonRepo.save(l), null, true);
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

    private LessonDetailResponse toDetailResponse(Lesson l, UserProgress pr, boolean accessible) {
        return LessonDetailResponse.builder()
                .id(l.getId()).courseId(l.getCourse().getId())
                .title(l.getTitle()).content(l.getContent()).type(l.getType())
                .orderIndex(l.getOrderIndex()).durationMinutes(l.getDurationMinutes())
                .isFree(l.getIsFree()).totalExercises(lessonRepo.countExercises(l.getId()))
                .createdAt(l.getCreatedAt())
                .isAccessible(accessible)
                .requiredPlan(accessible ? null : requiredPlanLabel(l))
                .progressStatus(pr != null ? pr.getStatus().name() : "NOT_STARTED")
                .score(pr != null ? pr.getScore() : 0).build();
    }
    // ── GET LIST LESSONS ────────────────────────────────
    @Transactional(readOnly = true)
    public List<LessonDetailResponse> getLessons(UUID courseId, UserPrincipal p) {
        Course course = courseService.findOrThrow(courseId);
        var lessons = lessonRepo.findByCourseIdOrderByOrderIndexAsc(courseId);

        return lessons.stream().map(l -> {
            UserProgress pr = (p != null)
                    ? progressRepo.findByUserIdAndLessonId(p.getUserId(), l.getId()).orElse(null)
                    : null;
            boolean accessible = canAccess(l, p) || courseService.isAdminOrOwner(p, course);
            LessonDetailResponse r = toDetailResponse(l, pr, accessible);
            // Nếu bị khóa thì không trả content
            if (!accessible) r.setContent(null);
            return r;
        }).toList();
    }
}
