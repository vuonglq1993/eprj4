package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.subscription.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Subscription.*;
import com.languageapp.language_learning_backend.entity.PaymentTransaction.Plan;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.*;
import java.time.temporal.ChronoUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class SubscriptionService {

    private final SubscriptionRepository subRepo;
    private final UserRepository         userRepo;

    // ── GET STATUS ────────────────────────────────────────────
    @Transactional(readOnly = true)
    public SubscriptionStatusResponse getStatus(UserPrincipal p) {
        Subscription sub = subRepo.findByUserId(p.getUserId()).orElse(null);
        if (sub == null)
            return SubscriptionStatusResponse.builder()
                    .plan("FREE").status("ACTIVE").isPremium(false).daysRemaining(0).build();

        long days = (sub.getEndDate() != null)
                ? Math.max(0, ChronoUnit.DAYS.between(LocalDateTime.now(), sub.getEndDate())) : 0;

        return SubscriptionStatusResponse.builder()
                .plan(sub.getPlan().name()).status(sub.getStatus().name())
                .startDate(sub.getStartDate()).endDate(sub.getEndDate())
                .autoRenew(sub.getAutoRenew()).isPremium(sub.isPremium())
                .daysRemaining(days).build();
    }

    // ── ACTIVATE (gọi từ PaymentService sau khi thanh toán thành công) ──
    @Transactional
    public void activate(User user, Plan txPlan) {
        Subscription sub = subRepo.findByUserId(user.getId())
                .orElse(Subscription.builder().user(user).build());

        Subscription.Plan plan = (txPlan == Plan.MONTHLY) ? Subscription.Plan.MONTHLY : Subscription.Plan.YEARLY;
        LocalDateTime now      = LocalDateTime.now();
        LocalDateTime start    = (sub.getEndDate() != null && sub.getEndDate().isAfter(now))
                ? sub.getEndDate() : now;   // nối tiếp nếu còn hạn

        sub.setPlan(plan);
        sub.setStatus(SubStatus.ACTIVE);
        sub.setStartDate(start);
        sub.setEndDate(txPlan == Plan.MONTHLY ? start.plusMonths(1) : start.plusYears(1));
        subRepo.save(sub);
        log.info("Subscription activated: userId={} plan={} until={}", user.getId(), plan, sub.getEndDate());
    }

    // ── CANCEL ────────────────────────────────────────────────
    @Transactional
    public void cancel(UserPrincipal p) {
        subRepo.findByUserId(p.getUserId()).ifPresent(sub -> {
            sub.setAutoRenew(false);
            sub.setStatus(SubStatus.CANCELLED);
            subRepo.save(sub);
        });
    }
}
