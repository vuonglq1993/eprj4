package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.auth.GoogleAuthRequest;
import com.languageapp.language_learning_backend.dto.user.AuthResponse;
import com.languageapp.language_learning_backend.service.GoogleAuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "01 · Users & Auth")
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class GoogleAuthController {

    private final GoogleAuthService googleAuthService;

    @Operation(
            summary = "Đăng nhập bằng Google — nhận idToken từ Android hoặc Web Admin",
            description = """
            **Android:** Dùng Google Sign-In SDK lấy idToken rồi gửi lên đây.
            
            **Web Admin:** Dùng Google Identity Services lấy idToken rồi gửi lên đây.
            
            Backend sẽ verify idToken với Google, tìm hoặc tạo tài khoản,
            rồi trả về accessToken + refreshToken như đăng nhập thường.
            """
    )
    @PostMapping("/google")
    public ResponseEntity<AuthResponse> loginWithGoogle(
            @Valid @RequestBody GoogleAuthRequest req) {
        return ResponseEntity.ok(googleAuthService.loginWithGoogle(req));
    }
}
