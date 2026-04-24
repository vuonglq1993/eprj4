package com.languageapp.language_learning_backend.payment;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@Component
public class VNPayClient {

    @Value("${vnpay.tmn-code}")
    private String tmnCode;

    @Value("${vnpay.hash-secret}")
    private String hashSecret;

    @Value("${vnpay.payment-url}")
    private String paymentUrl;

    @Value("${vnpay.return-url}")
    private String returnUrl;

    @Value("${vnpay.ipn-url:}")
    private String ipnUrl;

    @Value("${vnpay.version:2.1.0}")
    private String version;

    // ================= CREATE PAYMENT =================
    public String createPaymentUrl(String txnRef, long amount, String orderInfo, String ipAddr) {

        if ("0:0:0:0:0:0:0:1".equals(ipAddr) || "::1".equals(ipAddr)) {
            ipAddr = "127.0.0.1";
        }

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");

        String createDate = formatter.format(cld.getTime());
        cld.add(Calendar.MINUTE, 15);
        String expireDate = formatter.format(cld.getTime());

        String sanitizedOrderInfo = sanitizeOrderInfo(orderInfo);

        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", version);
        params.put("vnp_Command", "pay");
        params.put("vnp_TmnCode", tmnCode);
        params.put("vnp_Amount", String.valueOf(amount * 100));
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_TxnRef", txnRef);
        params.put("vnp_OrderInfo", sanitizedOrderInfo);
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", returnUrl);
        params.put("vnp_IpAddr", ipAddr);
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);



        // ===== SORT PARAMS =====
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        boolean first = true;

        for (String fieldName : fieldNames) {
            String value = params.get(fieldName);

            if (value != null && !value.isEmpty()) {
                try {
                    String encodedValue = URLEncoder.encode(value, StandardCharsets.US_ASCII.toString());

                    if (!first) {
                        hashData.append('&');
                        query.append('&');
                    }

                    hashData.append(fieldName).append('=').append(encodedValue);
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                            .append('=').append(encodedValue);

                    first = false;

                } catch (UnsupportedEncodingException e) {
                    log.error("Encode error", e);
                }
            }
        }

        String hash = hmacSHA512(hashSecret, hashData.toString());
        String finalUrl = paymentUrl + "?" + query + "&vnp_SecureHash=" + hash;

        // ===== DEBUG =====
        log.info("========== VNPay DEBUG ==========");
        log.info("txnRef       : {}", txnRef);
        log.info("amount       : {} (x100={})", amount, amount * 100);
        log.info("orderInfo    : {}", sanitizedOrderInfo);
        log.info("createDate   : {}", createDate);
        log.info("expireDate   : {}", expireDate);

        log.info("hashData RAW : {}", hashData);
        log.info("hash length  : {}", hash.length());
        log.info("secureHash   : {}", hash);

        log.info("FINAL URL    : {}", finalUrl);
        log.info("=================================");

        return finalUrl;
    }

    // ================= HELPER METHODS =================

    // Check giao dịch thành công
    public boolean isSuccess(Map<String, String> params) {
        return "00".equals(params.get("vnp_ResponseCode"));
    }

    // Lấy mã giao dịch của bạn (txnRef)
    public String getTxnRef(Map<String, String> params) {
        return params.get("vnp_TxnRef");
    }

    // Lấy mã giao dịch bên VNPay
    public String getVnpTransactionNo(Map<String, String> params) {
        return params.get("vnp_TransactionNo");
    }

    // ================= VERIFY =================
    public boolean verifySignature(Map<String, String> rawParams) {

        String receivedHash = rawParams.get("vnp_SecureHash");

        if (receivedHash == null) {
            log.error("Missing vnp_SecureHash");
            return false;
        }

        Map<String, String> fields = new HashMap<>();

        for (Map.Entry<String, String> entry : rawParams.entrySet()) {
            if (!entry.getKey().equals("vnp_SecureHash") &&
                    !entry.getKey().equals("vnp_SecureHashType")) {

                try {
                    fields.put(
                            entry.getKey(),
                            URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII.toString())
                    );
                } catch (Exception e) {
                    log.error("Encode error", e);
                }
            }
        }

        List<String> keys = new ArrayList<>(fields.keySet());
        Collections.sort(keys);

        StringBuilder hashData = new StringBuilder();
        boolean first = true;

        for (String key : keys) {
            String value = fields.get(key);

            if (value != null && !value.isEmpty()) {

                if (!first) hashData.append('&');

                hashData.append(key).append('=').append(value);
                first = false;
            }
        }

        String computedHash = hmacSHA512(hashSecret, hashData.toString());

        // ===== DEBUG =====
        log.info("========== VERIFY DEBUG ==========");
        log.info("RAW PARAMS   : {}", rawParams);
        log.info("hashData     : {}", hashData);
        log.info("computedHash : {}", computedHash);
        log.info("receivedHash : {}", receivedHash);
        log.info("MATCH        : {}", computedHash.equals(receivedHash));
        log.info("=================================");

        return computedHash.equals(receivedHash);
    }

    // ================= HMAC =================
    private String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] raw = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder sb = new StringBuilder();
            for (byte b : raw) sb.append(String.format("%02x", b));
            return sb.toString();

        } catch (Exception e) {
            throw new RuntimeException("HMAC error", e);
        }
    }

    // ================= CLEAN TEXT =================
    private String sanitizeOrderInfo(String input) {
        if (input == null) return "Payment";
        return input.replaceAll("[^a-zA-Z0-9 ]", "").trim();
    }
}