package com.languageapp.language_learning_backend.payment;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * VNPay Payment Client
 * Docs: https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/
 */
@Slf4j
@Component
public class VNPayClient {

    @Value("${vnpay.tmn-code}")
    private String tmnCode;

    @Value("${vnpay.hash-secret}")
    private String hashSecret;

    @Value("${vnpay.payment-url:https://sandbox.vnpayment.vn/paymentv2/vpcpay.html}")
    private String paymentUrl;

    @Value("${vnpay.return-url}")
    private String returnUrl;

    @Value("${vnpay.ipn-url:}")
    private String ipnUrl;

    @Value("${vnpay.version:2.1.0}")
    private String version;

    // ── TẠO URL THANH TOÁN ───────────────────────────────────

    /**
     * Tạo URL redirect sang cổng VNPay.
     *
     * @param txnRef   mã giao dịch nội bộ (PaymentTransaction.id dạng string)
     * @param amount   số tiền VNĐ (ví dụ: 119000)
     * @param orderInfo mô tả đơn hàng
     * @param ipAddr   IP của client
     * @return URL redirect sang VNPay
     */
    public String createPaymentUrl(String txnRef, long amount, String orderInfo, String ipAddr) {
        String createDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String expireDate = new SimpleDateFormat("yyyyMMddHHmmss")
                .format(new Date(System.currentTimeMillis() + 15 * 60 * 1000)); // 15 phút

        Map<String, String> params = new TreeMap<>(); // TreeMap tự sort theo key
        params.put("vnp_Version",    version);
        params.put("vnp_Command",    "pay");
        params.put("vnp_TmnCode",    tmnCode);
        params.put("vnp_Amount",     String.valueOf(amount * 100)); // VNPay nhân 100
        params.put("vnp_CurrCode",   "VND");
        params.put("vnp_TxnRef",     txnRef);
        params.put("vnp_OrderInfo",  orderInfo);
        params.put("vnp_OrderType",  "other");
        params.put("vnp_Locale",     "vn");
        params.put("vnp_ReturnUrl",  returnUrl);
        params.put("vnp_IpAddr",     ipAddr);
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);

        if (ipnUrl != null && !ipnUrl.isBlank()) {
            params.put("vnp_IpnUrl", ipnUrl);
        }

        // Build query string + checksum
        String queryString = buildQueryString(params);
        String secureHash  = hmacSHA512(hashSecret, queryString);

        String fullUrl = paymentUrl + "?" + queryString + "&vnp_SecureHash=" + secureHash;
        log.info("VNPay URL created for txnRef={}", txnRef);
        return fullUrl;
    }

    // ── VERIFY IPN / RETURN URL ──────────────────────────────

    /**
     * Xác minh chữ ký từ VNPay gửi về (IPN hoặc return URL).
     *
     * @param params toàn bộ query params nhận được
     * @return true nếu chữ ký hợp lệ
     */
    public boolean verifySignature(Map<String, String> params) {
        String receivedHash = params.get("vnp_SecureHash");
        if (receivedHash == null || receivedHash.isBlank()) return false;

        // Bỏ vnp_SecureHash ra khỏi map trước khi tính lại hash
        Map<String, String> filtered = new TreeMap<>(params);
        filtered.remove("vnp_SecureHash");
        filtered.remove("vnp_SecureHashType");

        String queryString   = buildQueryString(filtered);
        String expectedHash  = hmacSHA512(hashSecret, queryString);

        boolean ok = expectedHash.equalsIgnoreCase(receivedHash);
        if (!ok) log.warn("VNPay signature mismatch! expected={} received={}", expectedHash, receivedHash);
        return ok;
    }

    /**
     * Kiểm tra giao dịch thành công.
     * VNPay trả về vnp_ResponseCode = "00" khi thành công.
     */
    public boolean isSuccess(Map<String, String> params) {
        return "00".equals(params.get("vnp_ResponseCode"));
    }

    /**
     * Lấy mã giao dịch nội bộ từ params trả về.
     */
    public String getTxnRef(Map<String, String> params) {
        return params.get("vnp_TxnRef");
    }

    /**
     * Lấy mã giao dịch VNPay (dùng để đối soát).
     */
    public String getVnpTransactionNo(Map<String, String> params) {
        return params.get("vnp_TransactionNo");
    }

    // ── HELPERS ───────────────────────────────────────────────

    private String buildQueryString(Map<String, String> params) {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, String> e : params.entrySet()) {
            if (e.getValue() != null && !e.getValue().isBlank()) {
                if (!sb.isEmpty()) sb.append("&");
                sb.append(URLEncoder.encode(e.getKey(),   StandardCharsets.US_ASCII));
                sb.append("=");
                sb.append(URLEncoder.encode(e.getValue(), StandardCharsets.US_ASCII));
            }
        }
        return sb.toString();
    }

    private String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("VNPay HMAC error", e);
        }
    }
}