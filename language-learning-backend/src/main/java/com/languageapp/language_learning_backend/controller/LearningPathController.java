package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.course.PageResponse;
import com.languageapp.language_learning_backend.dto.learningpath.*;
import com.languageapp.language_learning_backend.entity.LearningPath.TargetLevel;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.LearningPathService;
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

@Tag(name = "12 · Learning Paths")
@RestController
@RequestMapping("/api/v1/learning-paths")
@RequiredArgsConstructor
public class LearningPathController {

    private final LearningPathService service;

    // ── PUBLIC ────────────────────────────────────────────────

    @Operation(summary = "Danh sách lộ trình học (filter ngôn ngữ / level / keyword)")
    @GetMapping
    public ResponseEntity<PageResponse<LearningPathResponse>> getPublished(
            @RequestParam(required = false) UUID        languageId,
            @RequestParam(required = false) TargetLevel level,
            @RequestParam(required = false) String      kw,
            @RequestParam(defaultValue = "0")  int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getPublished(languageId, level, kw, page, size, p));
    }

    @Operation(summary = "Chi tiết lộ trình + các bước khoá học")
    @GetMapping("/{id}")
    public ResponseEntity<LearningPathResponse> getDetail(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getDetail(id, p));
    }

    // ── AUTHENTICATED ─────────────────────────────────────────

    @Operation(summary = "Đăng ký theo dõi lộ trình học")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("isAuthenticated()")
    @PostMapping("/{id}/enroll")
    public ResponseEntity<Map<String, Object>> enroll(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.enroll(id, p));
    }

    @Operation(summary = "Huỷ đăng ký lộ trình học")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/{id}/enroll")
    public ResponseEntity<Void> unenroll(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal p) {
        service.unenroll(id, p);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Lộ trình đang theo dõi của tôi")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("isAuthenticated()")
    @GetMapping("/my")
    public ResponseEntity<List<LearningPathResponse>> getMyPaths(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getMyPaths(p));
    }

    // ── ADMIN / TEACHER ───────────────────────────────────────

    @Operation(summary = "Tạo lộ trình mới — Teacher / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @PostMapping
    public ResponseEntity<LearningPathResponse> create(
            @Valid @RequestBody LearningPathRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req, p));
    }

    @Operation(summary = "Cập nhật lộ trình — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @PutMapping("/{id}")
    public ResponseEntity<LearningPathResponse> update(
            @PathVariable UUID id, @Valid @RequestBody LearningPathRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.update(id, req, p));
    }

    @Operation(summary = "Publish / Unpublish lộ trình")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @PatchMapping("/{id}/publish")
    public ResponseEntity<LearningPathResponse> togglePublish(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.togglePublish(id, p));
    }

    @Operation(summary = "Xoá lộ trình — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal p) {
        service.delete(id, p);
        return ResponseEntity.noContent().build();
    }
}
