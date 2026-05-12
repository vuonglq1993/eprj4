package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

    // ═══════════════════════════════════════════════════════════════
    // RETURN URL — VNPay redirect user về sau khi thanh toán
    // Tương đương: vnpay_return.jsp
    //
    // NOTE: Spring đã URL-decode query params tự động.
    //       VNPayClient.verifySignature() sẽ encode lại trước khi hash.
    // ═══════════════════════════════════════════════════════════════
    @GetMapping("/return")
    public ResponseEntity<VNPayReturnResponse> handleReturn(HttpServletRequest request) {
        log.info("=== [VNPay] RETURN CALLBACK ===");
        Map<String, String> params = extractParams(request);

        if (!vnPayService.verifyReturn(params)) {
            return ResponseEntity.ok(VNPayReturnResponse.builder()
                    .code("97")
                    .message("Sai chữ ký")
                    .success(false)
                    .build());
        }

        vnPayService.processReturn(params); // thêm dòng này

        boolean success = vnPayService.isSuccess(params);
        String txnRef = vnPayService.getTxnRef(params);
        String transactionNo = vnPayService.getTransactionNo(params);
        String amount = vnPayService.getAmountDisplay(params);

        return ResponseEntity.ok(VNPayReturnResponse.builder()
                .code(success ? "00" : params.get("vnp_ResponseCode"))
                .message(success ? "Thanh toán thành công" : "Thanh toán không thành công")
                .success(success)
                .txnRef(txnRef)
                .transactionNo(transactionNo)
                .amount(amount)
                .bankCode(params.get("vnp_BankCode"))
                .payDate(params.get("vnp_PayDate"))
                .build());
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