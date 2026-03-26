package com.languageapp.language_learning_backend.controller;
import com.languageapp.language_learning_backend.dto.language.*;
import com.languageapp.language_learning_backend.service.LanguageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@Tag(name = "02 · Languages")
@RestController
@RequestMapping("/api/v1/languages")
@RequiredArgsConstructor
public class LanguageController {

    private final LanguageService service;

    @Operation(summary = "Danh sách ngôn ngữ đang hoạt động (public)")
    @GetMapping
    public ResponseEntity<List<LanguageResponse>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @Operation(summary = "Chi tiết ngôn ngữ (public)")
    @GetMapping("/{id}")
    public ResponseEntity<LanguageResponse> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(service.getById(id));
    }

    @Operation(summary = "Thêm ngôn ngữ mới — Admin only")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<LanguageResponse> create(@Valid @RequestBody LanguageRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req));
    }

    @Operation(summary = "Cập nhật ngôn ngữ — Admin only")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<LanguageResponse> update(
            @PathVariable UUID id, @Valid @RequestBody LanguageRequest req) {
        return ResponseEntity.ok(service.update(id, req));
    }

    @Operation(summary = "Xoá ngôn ngữ (chỉ khi không có course) — Admin only")
    @SecurityRequirement(name = "bearerAuth") @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
