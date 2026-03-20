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
import java.util.UUID;

@Tag(name = "04 · Lessons")
@RestController
@RequestMapping("/api/v1/courses/{courseId}/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final LessonService service;

    @Operation(summary = "Chi tiết bài học + nội dung (free hoặc Premium)")
    @SecurityRequirement(name = "bearerAuth")
    @GetMapping("/{lessonId}")
    public ResponseEntity<LessonDetailResponse> getDetail(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getDetail(courseId, lessonId, p));
    }

    @Operation(summary = "Tạo bài học mới — Teacher / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @PostMapping
    public ResponseEntity<LessonDetailResponse> create(
            @PathVariable UUID courseId, @Valid @RequestBody LessonRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(courseId, req, p));
    }

    @Operation(summary = "Cập nhật bài học — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @PutMapping("/{lessonId}")
    public ResponseEntity<LessonDetailResponse> update(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @Valid @RequestBody LessonRequest req, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.update(courseId, lessonId, req, p));
    }

    @Operation(summary = "Xoá bài học — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @DeleteMapping("/{lessonId}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID courseId, @PathVariable UUID lessonId,
            @AuthenticationPrincipal UserPrincipal p) {
        service.delete(courseId, lessonId, p);
        return ResponseEntity.noContent().build();
    }
}
