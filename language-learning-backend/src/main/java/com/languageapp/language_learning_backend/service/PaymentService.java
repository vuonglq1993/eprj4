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
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PayPalClient paypal;
    private final PaymentTransactionRepository txRepo;
    private final UserRepository userRepo;
    private final SubscriptionService subService;

    private static final BigDecimal M_USD = new BigDecimal("4.99");
    private static final BigDecimal Y_USD = new BigDecimal("39.99");

    @Transactional
    public CreatePaymentResponse createPayment(CreatePaymentRequest req, UserPrincipal p) {

        User user = userRepo.findById(p.getUserId())
                .orElseThrow(() -> new NotFoundException("User not found"));

        BigDecimal amount = req.getPlan() == Plan.MONTHLY ? M_USD : Y_USD;

        PaymentTransaction tx = txRepo.save(
                PaymentTransaction.builder()
                        .user(user)
                        .amount(amount)
                        .currency("USD")
                        .gateway(req.getGateway())
                        .plan(req.getPlan())
                        .status(TxStatus.PENDING)
                        .build()
        );

        var order = paypal.createOrder(tx.getId().toString(), amount, "LinguaNext");

        tx.setGatewayRef(order.orderId());
        txRepo.save(tx);

        return CreatePaymentResponse.builder()
                .transactionId(tx.getId().toString())
                .paymentUrl(order.approveUrl())
                .gateway(req.getGateway().name())
                .amount(amount)
                .currency("USD")
                .plan(req.getPlan().name())
                .expiredAt(LocalDateTime.now().plusMinutes(15))
                .build();
    }

    @Transactional
    public void capturePayPalOrder(String orderId) {

        var resp = paypal.captureOrderDetail(orderId);

        // 👉 Nếu đã capture rồi thì vẫn OK
        if (!"COMPLETED".equals(resp.status())) {
            throw new BadRequestException("Payment not completed: " + resp.status());
        }

        PaymentTransaction tx = txRepo.findByGatewayRef(orderId)
                .orElseThrow(() -> new NotFoundException("Transaction not found"));

        // ✅ CHẶN double update
        if (tx.getStatus() == TxStatus.SUCCESS) return;

        tx.setStatus(TxStatus.SUCCESS);
        tx.setGatewayRef(orderId);
        tx.setPaidAt(LocalDateTime.now());

        txRepo.save(tx);

        subService.activate(tx.getUser(), tx.getPlan());
    }
    @Transactional(readOnly = true)
    public List<PaymentHistoryResponse> getHistory(UserPrincipal p) {
        return txRepo.findByUserIdOrderByCreatedAtDesc(p.getUserId(), PageRequest.of(0, 20))
                .getContent()
                .stream()
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
}