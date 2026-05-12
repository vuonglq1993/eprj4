package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.course.*;
import com.languageapp.language_learning_backend.entity.Course.Level;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.CourseService;
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

@Tag(name = "03 · Courses")
@RestController
@RequestMapping("/api/v1/courses")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService service;

    @Operation(summary = "Danh sách khoá học (filter ngôn ngữ / level / keyword)")
    @GetMapping
    public ResponseEntity<PageResponse<CourseResponse>> getPublished(
            @RequestParam(required=false) UUID   languageId,
            @RequestParam(required=false) Level  level,
            @RequestParam(required=false) String kw,
            @RequestParam(defaultValue="0")  int page,
            @RequestParam(defaultValue="12") int size,
            @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.getPublished(languageId, level, kw, page, size, principal));
    }

    @Operation(summary = "Chi tiết khoá học + outline bài học")
    @GetMapping("/{id}")
    public ResponseEntity<CourseDetailResponse> getDetail(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.getDetail(id, principal));
    }

    @Operation(summary = "Tạo khoá học — Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<CourseResponse> create(
            @Valid @RequestBody CourseRequest req, @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req, principal));
    }

    @Operation(summary = "Cập nhật khoá học — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<CourseResponse> update(
            @PathVariable UUID id, @Valid @RequestBody CourseRequest req,
            @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.update(id, req, principal));
    }

    @Operation(summary = "Publish / Unpublish khoá học")
    @SecurityRequirement(name = "bearerAuth")@PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/publish")
    public ResponseEntity<CourseResponse> togglePublish(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        return ResponseEntity.ok(service.togglePublish(id, principal));
    }

    @Operation(summary = "Xoá khoá học — chủ sở hữu / Admin")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID id, @AuthenticationPrincipal UserPrincipal principal) {
        service.delete(id, principal);
        return ResponseEntity.noContent().build();
    }
}
