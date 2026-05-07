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

import java.util.List;
import java.util.Map;

@Tag(name = "01 · Users & Auth")
@RestController
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // ── AUTH (public) ─────────────────────────────────────────

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

    @Operation(summary = "Đăng xuất")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/api/v1/auth/logout")
    public ResponseEntity<Map<String, String>> logout(@AuthenticationPrincipal UserPrincipal p) {
        userService.logout(p.getUserId());
        return ResponseEntity.ok(Map.of("message", "Logged out successfully"));
    }

    // ── USER PROFILE (authenticated) ─────────────────────────

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
    public ResponseEntity<Map<String, String>> changePassword(
            @Valid @RequestBody ChangePasswordRequest req,
            @AuthenticationPrincipal UserPrincipal p) {
        userService.changePassword(req, p);
        return ResponseEntity.ok(Map.of("message", "Password changed"));
    }

    // ── ADMIN: SEARCH USERS ──────────────────────────────────
    @Operation(summary = "Tìm kiếm user theo email (Admin)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/api/v1/users/search")
    public ResponseEntity<List<UserService.UserSearchResult>> searchUsers(
            @RequestParam String q) {
        return ResponseEntity.ok(userService.searchUsers(q));
    }
}