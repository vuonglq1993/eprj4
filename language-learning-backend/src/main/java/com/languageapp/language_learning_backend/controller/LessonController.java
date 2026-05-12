package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.lesson.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.LessonService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@Tag(name = "04 · Lessons")
@RestController
@RequestMapping("/api/v1/courses/{courseId}/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final LessonService service;

    // ✅ NEW API (QUAN TRỌNG NHẤT)
    @Operation(summary = "Danh sách bài học theo khoá học")
    @SecurityRequirement(name = "bearerAuth")
    @GetMapping
    public ResponseEntity<List<LessonDetailResponse>> getLessons(
            @PathVariable UUID courseId,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getLessons(courseId, p));
    }

    @Operation(summary = "Chi tiết bài học + nội dung (free hoặc Premium)")
    @SecurityRequirement(name = "bearerAuth")
    @GetMapping("/{lessonId}")
    public ResponseEntity<LessonDetailResponse> getDetail(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getDetail(courseId, lessonId, p));
    }

    @Operation(summary = "Tạo bài học mới — Admin")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<LessonDetailResponse> create(
            @PathVariable UUID courseId, @Valid @RequestBody LessonRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(courseId, req, p));
    }

    @Operation(summary = "Cập nhật bài học — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{lessonId}")
    public ResponseEntity<LessonDetailResponse> update(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @Valid @RequestBody LessonRequest req, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.update(courseId, lessonId, req, p));
    }

    @Operation(summary = "Xoá bài học — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{lessonId}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @AuthenticationPrincipal UserPrincipal p) {
        service.delete(courseId, lessonId, p);
        return ResponseEntity.noContent().build();
    }
}