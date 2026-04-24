package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.PaymentTransaction.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.payment.VNPayClient;
import com.languageapp.language_learning_backend.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * VNPayService — toàn bộ business logic liên quan VNPay.
 *
 * Được gọi bởi:
 *   - PaymentService.createPayment()  → createVNPayPayment()
 *   - VNPayController.handleReturn()  → verifyReturn()
 *   - VNPayController.handleIpn()     → handleIPN()
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class VNPayService {

    private final VNPayClient                  vnPayClient;
    private final PaymentTransactionRepository txRepo;
    private final SubscriptionService          subService;
    private final SubscriptionPlanService      planService;

    // ═══════════════════════════════════════════════════════════════
    // CREATE — tạo payment URL, lưu transaction PENDING
    // Gọi từ: PaymentService.createPayment()
    // ═══════════════════════════════════════════════════════════════
    @Transactional
    public CreatePaymentResponse createVNPayPayment(User user,
                                                    SubscriptionPlan plan,
                                                    Plan planEnum,
                                                    String clientIp) {
        // Lưu transaction PENDING trước để lấy ID
        PaymentTransaction tx = txRepo.save(PaymentTransaction.builder()
                .user(user)
                .amount(BigDecimal.valueOf(plan.getPrice()))
                .currency("VND")
                .gateway(Gateway.VNPAY)
                .plan(planEnum)
                .status(TxStatus.PENDING)
                .build());

        // TxnRef: 8 hex đầu UUID — unique trong ngày, đủ cho vnp_TxnRef max 8 chars
        String txnRef = tx.getId().toString().replace("-", "").substring(0, 8).toUpperCase();
        String orderInfo = "Thanh toan goi " + plan.getName() + " LinguaNext";

        String paymentUrl = vnPayClient.createPaymentUrl(txnRef, plan.getPrice(), orderInfo, clientIp);

        // Lưu txnRef để IPN có thể lookup lại
        tx.setGatewayRef(txnRef);
        txRepo.save(tx);

        log.info("[VNPay] Created payment - txnRef={}, userId={}, plan={}, amount={}",
                txnRef, user.getId(), planEnum, plan.getPrice());

        return CreatePaymentResponse.builder()
                .transactionId(tx.getId().toString())
                .paymentUrl(paymentUrl)
                .gateway(Gateway.VNPAY.name())
                .amount(BigDecimal.valueOf(plan.getPrice()))
                .currency("VND")
                .plan(plan.getName())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    // ═══════════════════════════════════════════════════════════════
    // VERIFY RETURN — kiểm tra chữ ký khi user được redirect về
    // Gọi từ: VNPayController.handleReturn()
    // ═══════════════════════════════════════════════════════════════
    public boolean verifyReturn(Map<String, String> params) {
        boolean valid = vnPayClient.verifySignature(params);
        if (!valid) {
            log.error("[VNPay] Invalid signature on return - params={}", params);
        }
        return valid;
    }

    // ═══════════════════════════════════════════════════════════════
    // HANDLE IPN — VNPay server-to-server notify
    // Gọi từ: VNPayController.handleIpn()
    //
    // Trả về VNPayIpnResponse — controller trả thẳng JSON này cho VNPay
    // KHÔNG throw exception (VNPay không đọc được exception body)
    // ═══════════════════════════════════════════════════════════════
    @Transactional
    public VNPayIpnResponse handleIPN(Map<String, String> params) {
        log.info("=== [VNPay] IPN received - params={}", params);

        // Bước 1: Kiểm tra chữ ký
        if (!vnPayClient.verifySignature(params)) {
            log.error("[VNPay] IPN invalid signature");
            return VNPayIpnResponse.invalidChecksum();
        }

        String txnRef = vnPayClient.getTxnRef(params);

        // Bước 2: Tìm transaction trong DB
        PaymentTransaction tx;
        try {
            tx = txRepo.findByGatewayRef(txnRef)
                    .orElseThrow(() -> new NotFoundException("Transaction not found: " + txnRef));
        } catch (NotFoundException e) {
            log.error("[VNPay] IPN - transaction not found: txnRef={}", txnRef);
            return VNPayIpnResponse.orderNotFound();
        }

        // Bước 3: Chặn double update (VNPay IPN có thể gọi nhiều lần)
        if (tx.getStatus() == TxStatus.SUCCESS) {
            log.warn("[VNPay] IPN - transaction already confirmed: txnRef={}", txnRef);
            return VNPayIpnResponse.alreadyConfirmed();
        }

        // Bước 4: Kiểm tra số tiền (bảo vệ chống giả mạo)
        long receivedAmount = Long.parseLong(params.getOrDefault("vnp_Amount", "0")) / 100;
        long expectedAmount = tx.getAmount().longValue();
        if (receivedAmount != expectedAmount) {
            log.error("[VNPay] IPN amount mismatch - expected={}, received={}, txnRef={}",
                    expectedAmount, receivedAmount, txnRef);
            return VNPayIpnResponse.invalidAmount();
        }

        // Bước 5: Giao dịch thất bại phía VNPay
        if (!vnPayClient.isSuccess(params)) {
            tx.setStatus(TxStatus.FAILED);
            tx.setFailureReason("vnp_ResponseCode=" + params.get("vnp_ResponseCode"));
            txRepo.save(tx);
            log.warn("[VNPay] IPN payment failed - txnRef={}, code={}",
                    txnRef, params.get("vnp_ResponseCode"));
            // Trả "00" để VNPay biết ta đã nhận và xử lý — lỗi là phía user, không phải hệ thống
            return VNPayIpnResponse.ok();
        }

        // Bước 6: Thanh toán thành công — cập nhật DB + kích hoạt subscription
        tx.setStatus(TxStatus.SUCCESS);
        tx.setPaidAt(LocalDateTime.now());
        tx.setRawWebhook("vnpTransactionNo=" + vnPayClient.getVnpTransactionNo(params)
                + " | " + params);
        txRepo.save(tx);

        SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
        subService.activate(tx.getUser(), plan);

        log.info("[VNPay] IPN SUCCESS - txnRef={}, userId={}, plan={}",
                txnRef, tx.getUser().getId(), tx.getPlan());

        return VNPayIpnResponse.ok();
    }

    // ═══════════════════════════════════════════════════════════════
    // DELEGATE HELPERS — dùng trong VNPayController
    // ═══════════════════════════════════════════════════════════════

    public boolean isSuccess(Map<String, String> params) {
        return vnPayClient.isSuccess(params);
    }

    public String getTxnRef(Map<String, String> params) {
        return vnPayClient.getTxnRef(params);
    }

    public String getTransactionNo(Map<String, String> params) {
        return vnPayClient.getVnpTransactionNo(params);
    }

    public String getAmountDisplay(Map<String, String> params) {
        String raw = params.get("vnp_Amount");
        if (raw == null) return "0";
        try {
            return String.valueOf(Long.parseLong(raw) / 100);
        } catch (NumberFormatException e) {
            return raw;
        }
    }
}