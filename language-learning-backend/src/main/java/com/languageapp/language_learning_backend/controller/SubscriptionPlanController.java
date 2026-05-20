package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.service.SubscriptionPlanService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Tag(name = "09 · Payments")
@RestController
@RequestMapping("/api/v1/subscription-plans")
@RequiredArgsConstructor
public class SubscriptionPlanController {

    private final SubscriptionPlanService service;

    @Operation(summary = "Danh sách gói subscription đang active (public)")
    @GetMapping
    public ResponseEntity<List<SubscriptionPlanResponse>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @Operation(summary = "Tạo gói mới — Admin only")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<SubscriptionPlanResponse> create(
            @Valid @RequestBody SubscriptionPlanRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(req));
    }

    @Operation(summary = "Cập nhật gói — Admin only")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<SubscriptionPlanResponse> update(
            @PathVariable UUID id, @Valid @RequestBody SubscriptionPlanRequest req) {
        return ResponseEntity.ok(service.update(id, req));
    }

    @Operation(summary = "Bật / tắt gói — Admin only")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/toggle")
    public ResponseEntity<SubscriptionPlanResponse> toggle(@PathVariable UUID id) {
        return ResponseEntity.ok(service.toggle(id));
    }

    @Operation(summary = "Xoá gói — Admin only")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
