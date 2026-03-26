package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.user.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@Tag(name = "01 · Users & Auth")
@RestController
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // ── AUTH endpoints (public) ───────────────────────────────

    @Operation(summary = "Đăng ký tài khoản")
    @PostMapping("/api/v1/auth/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.register(req));
    }

    @Operation(summary = "Đăng nhập")
    @PostMapping("/api/v1/auth/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest req) {
        return ResponseEntity.ok(userService.login(req));
    }


    // JWT refresh token (currently disabled)

    @Operation(summary = "Làm mới access token bằng refresh token")
    @PostMapping("/api/v1/auth/refresh")
    public ResponseEntity<AuthResponse> refresh(@RequestParam String refreshToken) {
        return ResponseEntity.ok(userService.refresh(refreshToken));
    }

    // Logout requires JWT authentication

    @Operation(summary = "Đăng xuất — thu hồi refresh token")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/api/v1/auth/logout")
    public ResponseEntity<Void> logout(@AuthenticationPrincipal UserPrincipal p) {
        userService.logout(p.getUserId());
        return ResponseEntity.noContent().build();
    }


    /*
    // Email OTP verification (currently disabled)

    @Operation(summary = "Xác thực email bằng OTP 6 chữ số")
    @PostMapping("/api/v1/auth/verify-email")
    public ResponseEntity<Map<String,String>> verifyEmail(
            @RequestParam String email, @RequestParam String otp) {
        userService.verifyEmail(email, otp);
        return ResponseEntity.ok(Map.of("message", "Email verified"));
    }

    @Operation(summary = "Gửi OTP reset mật khẩu qua email")
    @PostMapping("/api/v1/auth/forgot-password")
    public ResponseEntity<Map<String,String>> forgotPassword(@RequestParam String email) {
        userService.forgotPassword(email);
        return ResponseEntity.ok(Map.of("message", "If email exists, OTP has been sent"));
    }

    @Operation(summary = "Đặt lại mật khẩu với OTP")
    @PostMapping("/api/v1/auth/reset-password")
    public ResponseEntity<Map<String,String>> resetPassword(
            @RequestParam String token,
            @RequestParam @jakarta.validation.constraints.Size(min=8) String newPassword) {
        userService.resetPassword(token, newPassword);
        return ResponseEntity.ok(Map.of("message", "Password reset successfully"));
    }
    */

    // ── USER profile endpoints (authenticated) ────────────────
    // NOTE: Requires JWT authentication when security is enabled

    @Operation(summary = "Lấy profile của chính mình")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/api/v1/users/me")
    public ResponseEntity<UserProfileResponse> getProfile(@AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(userService.getProfile(p));
    }

    @Operation(summary = "Cập nhật tên, avatar")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PutMapping("/api/v1/users/me")
    public ResponseEntity<UserProfileResponse> updateProfile(
            @Valid @RequestBody UpdateProfileRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(userService.updateProfile(req, p));
    }

    @Operation(summary = "Đổi mật khẩu")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PatchMapping("/api/v1/users/me/password")
    public ResponseEntity<Map<String,String>> changePassword(
            @Valid @RequestBody ChangePasswordRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        userService.changePassword(req, p);
        return ResponseEntity.ok(Map.of("message", "Password changed"));
    }
}
