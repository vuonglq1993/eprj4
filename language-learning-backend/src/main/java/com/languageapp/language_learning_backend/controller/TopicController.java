package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.topic.*;
import com.languageapp.language_learning_backend.service.TopicService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import com.languageapp.language_learning_backend.dto.course.CourseResponse;
import com.languageapp.language_learning_backend.entity.Course;
import java.util.stream.Collectors;
import com.languageapp.language_learning_backend.entity.Topic;

@Tag(name = "11 · Topics")
@RestController
@RequestMapping("/api/v1/topics")
@RequiredArgsConstructor
public class TopicController {

    private final TopicService service;


    @Operation(summary = "Danh sách chủ đề (public)")
    @GetMapping
    public ResponseEntity<List<TopicResponse>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @Operation(summary = "Chi tiết chủ đề (public)")
    @GetMapping("/{id}")
    public ResponseEntity<TopicResponse> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(service.getById(id));
    }

    @Operation(summary = "Tạo chủ đề — Admin only")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<TopicResponse> create(@Valid @RequestBody TopicRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req));
    }

    @Operation(summary = "Cập nhật chủ đề — Admin only")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<TopicResponse> update(
            @PathVariable UUID id, @Valid @RequestBody TopicRequest req) {
        return ResponseEntity.ok(service.update(id, req));
    }

    @Operation(summary = "Xoá chủ đề (chỉ khi không có course) — Admin only")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
    @Operation(summary = "Danh sách course theo topic (public)")
    @GetMapping("/{topicId}/courses")
    public ResponseEntity<List<CourseResponse>> getCoursesByTopic(
            @PathVariable UUID topicId) {
        Topic t = service.findOrThrow(topicId);
        List<CourseResponse> courses = t.getCourses().stream()
                .filter(Course::getIsPublished)
                .map(c -> CourseResponse.builder()
                        .id(c.getId())
                        .title(c.getTitle())
                        .description(c.getDescription())
                        .languageCode(c.getLanguage().getCode())
                        .languageName(c.getLanguage().getName())
                        .level(c.getLevel())
                        .thumbnailUrl(c.getThumbnailUrl())
                        .isPublished(c.getIsPublished())
                        .totalLessons(c.getTotalLessons())
                        .build())
                .collect(Collectors.toList());
        return ResponseEntity.ok(courses);
    }

}
