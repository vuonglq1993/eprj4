package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Tag(name = "09 · Payments")
@RestController
@RequestMapping("/api/v1/payments/vnpay")
@RequiredArgsConstructor
public class VNPayController {

    private final PaymentService paymentService;

    /**
     * IPN (Instant Payment Notification) — VNPay gọi server-to-server.
     * PHẢI public (không cần JWT).
     * Trả về {"RspCode":"00","Message":"Confirm Success"} nếu OK.
     */
    @Operation(summary = "VNPay IPN webhook (server-to-server)")
    @GetMapping("/ipn")
    public ResponseEntity<Map<String, String>> ipn(HttpServletRequest request) {
        Map<String, String> params = extractParams(request);
        log.info("VNPay IPN received: txnRef={}, responseCode={}",
                params.get("vnp_TxnRef"), params.get("vnp_ResponseCode"));

        try {
            String result = paymentService.handleVNPayIPN(params);
            return ResponseEntity.ok(Map.of("RspCode", "00", "Message", result));
        } catch (Exception e) {
            log.error("VNPay IPN error: {}", e.getMessage(), e);
            return ResponseEntity.ok(Map.of("RspCode", "99", "Message", e.getMessage()));
        }
    }

    /**
     * Return URL — VNPay redirect browser về sau khi user thanh toán.
     * Chỉ dùng để hiển thị kết quả cho user (không dùng để cập nhật DB —
     * hãy dùng IPN cho việc đó).
     */
    @Value("${android.url:linguanext://app}")
    private String androidUrl;

    @Operation(summary = "VNPay return URL (browser redirect → deep link)")
    @GetMapping("/return")
    public ResponseEntity<Void> returnUrl(HttpServletRequest request) {
        Map<String, String> params = extractParams(request);
        log.info("VNPay return: txnRef={}, responseCode={}",
                params.get("vnp_TxnRef"), params.get("vnp_ResponseCode"));

        boolean valid   = paymentService.verifyVNPayReturn(params);
        boolean success = valid && "00".equals(params.get("vnp_ResponseCode"));
        String txnRef   = params.getOrDefault("vnp_TxnRef", "");

        String deepLink = androidUrl + "/payment/vnpay?status=" + (success ? "success" : "failed")
                + "&txnRef=" + txnRef;

        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.LOCATION, deepLink);
        return new ResponseEntity<>(headers, HttpStatus.FOUND);
    }

    // ── HELPER ───────────────────────────────────────────────

    private Map<String, String> extractParams(HttpServletRequest request) {
        Map<String, String> result = new HashMap<>();
        request.getParameterMap().forEach((k, v) -> {
            if (v != null && v.length > 0) result.put(k, v[0]);
        });
        return result;
    }

    /** Map mã lỗi VNPay → thông báo tiếng Việt */
    private String vnpMessage(String code) {
        if (code == null) return "Không rõ";
        return switch (code) {
            case "00" -> "Giao dịch thành công";
            case "07" -> "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên hệ VNPay)";
            case "09" -> "Thẻ/Tài khoản chưa đăng ký Internet Banking";
            case "10" -> "Xác thực thông tin thẻ/tài khoản quá 3 lần";
            case "11" -> "Phiên thanh toán hết hạn";
            case "12" -> "Thẻ/Tài khoản bị khóa";
            case "13" -> "Sai OTP";
            case "24" -> "Khách hàng hủy giao dịch";
            case "51" -> "Tài khoản không đủ số dư";
            case "65" -> "Tài khoản vượt hạn mức giao dịch trong ngày";
            case "75" -> "Ngân hàng thanh toán đang bảo trì";
            case "79" -> "Sai mật khẩu thanh toán quá số lần";
            default   -> "Lỗi giao dịch (mã: " + code + ")";
        };
    }
}