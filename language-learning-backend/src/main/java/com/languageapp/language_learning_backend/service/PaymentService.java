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

    // ═══════════════════════════════════════════════════════════════
    // PAYPAL — giữ nguyên trong PaymentService vì đơn giản
    // ═══════════════════════════════════════════════════════════════
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
                .paymentUrl(order.approveUrl())
                .gateway(Gateway.PAYPAL.name())
                .amount(amount)
                .currency("USD")
                .plan(plan.getName())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    @Transactional
    public void capturePayPalOrder(String orderId) {
        var resp = paypal.captureOrderDetail(orderId);
        if (!"COMPLETED".equals(resp.status())) {
            throw new BadRequestException("Payment not completed: " + resp.status());
        }

        PaymentTransaction tx = txRepo.findByGatewayRef(orderId)
                .orElseThrow(() -> new NotFoundException("Transaction not found"));

        if (tx.getStatus() == TxStatus.SUCCESS) return; // idempotent

        tx.setStatus(TxStatus.SUCCESS);
        tx.setPaidAt(LocalDateTime.now());
        txRepo.save(tx);

        SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
        subService.activate(tx.getUser(), plan);

        log.info("[PayPal] Captured - orderId={}, userId={}, plan={}",
                orderId, tx.getUser().getId(), tx.getPlan());
    }

    // ═══════════════════════════════════════════════════════════════
    // STATUS POLLING
    // ═══════════════════════════════════════════════════════════════
    @Transactional(readOnly = true)
    public Map<String, String> getTransactionStatus(String transactionId, UserPrincipal p) {
        PaymentTransaction tx = txRepo.findById(UUID.fromString(transactionId))
                .orElseThrow(() -> new NotFoundException("Transaction not found"));

        if (!tx.getUser().getId().equals(p.getUserId())) {
            throw new BadRequestException("Access denied");
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