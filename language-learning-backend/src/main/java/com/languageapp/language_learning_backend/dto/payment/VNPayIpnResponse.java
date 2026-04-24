package com.languageapp.language_learning_backend.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Response cho VNPay IPN endpoint.
 *
 * VNPay yêu cầu response đúng format:
 *   {"RspCode":"00","Message":"Confirm Success"}
 *
 * Dùng field name UPPERCASE để match đúng format VNPay.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VNPayIpnResponse {

    private String RspCode;
    private String Message;

    // ── Factory methods ──────────────────────────────────────────

    /** Đã nhận và xử lý thành công */
    public static VNPayIpnResponse ok() {
        return new VNPayIpnResponse("00", "Confirm Success");
    }

    /** Sai chữ ký */
    public static VNPayIpnResponse invalidChecksum() {
        return new VNPayIpnResponse("97", "Invalid Checksum");
    }

    /** Không tìm thấy giao dịch */
    public static VNPayIpnResponse orderNotFound() {
        return new VNPayIpnResponse("01", "Order not Found");
    }

    /** Giao dịch đã được xử lý trước đó */
    public static VNPayIpnResponse alreadyConfirmed() {
        return new VNPayIpnResponse("02", "Order already confirmed");
    }

    /** Số tiền không khớp */
    public static VNPayIpnResponse invalidAmount() {
        return new VNPayIpnResponse("04", "Invalid Amount");
    }

    /** Lỗi hệ thống không xác định */
    public static VNPayIpnResponse unknownError() {
        return new VNPayIpnResponse("99", "Unknown Error");
    }
}