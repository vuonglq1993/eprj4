// ─────────────────────────────────────────────────────────────────────────
// FILE: dto/payment/VNPayReturnResponse.java
// ─────────────────────────────────────────────────────────────────────────
package com.languageapp.language_learning_backend.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Response trả về client sau khi VNPay redirect user về /vnpay/return
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VNPayReturnResponse {
    /** "00" = thành công, "97" = sai chữ ký, mã khác = lỗi VNPay */
    private String  code;
    private String  message;
    private boolean success;

    private String txnRef;         // vnp_TxnRef
    private String transactionNo;  // vnp_TransactionNo — mã GD phía VNPay
    private String amount;         // VND (đã chia 100)
    private String bankCode;       // vnp_BankCode
    private String payDate;        // vnp_PayDate
}