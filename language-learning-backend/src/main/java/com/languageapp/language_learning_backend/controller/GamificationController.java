package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.gamification.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.GamificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Tag(name = "13 · Gamification")
@RestController
@RequestMapping("/api/v1/game")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class GamificationController {

    private final GamificationService service;

    @Operation(summary = "Profile game của tôi (XP, Level, Badges)")
    @GetMapping("/profile")
    public ResponseEntity<GameProfileResponse> getProfile(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getProfile(p));
    }

    @Operation(summary = "Bảng xếp hạng (Weekly + All Time)")
    @GetMapping("/leaderboard")
    public ResponseEntity<LeaderboardResponse> getLeaderboard(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getLeaderboard(p));
    }

    @Operation(summary = "Danh sách câu sai gần nhất")
    @GetMapping("/mistakes")
    public ResponseEntity<List<MistakeResponse>> getMistakes(
            @AuthenticationPrincipal UserPrincipal p,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(service.getMistakes(p, size));
    }

    @Operation(summary = "AI phân tích điểm yếu dựa trên câu sai")
    @PostMapping("/mistakes/ai-review")
    public ResponseEntity<Map<String, String>> getAiReview(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(Map.of("review", service.getAiReview(p)));
    }
}
