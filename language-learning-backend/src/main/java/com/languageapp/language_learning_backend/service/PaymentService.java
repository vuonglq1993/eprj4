package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.PaymentTransaction.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.payment.PayPalClient;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * PaymentService — orchestration layer.
 *
 * Chỉ chứa:
 *   - createPayment(): route VNPAY → VNPayService, PAYPAL → logic PayPal tại đây
 *   - capturePayPalOrder()
 *   - getTransactionStatus(), getHistory()
 *
 * Toàn bộ VNPay business logic đã chuyển sang VNPayService.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PayPalClient                 paypal;
    private final VNPayService                 vnPayService;   // ← inject VNPayService
    private final PaymentTransactionRepository txRepo;
    private final UserRepository               userRepo;
    private final SubscriptionService          subService;
    private final SubscriptionPlanService      planService;

    private static final BigDecimal USD_RATE = BigDecimal.valueOf(24000);

    // ═══════════════════════════════════════════════════════════════
    // CREATE PAYMENT — route sang đúng gateway
    // ═══════════════════════════════════════════════════════════════
    @Transactional
    public CreatePaymentResponse createPayment(CreatePaymentRequest req,
                                               UserPrincipal p,
                                               HttpServletRequest httpReq) {
        User user = userRepo.findById(p.getUserId())
                .orElseThrow(() -> new NotFoundException("User not found"));

        SubscriptionPlan plan = planService.getByName(req.getPlan().name());

        return switch (req.getGateway()) {
            case VNPAY  -> vnPayService.createVNPayPayment(user, plan, req.getPlan(), getClientIp(httpReq));
            case PAYPAL -> createPayPalPayment(user, plan, req.getPlan());
            default     -> throw new BadRequestException("Gateway not supported: " + req.getGateway());
        };
    }

    // ── VNPAY ─────────────────────────────────────────────────

    private String getClientIp(jakarta.servlet.http.HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) ip = req.getRemoteAddr();
        return (ip != null && ip.contains(",")) ? ip.split(",")[0].trim() : (ip != null ? ip : "127.0.0.1");
    }

    @Transactional
    public CreatePaymentResponse createVNPayPayment(User user,
                                                    SubscriptionPlan plan,
                                                    Plan planEnum,
                                                    String clientIp) {
        // VNPay vnp_TxnRef max 8 chars — dùng 8 hex đầu của UUID (đủ unique trong ngày)
        PaymentTransaction tx = txRepo.save(PaymentTransaction.builder()
                .user(user)
                .amount(BigDecimal.valueOf(plan.getPrice()))
                .currency("VND")
                .gateway(Gateway.VNPAY)
                .plan(planEnum)
                .status(TxStatus.PENDING)
                .build());

        String txnRef = tx.getId().toString().replace("-", "").substring(0, 8).toUpperCase();
        String orderInfo = "Thanh toan goi " + plan.getName() + " LinguaNext";
        String paymentUrl = vnpay.createPaymentUrl(txnRef, plan.getPrice(), orderInfo, clientIp);

        tx.setGatewayRef(txnRef); // giữ txnRef nguyên để IPN lookup luôn tìm được
        txRepo.save(tx);

        return CreatePaymentResponse.builder()
                .transactionId(tx.getId().toString())
                .gatewayRef(txnRef)
                .paymentUrl(paymentUrl)
                .gateway(Gateway.VNPAY.name())
                .amount(BigDecimal.valueOf(plan.getPrice()))
                .currency("VND")
                .plan(plan.getName())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    /**
     * Xử lý IPN từ VNPay (server-to-server, gọi bởi VNPayController).
     */
    @Transactional
    public String handleVNPayIPN(Map<String, String> params) {
        if (!vnpay.verifySignature(params))
            throw new BadRequestException("Invalid VNPay signature");

        String txnRef = vnpay.getTxnRef(params);
        PaymentTransaction tx = txRepo.findByGatewayRef(txnRef)
                .orElseThrow(() -> new NotFoundException("Transaction not found: " + txnRef));

        // Chặn double update
        if (tx.getStatus() == TxStatus.SUCCESS) {
            log.info("VNPay IPN: transaction {} already processed", txnRef);
            return "Already processed";
        }

        if (!vnpay.isSuccess(params)) {
            tx.setStatus(TxStatus.FAILED);
            tx.setFailureReason("VNPay responseCode=" + params.get("vnp_ResponseCode"));
            txRepo.save(tx);
            log.warn("VNPay payment failed: txnRef={}, code={}", txnRef, params.get("vnp_ResponseCode"));
            return "Payment failed";
        }

        // Kiểm tra số tiền (bảo vệ chống giả mạo)
        long receivedAmount = Long.parseLong(params.getOrDefault("vnp_Amount", "0")) / 100;
        long expectedAmount = tx.getAmount().longValue();
        if (receivedAmount != expectedAmount) {
            log.error("VNPay amount mismatch: expected={} received={}", expectedAmount, receivedAmount);
            throw new BadRequestException("Amount mismatch");
        }

        tx.setStatus(TxStatus.SUCCESS);
        tx.setPaidAt(LocalDateTime.now());
        // KHÔNG overwrite gatewayRef (= txnRef) để IPN retry vẫn tìm được transaction
        // vnp_TransactionNo lưu vào rawWebhook để đối soát
        tx.setRawWebhook("vnpTransactionNo=" + vnpay.getVnpTransactionNo(params) + " | " + params);
        txRepo.save(tx);

        SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
        subService.activate(tx.getUser(), plan);

        log.info("VNPay payment SUCCESS: txnRef={}, userId={}, plan={}",
                txnRef, tx.getUser().getId(), tx.getPlan());
        return "Payment confirmed";
    }

    public boolean verifyVNPayReturn(Map<String, String> params) {
        return vnpay.verifySignature(params);
    }

    // ── PAYPAL ─────────────────────────────────────────────────

    @Transactional
    public CreatePaymentResponse createPayPalPayment(User user,
                                                     SubscriptionPlan plan,
                                                     Plan planEnum) {
        BigDecimal amount = BigDecimal.valueOf(plan.getPrice())
                .divide(USD_RATE, 2, RoundingMode.HALF_UP);

        PaymentTransaction tx = txRepo.save(PaymentTransaction.builder()
                .user(user)
                .amount(amount)
                .currency("USD")
                .gateway(Gateway.PAYPAL)
                .plan(planEnum)
                .status(TxStatus.PENDING)
                .build());

        var order = paypal.createOrder(tx.getId().toString(), amount, plan.getName());
        tx.setGatewayRef(order.orderId());
        txRepo.save(tx);

        log.info("[PayPal] Created payment - orderId={}, userId={}, plan={}, amount={}",
                order.orderId(), user.getId(), planEnum, amount);

        return CreatePaymentResponse.builder()
                .transactionId(tx.getId().toString())
                .gatewayRef(order.orderId())
                .paymentUrl(order.approveUrl())
                .gateway(Gateway.PAYPAL.name())
                .amount(amount)
                .currency("USD")
                .plan(plan.getName())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    /** Dùng bởi PayPalReturnController — không cần UserPrincipal vì PayPal gọi server-to-server */
    @Transactional
    public void capturePayPalByOrderId(String orderId) {
        PaymentTransaction tx = txRepo.findByGatewayRef(orderId)
                .orElseThrow(() -> new NotFoundException("Transaction not found: " + orderId));

        if (tx.getStatus() == TxStatus.SUCCESS) {
            log.info("PayPal order {} already captured", orderId);
            return;
        }

        var resp = paypal.captureOrderDetail(orderId);
        if ("COMPLETED".equals(resp.status())) {
            tx.setStatus(TxStatus.SUCCESS);
            tx.setPaidAt(LocalDateTime.now());
            txRepo.save(tx);
            SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
            subService.activate(tx.getUser(), plan);
            log.info("PayPal capture SUCCESS: orderId={}, userId={}, plan={}",
                    orderId, tx.getUser().getId(), tx.getPlan());
        } else {
            tx.setStatus(TxStatus.FAILED);
            tx.setFailureReason("PayPal capture status=" + resp.status());
            txRepo.save(tx);
            throw new BadRequestException("Thanh toán PayPal thất bại: " + resp.status());
        }
    }

    /** Cập nhật DB khi user cancel trên PayPal */
    @Transactional
    public void cancelPayPalOrder(String orderId) {
        txRepo.findByGatewayRef(orderId).ifPresent(tx -> {
            if (tx.getStatus() == TxStatus.PENDING) {
                tx.setStatus(TxStatus.CANCELLED);
                tx.setFailureReason("User cancelled on PayPal");
                txRepo.save(tx);
                log.info("PayPal order cancelled: orderId={}", orderId);
            }
        });
    }

    @Transactional
    public void capturePayPalOrder(String orderId, UserPrincipal p) {
        PaymentTransaction tx = txRepo.findByGatewayRef(orderId)
                .orElseThrow(() -> new NotFoundException("Transaction not found"));

        if (!tx.getUser().getId().equals(p.getUserId()))
            throw new BadRequestException("Access denied");

        if (tx.getStatus() == TxStatus.SUCCESS) return;


//        new Thread(() -> {
        try {
            var resp = paypal.captureOrderDetail(orderId);

            if ("COMPLETED".equals(resp.status())) {
                tx.setStatus(TxStatus.SUCCESS);
                tx.setPaidAt(LocalDateTime.now());
                txRepo.save(tx);

                SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
                subService.activate(tx.getUser(), plan);

                log.info("✅ PayPal SUCCESS {}", orderId);
            } else {
                tx.setStatus(TxStatus.FAILED);
                txRepo.save(tx);
            }
        } catch (Exception e) {
            log.error("❌ PayPal capture error", e);
            throw new RuntimeException("Capture PayPal failed", e); // 👈 nên throw lại
        }
    }

    @Transactional
    public Map<String, String> getTransactionStatus(String transactionId, UserPrincipal p) {
        PaymentTransaction tx = txRepo.findById(UUID.fromString(transactionId))
                .orElseThrow(() -> new NotFoundException("Transaction not found"));

        if (!tx.getUser().getId().equals(p.getUserId())) {
            throw new BadRequestException("Access denied");

        // PayPal PENDING → check PayPal API và auto-capture nếu APPROVED
        if (tx.getGateway() == Gateway.PAYPAL && tx.getStatus() == TxStatus.PENDING
                && tx.getGatewayRef() != null) {
            String paypalStatus = paypal.getOrderStatus(tx.getGatewayRef());
            log.info("PayPal order {} status from API: {}", tx.getGatewayRef(), paypalStatus);
            if ("APPROVED".equals(paypalStatus)) {
                try {
                    var capture = paypal.captureOrderDetail(tx.getGatewayRef());
                    if ("COMPLETED".equals(capture.status())) {
                        tx.setStatus(TxStatus.SUCCESS);
                        tx.setPaidAt(LocalDateTime.now());
                        txRepo.save(tx);
                        SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
                        subService.activate(tx.getUser(), plan);
                        log.info("PayPal auto-captured: orderId={}, userId={}", tx.getGatewayRef(), p.getUserId());
                    }
                } catch (Exception e) {
                    log.warn("PayPal auto-capture failed: {}", e.getMessage());
                }
            } else if ("COMPLETED".equals(paypalStatus)) {
                // Đã capture rồi nhưng DB chưa update (edge case)
                tx.setStatus(TxStatus.SUCCESS);
                tx.setPaidAt(LocalDateTime.now());
                txRepo.save(tx);
                SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
                subService.activate(tx.getUser(), plan);
            }
        }

        return Map.of("status", tx.getStatus().name(), "gateway", tx.getGateway().name());
    }

        return Map.of(
                "status",  tx.getStatus().name(),
                "gateway", tx.getGateway().name()
        );
    }

    // ═══════════════════════════════════════════════════════════════
    // HISTORY
    // ═══════════════════════════════════════════════════════════════
    @Transactional(readOnly = true)
    public List<PaymentHistoryResponse> getHistory(UserPrincipal p) {
        return txRepo.findByUserIdOrderByCreatedAtDesc(p.getUserId(), PageRequest.of(0, 20))
                .getContent().stream()
                .map(tx -> PaymentHistoryResponse.builder()
                        .id(tx.getId())
                        .gateway(tx.getGateway().name())
                        .amount(tx.getAmount())
                        .currency(tx.getCurrency())
                        .plan(tx.getPlan().name())
                        .status(tx.getStatus().name())
                        .gatewayRef(tx.getGatewayRef())
                        .createdAt(tx.getCreatedAt())
                        .paidAt(tx.getPaidAt())
                        .build())
                .collect(Collectors.toList());
    }

    // ═══════════════════════════════════════════════════════════════
    // HELPER
    // ═══════════════════════════════════════════════════════════════
    private String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return (ip != null && !ip.isBlank()) ? ip : "127.0.0.1";
    }
}