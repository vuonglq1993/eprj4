package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.onboarding.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.OnboardingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@Tag(name = "01 · Users & Auth")
@RestController
@RequestMapping("/api/v1/onboarding")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class OnboardingController {

    private final OnboardingService service;

    @Operation(
            summary = "Kiểm tra trạng thái onboarding",
            description = "Flutter gọi sau khi login để biết user đã setup chưa. " +
                    "Nếu `onboardingCompleted = false` → redirect sang màn onboarding."
    )
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getStatus(@AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getStatus(p));
    }

    @Operation(
            summary = "Submit kết quả onboarding",
            description = """
            Gọi sau khi user hoàn thành toàn bộ flow câu hỏi trong Flutter.
            Backend sẽ:
            1. Lưu thông tin onboarding
            2. Tự động gợi ý Learning Path phù hợp nhất
            3. Auto-enroll vào path được gợi ý
            4. Trả về path gợi ý kèm message động viên
            """
    )
    @PostMapping
    public ResponseEntity<OnboardingResponse> submit(
            @Valid @RequestBody OnboardingRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.submit(req, p));
    }

    @Operation(summary = "Lấy thông tin onboarding đã lưu của tôi")
    @GetMapping("/me")
    public ResponseEntity<OnboardingResponse> getMyOnboarding(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getMyOnboarding(p));
    }
}
