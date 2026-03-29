package com.languageapp.language_learning_backend.service;
import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.PaymentTransaction.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.payment.PayPalClient;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
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

    private final PayPalClient                paypal;
    private final PaymentTransactionRepository txRepo;
    private final UserRepository              userRepo;
    private final SubscriptionService         subService;
    private final SubscriptionPlanService     planService;
    private static final BigDecimal USD_RATE = BigDecimal.valueOf(24000);

    // ── CREATE PAYMENT ────────────────────────────────────────
    @Transactional
    public CreatePaymentResponse createPayment(CreatePaymentRequest req, UserPrincipal p) {
        User user = userRepo.findById(p.getUserId())
                .orElseThrow(() -> new NotFoundException("User not found"));

        // Lấy giá từ DB
        SubscriptionPlan plan = planService.getByName(req.getPlan().name());
        BigDecimal amount = BigDecimal.valueOf(plan.getPrice())
                .divide(USD_RATE, 2, RoundingMode.HALF_UP);

        PaymentTransaction tx = txRepo.save(
                PaymentTransaction.builder()
                        .user(user)
                        .amount(amount)
                        .currency("USD")
                        .gateway(req.getGateway())
                        .plan(req.getPlan())
                        .status(TxStatus.PENDING)
                        .build());

        var order = paypal.createOrder(tx.getId().toString(), amount, plan.getName());

        tx.setGatewayRef(order.orderId());
        txRepo.save(tx);

        return CreatePaymentResponse.builder()
                .transactionId(tx.getId().toString())
                .paymentUrl(order.approveUrl())
                .gateway(req.getGateway().name())
                .amount(amount)
                .currency("USD")
                .plan(plan.getName())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    // ── CAPTURE PAYPAL ────────────────────────────────────────
    @Transactional
    public void capturePayPalOrder(String orderId) {

        var resp = paypal.captureOrderDetail(orderId);

        if (!"COMPLETED".equals(resp.status()))
            throw new BadRequestException("Payment not completed: " + resp.status());

        PaymentTransaction tx = txRepo.findByGatewayRef(orderId)
                .orElseThrow(() -> new NotFoundException("Transaction not found"));

        // Chặn double update
        if (tx.getStatus() == TxStatus.SUCCESS) return;

        tx.setStatus(TxStatus.SUCCESS);
        tx.setPaidAt(LocalDateTime.now());
        txRepo.save(tx);

        // Lấy durationDays từ DB để tính endDate chính xác
        SubscriptionPlan plan = planService.getByName(tx.getPlan().name());
        subService.activate(tx.getUser(), plan);
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