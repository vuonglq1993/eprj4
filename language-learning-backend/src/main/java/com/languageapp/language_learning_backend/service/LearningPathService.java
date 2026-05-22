package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.course.PageResponse;
import com.languageapp.language_learning_backend.dto.learningpath.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.LearningPath.TargetLevel;
import com.languageapp.language_learning_backend.entity.UserLearningPath.PathStatus;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LearningPathService {

    private final LearningPathRepository     pathRepo;
    private final UserLearningPathRepository userPathRepo;
    private final CourseRepository           courseRepo;
    private final LanguageRepository         languageRepo;
    private final UserRepository             userRepo;
    private final UserProgressRepository     progressRepo;
    private final LessonRepository           lessonRepo;
    private final UserOnboardingRepository   onboardingRepo;
    private Subscription.Plan getPlan(UUID userId) {
        return userRepo.findById(userId)
                .map(u -> u.getSubscription() != null ? u.getSubscription().getPlan() : Subscription.Plan.FREE)
                .orElse(Subscription.Plan.FREE);
    }

    private int calcAccessibleCourseProgressPercent(UUID userId, Course c, Subscription.Plan plan) {
        int total = c.getTotalLessons();
        if (total == 0) return 0;
        long done = progressRepo.countCompleted(userId, c.getId(), ProgressStatus.COMPLETED);
        return (int) (done * 100 / total);
    }


    // ── LIST (public) ─────────────────────────────────────────
    @Transactional(readOnly = true)
    public PageResponse<LearningPathResponse> getPublished(UUID languageId, TargetLevel level,
                                                           String kw, int page, int size,
                                                           UserPrincipal p) {
        Page<LearningPath> result = pathRepo.findPublished(
                languageId, level, kw, PageRequest.of(page, size));

        List<LearningPathResponse> content = result.getContent().stream()
                .map(lp -> toSummaryResponse(lp, p))
                .collect(Collectors.toList());

        return PageResponse.<LearningPathResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(result.getTotalElements())
                .totalPages(result.getTotalPages())
                .last(result.isLast()).build();
    }

    // ── LIST (Admin — all including unpublished) ────────────────
    @Transactional(readOnly = true)
    public PageResponse<LearningPathResponse> getAllForAdmin(UUID languageId, TargetLevel level,
                                                            String kw, int page, int size) {
        Page<LearningPath> result = pathRepo.findAllForAdmin(
                languageId, level, kw, PageRequest.of(page, size));

        List<LearningPathResponse> content = result.getContent().stream()
                .map(lp -> toSummaryResponse(lp, null))
                .collect(Collectors.toList());

        return PageResponse.<LearningPathResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(result.getTotalElements())
                .totalPages(result.getTotalPages())
                .last(result.isLast()).build();
    }

    // ── DETAIL ────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public LearningPathResponse getDetail(UUID pathId, UserPrincipal p) {
        LearningPath lp = findOrThrow(pathId);
        if (!lp.getIsPublished() && !isAdmin(p))
            throw new ForbiddenException("Learning path not available");

        // Lấy enroll của user (nếu có)
        UserLearningPath userPath = (p != null)
                ? userPathRepo.findByUserIdAndLearningPathId(p.getUserId(), pathId).orElse(null)
                : null;

        // Map tiến độ từng course
        Map<UUID, Integer> courseProgress = (p != null)
                ? buildCourseProgressMap(p.getUserId(), lp)
                : Collections.emptyMap();

        List<LearningPathResponse.StepResponse> steps = buildStepResponses(lp, courseProgress, userPath);

        int pct = calcPathProgress(courseProgress, lp);

        return LearningPathResponse.builder()
                .id(lp.getId())
                .title(lp.getTitle())
                .description(lp.getDescription())
                .languageCode(lp.getLanguage().getCode())
                .languageName(lp.getLanguage().getName())
                .targetLevel(lp.getTargetLevel())
                .goal(lp.getGoal())
                .estimatedHours(lp.getEstimatedHours())
                .isPublished(lp.getIsPublished())
                .isOfficial(lp.getIsOfficial())
                .totalSteps(lp.getSteps().size())
                .totalCourses(lp.getSteps().size())
                .createdByName(lp.getCreatedBy() != null ? lp.getCreatedBy().getFullName() : "LinguaNext")
                .createdAt(lp.getCreatedAt())
                .progressPercent(p != null ? pct : null)
                .currentStep(userPath != null ? userPath.getCurrentStep() : null)
                .enrollStatus(userPath != null ? userPath.getStatus().name() : null)
                .steps(steps)
                .build();
    }

    // ── CREATE (Admin / Teacher) ──────────────────────────────
    @Transactional
    public LearningPathResponse create(LearningPathRequest req, UserPrincipal p) {
        Language lang = languageRepo.findById(req.getLanguageId())
                .orElseThrow(() -> new NotFoundException("Language not found"));

        LearningPath lp = LearningPath.builder()
                .language(lang)
                .title(req.getTitle())
                .description(req.getDescription())
                .targetLevel(req.getTargetLevel())
                .goal(req.getGoal())
                .estimatedHours(req.getEstimatedHours() != null ? req.getEstimatedHours() : 0)
                .isPublished(Boolean.TRUE.equals(req.getIsPublished()))
                .isOfficial("ADMIN".equals(p.getRole()) && Boolean.TRUE.equals(req.getIsOfficial()))
                .createdBy(userRepo.getReferenceById(p.getUserId()))
                .build();

        // Gắn các bước
        List<LearningPathStep> steps = buildSteps(req.getSteps(), lp);
        lp.setSteps(steps);

        return toDetailResponse(pathRepo.save(lp), null, Collections.emptyMap());
    }

    // ── UPDATE ────────────────────────────────────────────────
    @Transactional
    public LearningPathResponse update(UUID pathId, LearningPathRequest req, UserPrincipal p) {
        LearningPath lp = findOrThrow(pathId);
        checkOwnerOrAdmin(p, lp);

        Language lang = languageRepo.findById(req.getLanguageId())
                .orElseThrow(() -> new NotFoundException("Language not found"));

        lp.setLanguage(lang);
        lp.setTitle(req.getTitle());
        lp.setDescription(req.getDescription());
        lp.setTargetLevel(req.getTargetLevel());
        lp.setGoal(req.getGoal());
        if (req.getEstimatedHours() != null) lp.setEstimatedHours(req.getEstimatedHours());
        if (req.getIsPublished()    != null) lp.setIsPublished(req.getIsPublished());

        // Thay toàn bộ steps
        lp.getSteps().clear();
        pathRepo.saveAndFlush(lp);
        lp.getSteps().addAll(buildSteps(req.getSteps(), lp));

        return toDetailResponse(pathRepo.save(lp), null, Collections.emptyMap());
    }

    // ── TOGGLE PUBLISH ────────────────────────────────────────
    @Transactional
    public LearningPathResponse togglePublish(UUID pathId, UserPrincipal p) {
        LearningPath lp = findOrThrow(pathId);
        checkOwnerOrAdmin(p, lp);
        if (!lp.getIsPublished() && lp.getSteps().isEmpty())
            throw new BadRequestException("Cannot publish a learning path with no steps");
        lp.setIsPublished(!lp.getIsPublished());
        return toDetailResponse(pathRepo.save(lp), null, Collections.emptyMap());
    }

    // ── DELETE ────────────────────────────────────────────────
    @Transactional
    public void delete(UUID pathId, UserPrincipal p) {
        LearningPath lp = findOrThrow(pathId);
        checkOwnerOrAdmin(p, lp);
        pathRepo.delete(lp);
    }

    // ── ENROLL ────────────────────────────────────────────────
    @Transactional
    public Map<String, Object> enroll(UUID pathId, UserPrincipal p) {
        if (p == null) throw new UnauthorizedException("Login required");
        LearningPath lp = findOrThrow(pathId);
        if (!lp.getIsPublished()) throw new BadRequestException("Learning path is not available");

        if (userPathRepo.existsByUserIdAndLearningPathId(p.getUserId(), pathId))
            throw new ConflictException("Already enrolled in this learning path");

        // Hard lock: check user's self-reported level vs path target level
        if (lp.getTargetLevel() != null) {
            onboardingRepo.findByUserId(p.getUserId()).ifPresent(ob -> {
                if (ob.getSelfLevel() != null && levelRank(ob.getSelfLevel()) < pathLevelRank(lp.getTargetLevel())) {
                    throw new BadRequestException(
                        "Trình độ của bạn chưa phù hợp với lộ trình này. " +
                        "Lộ trình yêu cầu: " + lp.getTargetLevel().name());
                }
            });
        }

        userPathRepo.save(UserLearningPath.builder()
                .user(userRepo.getReferenceById(p.getUserId()))
                .learningPath(lp)
                .currentStep(0)
                .progressPercent(0)
                .status(PathStatus.IN_PROGRESS)
                .build());

        return Map.of(
                "message", "Enrolled successfully",
                "pathId",  pathId,
                "title",   lp.getTitle()
        );
    }

    // ── UNENROLL ──────────────────────────────────────────────
    @Transactional
    public void unenroll(UUID pathId, UserPrincipal p) {
        UserLearningPath ulp = userPathRepo
                .findByUserIdAndLearningPathId(p.getUserId(), pathId)
                .orElseThrow(() -> new NotFoundException("Not enrolled in this path"));
        userPathRepo.delete(ulp);
    }

    // ── MY PATHS ──────────────────────────────────────────────
    @Transactional(readOnly = true)
    public List<LearningPathResponse> getMyPaths(UserPrincipal p) {
        return userPathRepo.findByUserIdOrderByUpdatedAtDesc(p.getUserId()).stream()
                .map(ulp -> {
                    LearningPath lp = ulp.getLearningPath();
                    Map<UUID, Integer> cp = buildCourseProgressMap(p.getUserId(), lp);
                    int pct = calcPathProgress(cp, lp);
                    // Cập nhật progressPercent nếu thay đổi
                    if (!Objects.equals(ulp.getProgressPercent(), pct)) {
                        ulp.setProgressPercent(pct);
                        if (pct == 100 && ulp.getStatus() != PathStatus.COMPLETED) {
                            ulp.setStatus(PathStatus.COMPLETED);
                            ulp.setCompletedAt(Instant.now());
                        }
                        userPathRepo.save(ulp);
                    }
                    return toSummaryResponse(lp, p);
                })
                .collect(Collectors.toList());
    }

    // ── PRIVATE HELPERS ───────────────────────────────────────
    public LearningPath findOrThrow(UUID id) {
        return pathRepo.findById(id)
                .orElseThrow(() -> new NotFoundException("Learning path not found: " + id));
    }

    private boolean isAdmin(UserPrincipal p) {
        return p != null && "ADMIN".equals(p.getRole());
    }

    private void checkOwnerOrAdmin(UserPrincipal p, LearningPath lp) {
        boolean isOwner = lp.getCreatedBy() != null
                && lp.getCreatedBy().getId().equals(p.getUserId());
        if (!isAdmin(p) && !isOwner)
            throw new ForbiddenException("No permission to modify this learning path");
    }

    /** Tính % hoàn thành từng course của user trong path */
    private Map<UUID, Integer> buildCourseProgressMap(UUID userId, LearningPath lp) {
        Map<UUID, Integer> map = new HashMap<>();
        Subscription.Plan plan = getPlan(userId);
        for (LearningPathStep step : lp.getSteps()) {
            Course c = step.getCourse();
            int pct = calcAccessibleCourseProgressPercent(userId, c, plan);
            map.put(c.getId(), pct);
        }
        return map;
    }

    /** % hoàn thành toàn bộ path = trung bình % của từng course */
    private int calcPathProgress(Map<UUID, Integer> courseProgress, LearningPath lp) {
        if (lp.getSteps().isEmpty() || courseProgress.isEmpty()) return 0;
        int total = lp.getSteps().stream()
                .mapToInt(s -> courseProgress.getOrDefault(s.getCourse().getId(), 0))
                .sum();
        return total / lp.getSteps().size();
    }

    private List<LearningPathStep> buildSteps(
            List<LearningPathRequest.StepItem> items, LearningPath lp) {
        List<LearningPathStep> steps = new ArrayList<>();
        for (int i = 0; i < items.size(); i++) {
            var item = items.get(i);
            Course c = courseRepo.findById(item.getCourseId())
                    .orElseThrow(() -> new NotFoundException("Course not found: " + item.getCourseId()));
            steps.add(LearningPathStep.builder()
                    .learningPath(lp)
                    .course(c)
                    .stepOrder(i + 1)
                    .note(item.getNote())
                    .isRequired(Boolean.TRUE.equals(item.getIsRequired()))
                    .build());
        }
        return steps;
    }

    private List<LearningPathResponse.StepResponse> buildStepResponses(
            LearningPath lp,
            Map<UUID, Integer> courseProgress,
            UserLearningPath userPath) {

        List<LearningPathStep> steps = lp.getSteps();
        List<LearningPathResponse.StepResponse> result = new ArrayList<>();

        Subscription.Plan plan = (userPath != null) ? getPlan(userPath.getUser().getId()) : null;

        for (int i = 0; i < steps.size(); i++) {
            LearningPathStep step = steps.get(i);
            Course c = step.getCourse();
            int pct = courseProgress.getOrDefault(c.getId(), 0);

            // Bước unlock nếu: bước 1 luôn unlock, hoặc bước trước đã complete (100%)
            boolean isUnlocked = i == 0
                    || !steps.get(i - 1).getIsRequired()
                    || courseProgress.getOrDefault(steps.get(i - 1).getCourse().getId(), 0) == 100;

            boolean canAccess;
            String requiredPlan;
            if (plan == null || plan == Subscription.Plan.FREE) {
                long previewCount = lessonRepo.countAccessible(c.getId(), List.of(Lesson.AccessTier.PREVIEW));
                canAccess = previewCount > 0;
                requiredPlan = canAccess ? null : "MONTHLY";
            } else if (plan == Subscription.Plan.MONTHLY) {
                long monthlyCount = lessonRepo.countAccessible(c.getId(), List.of(Lesson.AccessTier.PREVIEW, Lesson.AccessTier.MONTHLY));
                canAccess = monthlyCount > 0;
                requiredPlan = canAccess ? null : "UNLIMITED";
            } else {
                canAccess = true; // THREE_MONTHS / YEARLY
                requiredPlan = null;
            }

            UUID userId = userPath != null ? userPath.getUser().getId() : null;
            int doneLessons = userId != null
                    ? (int) progressRepo.countCompleted(userId, c.getId(), ProgressStatus.COMPLETED)
                    : 0;

            result.add(LearningPathResponse.StepResponse.builder()
                    .stepId(step.getId())
                    .stepOrder(step.getStepOrder())
                    .courseId(c.getId())
                    .courseTitle(c.getTitle())
                    .courseLevel(c.getLevel().name())
                    .totalLessons(c.getTotalLessons())
                    .note(step.getNote())
                    .isRequired(step.getIsRequired())
                    .courseProgressPercent(pct)
                    .completedLessons(doneLessons)
                    .isUnlocked(isUnlocked)
                    .canAccess(canAccess)
                    .requiredPlan(requiredPlan)
                    .build());
        }
        return result;
    }

    private LearningPathResponse toSummaryResponse(LearningPath lp, UserPrincipal p) {
        UserLearningPath userPath = (p != null)
                ? userPathRepo.findByUserIdAndLearningPathId(p.getUserId(), lp.getId()).orElse(null)
                : null;
        Map<UUID, Integer> cp = (p != null) ? buildCourseProgressMap(p.getUserId(), lp) : Collections.emptyMap();

        return LearningPathResponse.builder()
                .id(lp.getId())
                .title(lp.getTitle())
                .description(lp.getDescription())
                .languageCode(lp.getLanguage().getCode())
                .languageName(lp.getLanguage().getName())
                .targetLevel(lp.getTargetLevel())
                .goal(lp.getGoal())
                .estimatedHours(lp.getEstimatedHours())
                .isPublished(lp.getIsPublished())
                .isOfficial(lp.getIsOfficial())
                .totalSteps(lp.getSteps().size())
                .totalCourses(lp.getSteps().size())
                .createdAt(lp.getCreatedAt())
                .progressPercent(p != null ? calcPathProgress(cp, lp) : null)
                .enrollStatus(userPath != null ? userPath.getStatus().name() : null)
                .build();
    }

    private LearningPathResponse toDetailResponse(LearningPath lp, UserLearningPath userPath,
                                                  Map<UUID, Integer> cp) {
        List<LearningPathResponse.StepResponse> steps = buildStepResponses(lp, cp, userPath);
        return LearningPathResponse.builder()
                .id(lp.getId()).title(lp.getTitle()).description(lp.getDescription())
                .languageCode(lp.getLanguage().getCode()).languageName(lp.getLanguage().getName())
                .targetLevel(lp.getTargetLevel()).goal(lp.getGoal())
                .estimatedHours(lp.getEstimatedHours())
                .isPublished(lp.getIsPublished()).isOfficial(lp.getIsOfficial())
                .totalSteps(lp.getSteps().size())
                .totalCourses(lp.getSteps().size())
                .createdByName(lp.getCreatedBy() != null ? lp.getCreatedBy().getFullName() : "LinguaNext")
                .createdAt(lp.getCreatedAt()).steps(steps).build();
    }

    private int levelRank(UserOnboarding.SelfLevel level) {
        return switch (level) {
            case COMPLETE_BEGINNER -> 0;
            case BEGINNER          -> 1;
            case INTERMEDIATE      -> 2;
            case ADVANCED          -> 3;
        };
    }

    private int pathLevelRank(LearningPath.TargetLevel level) {
        return switch (level) {
            case BEGINNER     -> 1;
            case INTERMEDIATE -> 2;
            case ADVANCED     -> 3;
        };
    }
}
