package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.firebase.*;
import com.languageapp.language_learning_backend.service.*;
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
public class OtpController {

    private final UserService userService;
    private final FirebaseOtpService otpService;

    @Operation(summary = "Xác thực email bằng OTP")
    @PostMapping("/verify-email")
    public ResponseEntity<OtpResponse> verifyEmail(@Valid @RequestBody OtpRequest req) {

        userService.verifyEmail(req.getEmail(), req.getOtp());

        return ResponseEntity.ok(OtpResponse.builder()
                .success(true)
                .message("Email đã được xác thực thành công")
                .email(req.getEmail())
                .build());
    }

    @Operation(summary = "Quên mật khẩu - Gửi OTP qua email")
    @PostMapping("/forgot-password")
    public ResponseEntity<OtpResponse> forgotPassword(@Valid @RequestBody ForgotPasswordRequest req) {

        userService.forgotPassword(req.getEmail());

        return ResponseEntity.ok(OtpResponse.builder()
                .success(true)
                .message("Mã OTP đã được gửi đến email của bạn")
                .email(req.getEmail())
                .expiresInMinutes(5)
                .build());
    }

    @Operation(summary = "Đặt lại mật khẩu bằng OTP")
    @PostMapping("/reset-password")
    public ResponseEntity<OtpResponse> resetPassword(@Valid @RequestBody ResetPasswordRequest req) {

        userService.resetPassword(req.getEmail(), req.getOtp(), req.getNewPassword());

        return ResponseEntity.ok(OtpResponse.builder()
                .success(true)
                .message("Mật khẩu đã được đặt lại thành công")
                .email(req.getEmail())
                .build());
    }

    @Operation(summary = "Gửi lại OTP (resend)")
    @PostMapping("/resend-otp")
    public ResponseEntity<OtpResponse> resendOtp(@Valid @RequestBody ResendOtpRequest req) {

        otpService.generateAndSendOtp(req.getEmail(), req.getType());

        return ResponseEntity.ok(OtpResponse.builder()
                .success(true)
                .message("Mã OTP mới đã được gửi")
                .email(req.getEmail())
                .expiresInMinutes(5)
                .build());
    }

    // ══════════════════════════════════════════════
    // REQUEST DTOs
    // ══════════════════════════════════════════════
    @lombok.Getter @lombok.Setter @lombok.NoArgsConstructor @lombok.AllArgsConstructor
    public static class ForgotPasswordRequest {
        @jakarta.validation.constraints.NotBlank
        @jakarta.validation.constraints.Email
        private String email;
    }

    @lombok.Getter @lombok.Setter @lombok.NoArgsConstructor @lombok.AllArgsConstructor
    public static class ResetPasswordRequest {
        @jakarta.validation.constraints.NotBlank
        @jakarta.validation.constraints.Email
        private String email;

        @jakarta.validation.constraints.NotBlank
        @jakarta.validation.constraints.Pattern(regexp = "\\d{6}")
        private String otp;

        @jakarta.validation.constraints.NotBlank
        @jakarta.validation.constraints.Size(min = 8)
        private String newPassword;
    }

    @lombok.Getter @lombok.Setter @lombok.NoArgsConstructor @lombok.AllArgsConstructor
    public static class ResendOtpRequest {
        @jakarta.validation.constraints.NotBlank
        @jakarta.validation.constraints.Email
        private String email;

        @jakarta.validation.constraints.NotBlank
        @jakarta.validation.constraints.Pattern(regexp = "VERIFICATION|RESET_PASSWORD")
        private String type;
    }
}