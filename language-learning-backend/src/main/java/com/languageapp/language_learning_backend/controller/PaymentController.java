package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "09 · Payments")
@RestController
@RequestMapping("/api/v1/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService service;

    @Operation(summary = "Tạo đơn thanh toán (VNPay hoặc PayPal)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/create")
    public ResponseEntity<CreatePaymentResponse> create(
            @Valid @RequestBody CreatePaymentRequest req,
            @AuthenticationPrincipal UserPrincipal p,
            HttpServletRequest httpReq) {
        return ResponseEntity.ok(service.createPayment(req, p, httpReq));
    }

    @Operation(summary = "Lịch sử thanh toán")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/history")
    public ResponseEntity<List<PaymentHistoryResponse>> history(
            @AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getHistory(p));
    }

    @Operation(summary = "Capture PayPal order")
    @PostMapping("/capture")
    public ResponseEntity<Void> capture(@RequestParam String orderId) {
        service.capturePayPalOrder(orderId);
        return ResponseEntity.ok().build();
    }
}