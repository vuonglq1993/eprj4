package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Tag(name = "09 · Payments")
@RestController
@RequestMapping("/api/v1/payments/paypal")
@RequiredArgsConstructor
public class PayPalReturnController {

    private final PaymentService paymentService;

    @Value("${android.url:linguanext://app}")
    private String androidUrl;

    /**
     * PayPal redirect về đây sau khi user APPROVE.
     * PayPal gửi: ?token=ORDER_ID&PayerID=...
     * Backend capture order → update DB → redirect deep link về app.
     */
    @Operation(summary = "PayPal return URL — capture và redirect về app")
    @GetMapping("/return")
    public ResponseEntity<Void> returnUrl(
            @RequestParam(name = "token") String orderId,
            @RequestParam(name = "PayerID", required = false) String payerId) {

        log.info("PayPal return: orderId={}, payerId={}", orderId, payerId);

        boolean success = false;
        try {
            paymentService.capturePayPalByOrderId(orderId);
            success = true;
            log.info("PayPal capture success: orderId={}", orderId);
        } catch (Exception e) {
            log.error("PayPal capture failed: orderId={}, error={}", orderId, e.getMessage());
        }

        String deepLink = androidUrl + "/payment/paypal/" + (success ? "success" : "failed")
                + "?token=" + orderId;
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.LOCATION, deepLink);
        return new ResponseEntity<>(headers, HttpStatus.FOUND);
    }

    /**
     * PayPal redirect về đây khi user CANCEL.
     */
    @Operation(summary = "PayPal cancel URL — cập nhật trạng thái và redirect về app")
    @GetMapping("/cancel")
    public ResponseEntity<Void> cancelUrl(
            @RequestParam(name = "token", required = false) String orderId) {

        log.info("PayPal cancel: orderId={}", orderId);
        if (orderId != null) {
            try {
                paymentService.cancelPayPalOrder(orderId);
            } catch (Exception e) {
                log.warn("PayPal cancel update failed: {}", e.getMessage());
            }
        }

        String deepLink = androidUrl + "/payment/paypal/cancel";
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.LOCATION, deepLink);
        return new ResponseEntity<>(headers, HttpStatus.FOUND);
    }
}
