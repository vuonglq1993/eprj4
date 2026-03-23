package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.progress.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.ProgressService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@Tag(name = "06 · Progress")
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class ProgressController {

    private final ProgressService service;

    @Operation(summary = "Dashboard tổng quan học tập (cached 3 phút)")
    @GetMapping("/dashboard")
    public ResponseEntity<DashboardResponse> getDashboard(@AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getDashboard(p));
    }

    @Operation(summary = "Chi tiết tiến độ từng bài trong khoá học")
    @GetMapping("/progress/courses/{courseId}")
    public ResponseEntity<List<ProgressResponse>> getCourseProgress(
            @PathVariable UUID courseId, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getCourseProgress(courseId, p));
    }

    @Operation(summary = "Thống kê học tập theo period: WEEK / MONTH / YEAR")
    @GetMapping("/progress/stats")
    public ResponseEntity<StatsResponse> getStats(
            @RequestParam(defaultValue = "WEEK") String period,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getStats(period, p));
    }

    @Operation(summary = "Lấy chứng chỉ hoàn thành khoá học (yêu cầu 100%)")
    @GetMapping("/progress/courses/{courseId}/certificate")
    public ResponseEntity<CertificateResponse> getCertificate(
            @PathVariable UUID courseId, @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getCertificate(courseId, p));
    }
}
