package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.ai.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.ai.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;


// ╔══════════════════════════════════════════════════════════╗
// ║  1. AI Chat Teacher                                      ║
// ╚══════════════════════════════════════════════════════════╝
@Tag(name = "10 · AI Features")
@RestController
@RequestMapping("/api/v1/ai/chat")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
class AiChatController {

    private final AiChatService service;

    /**
     * Chat với AI gia sư.
     * Lịch sử hội thoại được khôi phục từ DB theo lessonId + userId.
     *
     * Free: 20/ngày | Monthly: 100/ngày | Unlimited: 200/ngày
     */
    @Operation(summary = "Chat với AI gia sư")
    @PostMapping
    public ResponseEntity<AiChatResponse> chat(
            @Valid @RequestBody AiChatRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.chat(req, p));
    }
}


// ╔══════════════════════════════════════════════════════════╗
// ║  2. Grammar Check                                        ║
// ╚══════════════════════════════════════════════════════════╝
@Tag(name = "10 · AI Features")
@RestController
@RequestMapping("/api/v1/ai/grammar")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
class GrammarController {

    private final GrammarService service;

    /**
     * Kiểm tra ngữ pháp và trả về lỗi chi tiết + gợi ý sửa.
     *
     * Free: 10/ngày | Monthly: 50/ngày | Unlimited: 100/ngày
     */
    @Operation(summary = "Kiểm tra ngữ pháp")
    @PostMapping("/check")
    public ResponseEntity<GrammarCheckResponse> check(
            @Valid @RequestBody GrammarCheckRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.checkGrammar(req, p));
    }
}


// ╔══════════════════════════════════════════════════════════╗
// ║  3. Pronunciation                                        ║
// ╚══════════════════════════════════════════════════════════╝
@Tag(name = "10 · AI Features")
@RestController
@RequestMapping("/api/v1/ai/pronunciation")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
class PronunciationController {

    private final PronunciationService service;

    /**
     * Phân tích phát âm.
     * Client tự gọi Whisper/Web Speech API trước, gửi recognizedText lên đây.
     *
     * Free: 5/ngày | Monthly: 20/ngày | Unlimited: 50/ngày
     */
    @Operation(summary = "Phân tích phát âm")
    @PostMapping("/analyze")
    public ResponseEntity<PronunciationResponse> analyze(
            @Valid @RequestBody PronunciationRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.analyzePronunciation(req, p));
    }
}


// ╔══════════════════════════════════════════════════════════╗
// ║  4. Vocabulary                                           ║
// ╚══════════════════════════════════════════════════════════╝
@Tag(name = "10 · AI Features")
@RestController
@RequestMapping("/api/v1/ai/vocab")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
class VocabController {

    private final VocabService service;

    /**
     * Tạo dữ liệu từ vựng đầy đủ: định nghĩa, ví dụ, collocations, mẹo ghi nhớ.
     *
     * Free: 10/ngày | Monthly: 50/ngày | Unlimited: 100/ngày
     */
    @Operation(summary = "Tạo dữ liệu từ vựng")
    @PostMapping("/generate")
    public ResponseEntity<?> generate(
            @Valid @RequestBody VocabRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.generateWordData(req, p));
    }

    /** Tạo câu hỏi game từ vựng (không tốn quota riêng) */
    @Operation(summary = "Tạo câu hỏi game từ vựng")
    @PostMapping("/game")
    public ResponseEntity<?> game(
            @Valid @RequestBody VocabGameRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.generateGameQuestion(req, p));
    }
}


// ╔══════════════════════════════════════════════════════════╗
// ║  5. Recommendation                                       ║
// ╚══════════════════════════════════════════════════════════╝
@Tag(name = "10 · AI Features")
@RestController
@RequestMapping("/api/v1/ai/recommend")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
class RecommendController {

    private final RecommendService service;

    /**
     * Gợi ý bài học tiếp theo dựa trên dữ liệu học của user.
     *
     * Free: 3/ngày | Monthly: 10/ngày | Unlimited: 20/ngày
     */
    @Operation(summary = "Gợi ý bài học phù hợp")
    @PostMapping
    public ResponseEntity<?> recommend(
            @RequestBody RecommendRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.recommend(req, p));
    }
}