package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.studylog.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.StudyLogService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "07 · Study Logs & Streak")
@RestController
@RequestMapping("/api/v1/study-logs")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class StudyLogController {

    private final StudyLogService service;

    @Operation(summary = "Ghi nhận phiên học — frontend gọi sau mỗi bài / bài tập")
    @PostMapping
    public ResponseEntity<Void> log(
            @Valid @RequestBody LogStudyRequest req, @AuthenticationPrincipal UserPrincipal p) {
        service.log(req, p);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Streak hiện tại + lịch sử 30 ngày gần nhất")
    @GetMapping("/streak")
    public ResponseEntity<StreakResponse> getStreak(@AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getStreak(p));
    }

    @Operation(summary = "Lấy danh sách học theo tuần (group by date)")
    @GetMapping("/weekly")
    public ResponseEntity<?> getWeeklyLogs(@AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getWeeklyLogs(p));
    }
}
