package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.payment.VNPayIpnResponse;
import com.languageapp.language_learning_backend.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * VNPayController — xử lý các callback từ VNPay.
 *
 * Endpoints:
 *   GET /api/v1/payments/vnpay/return  ← VNPay redirect user về (vnpay_return.jsp)
 *   GET /api/v1/payments/vnpay/ipn     ← VNPay server notify  (vnpay_ipn.jsp)
 *
 * Endpoint tạo payment nằm ở PaymentController (POST /api/v1/payments/create)
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/payments/vnpay")
@RequiredArgsConstructor
public class VNPayController {

    private final VNPayService vnPayService;

    @Value("${android.url:linguanext://app}")
    private String androidUrl;

    // ═══════════════════════════════════════════════════════════════
    // RETURN URL — VNPay redirect user về sau khi thanh toán
    // Tương đương: vnpay_return.jsp
    //
    // NOTE: Spring đã URL-decode query params tự động.
    //       VNPayClient.verifySignature() sẽ encode lại trước khi hash.
    // ═══════════════════════════════════════════════════════════════
    @GetMapping("/return")
    public ResponseEntity<Void> handleReturn(HttpServletRequest request) {
        log.info("=== [VNPay] RETURN CALLBACK ===");
        Map<String, String> params = extractParams(request);
        log.info("[VNPay] Return params: {}", params);

        boolean success = vnPayService.verifyReturn(params) && vnPayService.isSuccess(params);
        String  txnRef  = vnPayService.getTxnRef(params);

        log.info("[VNPay] Return - txnRef={}, success={}", txnRef, success);

        String deepLink = androidUrl + "/payment/vnpay/" + (success ? "success" : "failed")
                + "?txnRef=" + txnRef;
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.LOCATION, deepLink);
        return new ResponseEntity<>(headers, HttpStatus.FOUND);
    }

    // ═══════════════════════════════════════════════════════════════
    // IPN URL — VNPay server-to-server notify
    // Tương đương: vnpay_ipn.jsp
    //
    // Response BẮT BUỘC đúng format JSON VNPay:
    //   {"RspCode":"00","Message":"Confirm Success"}
    // ═══════════════════════════════════════════════════════════════
    @GetMapping("/ipn")
    public ResponseEntity<VNPayIpnResponse> handleIpn(HttpServletRequest request) {
        log.info("=== [VNPay] IPN CALLBACK ===");
        Map<String, String> params = extractParams(request);

        VNPayIpnResponse response = vnPayService.handleIPN(params);
        return ResponseEntity.ok(response);
    }

    // ═══════════════════════════════════════════════════════════════
    // HELPER — extract tất cả query params từ request
    // Spring đã URL-decode các params, ta lấy raw decoded values
    // ═══════════════════════════════════════════════════════════════
    private Map<String, String> extractParams(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String name  = names.nextElement();
            String value = request.getParameter(name);
            if (value != null && !value.isEmpty()) {
                params.put(name, value);
            }
        }
        return params;
    }
}