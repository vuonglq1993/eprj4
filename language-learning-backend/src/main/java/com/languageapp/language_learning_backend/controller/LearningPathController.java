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
            @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.getPublished(languageId, level, kw, page, size, principal));
    }

    // ── ADMIN ────────────────────────────────────────────────

    @Operation(summary = "Danh sách tất cả lộ trình cho Admin (bao gồm unpublished)")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin/all")
    public ResponseEntity<PageResponse<LearningPathResponse>> getAllForAdmin(
            @RequestParam(required = false) UUID        languageId,
            @RequestParam(required = false) TargetLevel level,
            @RequestParam(required = false) String      kw,
            @RequestParam(defaultValue = "0")  int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(service.getAllForAdmin(languageId, level, kw, page, size));
    }

    @Operation(summary = "Chi tiết lộ trình + các bước khoá học")
    @GetMapping("/{id}")
    public ResponseEntity<LearningPathResponse> getDetail(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.getDetail(id, principal));
    }

    // ── AUTHENTICATED ─────────────────────────────────────────

    @Operation(summary = "Đăng ký theo dõi lộ trình học")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("isAuthenticated()")
    @PostMapping("/{id}/enroll")
    public ResponseEntity<Map<String, Object>> enroll(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.enroll(id, principal));
    }

    @Operation(summary = "Huỷ đăng ký lộ trình học")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/{id}/enroll")
    public ResponseEntity<Void> unenroll(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        service.unenroll(id, principal);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Lộ trình đang theo dõi của tôi")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("isAuthenticated()")
    @GetMapping("/my")
    public ResponseEntity<List<LearningPathResponse>> getMyPaths(
            @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.getMyPaths(principal));
    }

    // ── ADMIN ───────────────────────────────────────

    @Operation(summary = "Tạo lộ trình mới — Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<LearningPathResponse> create(
            @Valid @RequestBody LearningPathRequest req,
            @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req, principal));
    }

    @Operation(summary = "Cập nhật lộ trình — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<LearningPathResponse> update(
            @PathVariable UUID id, @Valid @RequestBody LearningPathRequest req,
            @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.update(id, req, principal));
    }

    @Operation(summary = "Publish / Unpublish lộ trình")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/publish")
    public ResponseEntity<LearningPathResponse> togglePublish(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.togglePublish(id, principal));
    }

    @Operation(summary = "Xoá lộ trình — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        service.delete(id, principal);
        return ResponseEntity.noContent().build();
    }
}
