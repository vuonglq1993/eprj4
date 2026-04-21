package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.PaymentTransaction.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.payment.PayPalClient;
import com.languageapp.language_learning_backend.payment.VNPayClient;
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
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PayPalClient                 paypal;
    private final VNPayClient                  vnpay;
    private final PaymentTransactionRepository txRepo;
    private final UserRepository               userRepo;
    private final SubscriptionService          subService;
    private final SubscriptionPlanService      planService;

    private static final BigDecimal USD_RATE = BigDecimal.valueOf(24000);

    // ── CREATE PAYMENT ─────────────────────────────────────────
    @Transactional
    public CreatePaymentResponse createPayment(CreatePaymentRequest req,
                                               UserPrincipal p,
                                               HttpServletRequest httpReq) {
        User user = userRepo.findById(p.getUserId())
                .orElseThrow(() -> new NotFoundException("User not found"));

        SubscriptionPlan plan = planService.getByName(req.getPlan().name());

        return switch (req.getGateway()) {
            case VNPAY  -> createVNPayPayment(user, plan, req.getPlan());
            case PAYPAL -> createPayPalPayment(user, plan, req.getPlan());
            default     -> throw new BadRequestException("Gateway not supported: " + req.getGateway());
        };
    }

    // ── VNPAY ─────────────────────────────────────────────────

    @Transactional
    public CreatePaymentResponse createVNPayPayment(User user,
                                                    SubscriptionPlan plan,
                                                    Plan planEnum) {
        PaymentTransaction tx = txRepo.save(PaymentTransaction.builder()
                .user(user)
                .amount(BigDecimal.valueOf(plan.getPrice()))
                .currency("VND")
                .gateway(Gateway.VNPAY)
                .plan(planEnum)
                .status(TxStatus.PENDING)
                .build());

        String orderInfo = "Thanh toan goi " + plan.getName() + " LinguaNext";
        String paymentUrl = vnpay.createPaymentUrl(
                tx.getId().toString(),
                plan.getPrice(),
                orderInfo,
                "127.0.0.1"   // production: lấy từ HttpServletRequest
        );

        tx.setGatewayRef(tx.getId().toString());
        txRepo.save(tx);

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
        tx.setGatewayRef(vnpay.getVnpTransactionNo(params));
        tx.setRawWebhook(params.toString());
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
                .user(user).amount(amount).currency("USD")
                .gateway(Gateway.PAYPAL).plan(planEnum).status(TxStatus.PENDING)
                .build());

        var order = paypal.createOrder(tx.getId().toString(), amount, plan.getName());
        tx.setGatewayRef(order.orderId());
        txRepo.save(tx);

        return CreatePaymentResponse.builder()
                .transactionId(tx.getId().toString())
                .paymentUrl(order.approveUrl())
                .gateway(Gateway.PAYPAL.name())
                .amount(amount).currency("USD").plan(plan.getName())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    @Transactional
    public void capturePayPalOrder(String orderId) {
        var resp = paypal.captureOrderDetail(orderId);
        if (!"COMPLETED".equals(resp.status()))
            throw new BadRequestException("Payment not completed: " + resp.status());

        PaymentTransaction tx = txRepo.findByGatewayRef(orderId)
                .orElseThrow(() -> new NotFoundException("Transaction not found"));
        if (tx.getStatus() == TxStatus.SUCCESS) return;

        tx.setStatus(TxStatus.SUCCESS);
        tx.setPaidAt(LocalDateTime.now());
        txRepo.save(tx);

        SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
        subService.activate(tx.getUser(), plan);
    }

    // ── STATUS POLLING ────────────────────────────────────────

    @Transactional(readOnly = true)
    public Map<String, String> getTransactionStatus(String transactionId, UserPrincipal p) {
        PaymentTransaction tx = txRepo.findById(UUID.fromString(transactionId))
                .orElseThrow(() -> new NotFoundException("Transaction not found"));
        if (!tx.getUser().getId().equals(p.getUserId()))
            throw new BadRequestException("Access denied");
        return Map.of("status", tx.getStatus().name(), "gateway", tx.getGateway().name());
    }

    // ── HISTORY ───────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<PaymentHistoryResponse> getHistory(UserPrincipal p) {
        return txRepo.findByUserIdOrderByCreatedAtDesc(p.getUserId(), PageRequest.of(0, 20))
                .getContent().stream()
                .map(tx -> PaymentHistoryResponse.builder()
                        .id(tx.getId()).gateway(tx.getGateway().name())
                        .amount(tx.getAmount()).currency(tx.getCurrency())
                        .plan(tx.getPlan().name()).status(tx.getStatus().name())
                        .gatewayRef(tx.getGatewayRef())
                        .createdAt(tx.getCreatedAt()).paidAt(tx.getPaidAt())
                        .build())
                .collect(Collectors.toList());
    }
}