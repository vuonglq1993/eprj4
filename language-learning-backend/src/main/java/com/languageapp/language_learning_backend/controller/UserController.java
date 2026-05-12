package com.languageapp.language_learning_backend.controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.languageapp.language_learning_backend.dto.user.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Tag(name = "01 · Users & Auth")
@RestController
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final Cloudinary  cloudinary;

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

    @Operation(summary = "Upload avatar")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PostMapping(value = "/api/v1/users/me/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, String>> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal UserPrincipal p) {
        try {
            @SuppressWarnings("rawtypes")
            Map result = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap("folder", "avatars", "resource_type", "image")
            );
            String url = (String) result.get("secure_url");
            userService.updateProfile(
                    UpdateProfileRequest.builder().avatarUrl(url).build(), p);
            return ResponseEntity.ok(Map.of("avatarUrl", url));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
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

    // ── ADMIN: GET ALL USERS (paginated) ────────────────────
    @Operation(summary = "Lấy danh sách tất cả users (Admin) — phân trang")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/api/v1/users")
    public ResponseEntity<Page<UserService.UserResponse>> getAllUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(userService.getAllUsers(page, size));
    }

    // ── ADMIN: COUNT ALL USERS ───────────────────────────────
    @Operation(summary = "Đếm tổng số users đã đăng ký (Admin)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/api/v1/users/count")
    public ResponseEntity<Map<String, Long>> countUsers() {
        return ResponseEntity.ok(Map.of("total", userService.getUsersCount()));
    }

    // ── ADMIN: UPDATE USER ROLE ──────────────────────────────
    @Operation(summary = "Cập nhật role của user (Admin)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/api/v1/users/{id}/role")
    public ResponseEntity<Map<String, String>> updateUserRole(
            @PathVariable UUID id,
            @RequestBody Map<String, String> body) {
        String roleStr = body.get("role");
        return ResponseEntity.ok(Map.of("role", userService.updateUserRole(id, roleStr)));
    }

    // ── ADMIN: DELETE USER ──────────────────────────────────
    @Operation(summary = "Xóa user (Admin)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/api/v1/users/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable UUID id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}