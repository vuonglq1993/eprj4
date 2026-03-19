package com.languageapp.language_learning_backend.service;
import com.languageapp.language_learning_backend.dto.course.*;
import com.languageapp.language_learning_backend.dto.lesson.LessonSummaryResponse;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Course.Level;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseService {

    private final CourseRepository       courseRepo;
    private final LanguageRepository     languageRepo;
    private final UserRepository         userRepo;
    private final UserProgressRepository progressRepo;

    // ── LIST (public) ─────────────────────────────────────────
    @Transactional(readOnly = true)
    public PageResponse<CourseResponse> getPublished(UUID languageId, Level level,
                                                     String kw, int page, int size,
                                                     UserPrincipal p) {
        Page<Course> result = courseRepo.findPublished(languageId, level, kw,
                PageRequest.of(page, size, Sort.by("createdAt").descending()));
        return toPage(result, page, size, p);
    }

    // ── DETAIL ────────────────────────────────────────────────
    @Transactional(readOnly = true)
    public CourseDetailResponse getDetail(UUID id, UserPrincipal p) {
        Course c = findOrThrow(id);
        if (!c.getIsPublished() && !isAdminOrOwner(p, c))
            throw new ForbiddenException("Course not available");

        Map<UUID, String> progressMap = (p != null)
                ? progressRepo.findByUserIdAndCourseId(p.getUserId(), id)
                .stream().collect(Collectors.toMap(pr -> pr.getLesson().getId(), pr -> pr.getStatus().name()))
                : Collections.emptyMap();

        int pct = (p != null && c.getTotalLessons() > 0)
                ? progressRepo.calculateProgress(p.getUserId(), id, c.getTotalLessons()) : 0;

        return CourseDetailResponse.builder()
                .id(c.getId()).title(c.getTitle()).description(c.getDescription())
                .languageCode(c.getLanguage().getCode()).languageName(c.getLanguage().getName())
                .level(c.getLevel()).thumbnailUrl(c.getThumbnailUrl())
                .isPublished(c.getIsPublished()).totalLessons(c.getTotalLessons())
                .createdByName(c.getCreatedBy() != null ? c.getCreatedBy().getFullName() : null)
                .createdAt(c.getCreatedAt()).progressPercent(pct)
                .lessons(c.getLessons().stream()
                        .map(l -> LessonSummaryResponse.builder()
                                .id(l.getId()).title(l.getTitle()).type(l.getType())
                                .orderIndex(l.getOrderIndex()).durationMinutes(l.getDurationMinutes())
                                .isFree(l.getIsFree())
                                .progressStatus(progressMap.getOrDefault(l.getId(), "NOT_STARTED"))
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }

    // ── CREATE ────────────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "courses", allEntries = true)
    public CourseResponse create(CourseRequest req, UserPrincipal p) {
        Language lang = languageRepo.findById(req.getLanguageId())
                .orElseThrow(() -> new NotFoundException("Language not found"));
        return toCourseResponse(courseRepo.save(Course.builder()
                .language(lang).createdBy(userRepo.getReferenceById(p.getUserId()))
                .title(req.getTitle()).description(req.getDescription())
                .level(req.getLevel()).thumbnailUrl(req.getThumbnailUrl())
                .isPublished(Boolean.TRUE.equals(req.getIsPublished()))
                .totalLessons(0).build()), 0);
    }

    // ── UPDATE ────────────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "courses", allEntries = true)
    public CourseResponse update(UUID id, CourseRequest req, UserPrincipal p) {
        Course c = findOrThrow(id);
        checkOwnerOrAdmin(p, c);
        Language lang = languageRepo.findById(req.getLanguageId())
                .orElseThrow(() -> new NotFoundException("Language not found"));
        c.setTitle(req.getTitle()); c.setDescription(req.getDescription());
        c.setLanguage(lang); c.setLevel(req.getLevel()); c.setThumbnailUrl(req.getThumbnailUrl());
        if (req.getIsPublished() != null) c.setIsPublished(req.getIsPublished());
        return toCourseResponse(courseRepo.save(c), 0);
    }

    // ── TOGGLE PUBLISH ────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "courses", allEntries = true)
    public CourseResponse togglePublish(UUID id, UserPrincipal p) {
        Course c = findOrThrow(id);
        checkOwnerOrAdmin(p, c);
        if (!c.getIsPublished() && c.getTotalLessons() == 0)
            throw new BadRequestException("Cannot publish a course with no lessons");
        c.setIsPublished(!c.getIsPublished());
        return toCourseResponse(courseRepo.save(c), 0);
    }

    // ── DELETE ────────────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "courses", allEntries = true)
    public void delete(UUID id, UserPrincipal p) {
        Course c = findOrThrow(id);
        checkOwnerOrAdmin(p, c);
        courseRepo.delete(c);
    }

    // ── PUBLIC HELPERS (dùng bởi LessonService, ExerciseService) ─
    public Course findOrThrow(UUID id) {
        return courseRepo.findById(id).orElseThrow(() -> new NotFoundException("Course not found: " + id));
    }

    public boolean isAdminOrOwner(UserPrincipal p, Course c) {
        if (p == null) return false;
        return "ADMIN".equals(p.getRole())
                || (c.getCreatedBy() != null && c.getCreatedBy().getId().equals(p.getUserId()));
    }

    public void checkOwnerOrAdmin(UserPrincipal p, Course c) {
        if (!isAdminOrOwner(p, c)) throw new ForbiddenException("No permission to modify this course");
    }

    // ── PRIVATE MAPPERS ───────────────────────────────────────
    private PageResponse<CourseResponse> toPage(Page<Course> pg, int page, int size, UserPrincipal p) {
        return PageResponse.<CourseResponse>builder()
                .content(pg.getContent().stream().map(c -> {
                    int pct = (p != null && c.getTotalLessons() > 0)
                            ? progressRepo.calculateProgress(p.getUserId(), c.getId(), c.getTotalLessons()) : 0;
                    return toCourseResponse(c, pct);
                }).collect(Collectors.toList()))
                .page(page).size(size).totalElements(pg.getTotalElements())
                .totalPages(pg.getTotalPages()).last(pg.isLast()).build();
    }

    private CourseResponse toCourseResponse(Course c, int pct) {
        return CourseResponse.builder()
                .id(c.getId()).title(c.getTitle()).description(c.getDescription())
                .languageCode(c.getLanguage().getCode()).languageName(c.getLanguage().getName())
                .level(c.getLevel()).thumbnailUrl(c.getThumbnailUrl())
                .isPublished(c.getIsPublished()).totalLessons(c.getTotalLessons())
                .createdByName(c.getCreatedBy() != null ? c.getCreatedBy().getFullName() : null)
                .createdAt(c.getCreatedAt()).updatedAt(c.getUpdatedAt()).progressPercent(pct).build();
    }
}
