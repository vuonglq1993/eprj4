package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.exercise.*;
import com.languageapp.language_learning_backend.entity.User;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.ExerciseService;
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

@Tag(name = "05 · Exercises")
@RestController
@RequestMapping("/api/v1/courses/{courseId}/lessons/{lessonId}/exercises")
@RequiredArgsConstructor
public class ExerciseController {

    private final ExerciseService service;

    @Operation(summary = "Danh sách bài tập trong bài học")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @GetMapping
    public ResponseEntity<List<ExerciseResponse>> list(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @RequestParam(defaultValue = "vi") String lang,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.list(courseId, lessonId, lang, p));
    }

    @Operation(summary = "Thêm bài tập — Admin")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<ExerciseResponse> create(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @Valid @RequestBody ExerciseRequest req, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(courseId, lessonId, req, p));
    }

    @Operation(summary = "Cập nhật bài tập — Admin")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{exerciseId}")
    public ResponseEntity<ExerciseResponse> update(
            @PathVariable UUID courseId, @PathVariable UUID lessonId, @PathVariable UUID exerciseId,
            @Valid @RequestBody ExerciseRequest req, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.update(courseId, lessonId, exerciseId, req, p));
    }

    @Operation(summary = "Xoá bài tập — Admin")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{exerciseId}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID courseId, @PathVariable UUID lessonId, @PathVariable UUID exerciseId,
            @AuthenticationPrincipal UserPrincipal p) {
        service.delete(courseId, lessonId, exerciseId, p);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Nộp bài tập — tự động chấm điểm và lưu vào user_progress")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/submit")
    public ResponseEntity<SubmitResponse> submit(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @Valid @RequestBody SubmitRequest req, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.submit(courseId, lessonId, req, p));
    }
}