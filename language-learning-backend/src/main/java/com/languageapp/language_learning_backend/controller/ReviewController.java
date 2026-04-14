package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.review.MistakeResponse;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "15 · Review Mistakes")
@RestController
@RequestMapping("/api/v1/review")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class ReviewController {

    private final ReviewService service;

    @Operation(
            summary = "Danh sách bài tập đã làm sai",
            description = "Trả về các bài user làm sai + đáp án + giải thích"
    )
    @GetMapping("/mistakes")
    public ResponseEntity<List<MistakeResponse>> getMistakes(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal UserPrincipal p
    ) {
        return ResponseEntity.ok(service.getMistakes(p, page, size));
    }
}