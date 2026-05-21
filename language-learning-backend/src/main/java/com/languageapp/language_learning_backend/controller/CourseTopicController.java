package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.topic.TopicResponse;
import com.languageapp.language_learning_backend.entity.Course;
import com.languageapp.language_learning_backend.entity.Topic;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.CourseRepository;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.CourseService;
import com.languageapp.language_learning_backend.service.TopicService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Tag(name = "11 · Topics")
@RestController
@RequestMapping("/api/v1/courses/{courseId}/topics")
@RequiredArgsConstructor
public class CourseTopicController {

    private final CourseService    courseService;
    private final TopicService     topicService;
    private final CourseRepository courseRepo;

    @Operation(summary = "Danh sách topic của khoá học")
    @GetMapping
    public ResponseEntity<List<TopicResponse>> getTopics(@PathVariable UUID courseId) {
        Course c = courseService.findOrThrow(courseId);
        List<TopicResponse> topics = c.getTopics().stream()
                .map(t -> TopicResponse.builder()
                        .id(t.getId()).name(t.getName()).description(t.getDescription())
                        .iconUrl(t.getIconUrl()).isActive(t.getIsActive())
                        .orderIndex(t.getOrderIndex()).build())
                .collect(Collectors.toList());
        return ResponseEntity.ok(topics);
    }

    @Operation(summary = "Gán topic cho khoá học — Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{topicId}")
    public ResponseEntity<Void> addTopic(
            @PathVariable UUID courseId, @PathVariable UUID topicId,
            @AuthenticationPrincipal UserPrincipal p) {
        Course c = courseService.findOrThrow(courseId);
        courseService.checkOwnerOrAdmin(p, c);
        Topic  t = topicService.findOrThrow(topicId);
        if (!c.getTopics().contains(t)) {
            c.getTopics().add(t);
            courseRepo.save(c);
        }
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Bỏ topic khỏi khoá học — Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{topicId}")
    public ResponseEntity<Void> removeTopic(
            @PathVariable UUID courseId, @PathVariable UUID topicId,
            @AuthenticationPrincipal UserPrincipal p) {
        Course c = courseService.findOrThrow(courseId);
        courseService.checkOwnerOrAdmin(p, c);
        c.getTopics().removeIf(t -> t.getId().equals(topicId));
        courseRepo.save(c);
        return ResponseEntity.noContent().build();
    }

}
