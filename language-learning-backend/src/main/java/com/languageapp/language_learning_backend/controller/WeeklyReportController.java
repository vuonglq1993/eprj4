package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.report.WeeklyReportResponse;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.WeeklyReportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "16 · Reports")
@RestController
@RequestMapping("/api/v1/reports")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class WeeklyReportController {

    private final WeeklyReportService service;

    @Operation(
            summary = "Báo cáo học tập tuần này",
            description = "Tổng hợp: thời gian học, bài hoàn thành, " +
                    "điểm TB, streak, XP, so sánh với tuần trước."
    )
    @GetMapping("/weekly")
    public ResponseEntity<WeeklyReportResponse> getWeekly(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getReport(p));
    }
}