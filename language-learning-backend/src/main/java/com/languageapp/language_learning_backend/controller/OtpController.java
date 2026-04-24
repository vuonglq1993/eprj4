package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Tag(name = "01 · Users & Auth")
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class OtpController {

    private final UserService userService;

    @Operation(summary = "Xác thực email bằng OTP")
    @PostMapping("/verify-email")
    public ResponseEntity<Map<String, String>> verifyEmail(
            @Valid @RequestBody VerifyEmailRequest req) {
        userService.verifyEmail(req.getEmail(), req.getOtp());
        return ResponseEntity.ok(Map.of("message", "Email verified successfully"));
    }

    @Operation(summary = "Quên mật khẩu - Gửi OTP")
    @PostMapping("/forgot-password")
    public ResponseEntity<Map<String, String>> forgotPassword(
            @Valid @RequestBody ForgotPasswordRequest req) {
        userService.forgotPassword(req.getEmail());
        return ResponseEntity.ok(Map.of("message", "OTP sent to your email"));
    }

    @Operation(summary = "Đặt lại mật khẩu bằng OTP")
    @PostMapping("/reset-password")
    public ResponseEntity<Map<String, String>> resetPassword(
            @Valid @RequestBody ResetPasswordRequest req) {
        userService.resetPassword(req.getEmail(), req.getOtp(), req.getNewPassword());
        return ResponseEntity.ok(Map.of("message", "Password reset successfully"));
    }

    // ══════════════════════════════════════════════
    // DTOs
    // ══════════════════════════════════════════════
    @Getter @Setter @NoArgsConstructor @AllArgsConstructor
    public static class VerifyEmailRequest {
        @NotBlank @Email private String email;
        @NotBlank @Pattern(regexp = "\\d{6}") private String otp;
    }

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor
    public static class ForgotPasswordRequest {
        @NotBlank @Email private String email;
    }

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor
    public static class ResetPasswordRequest {
        @NotBlank @Email private String email;
        @NotBlank @Pattern(regexp = "\\d{6}") private String otp;
        @NotBlank @Size(min = 8) private String newPassword;
    }
}