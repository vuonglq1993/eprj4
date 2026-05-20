package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.subscription.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.Subscription.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class SubscriptionService {

    private final SubscriptionRepository subRepo;
    private final UserRepository userRepo;

    // ── GET STATUS ────────────────────────────────────────────
    @Transactional(readOnly = true)
    public SubscriptionStatusResponse getStatus(UserPrincipal p) {

        Subscription sub = subRepo.findByUserId(p.getUserId()).orElse(null);

        if (sub == null) {
            return SubscriptionStatusResponse.builder()
                    .plan("FREE")
                    .status("ACTIVE")
                    .isPremium(false)
                    .daysRemaining(0)
                    .build();
        }

        long days = (sub.getEndDate() != null)
                ? Math.max(0, ChronoUnit.DAYS.between(Instant.now(), sub.getEndDate()))
                : 0;

        return SubscriptionStatusResponse.builder()
                .plan(sub.getPlan().name())
                .status(sub.getStatus().name())
                .startDate(sub.getStartDate())
                .endDate(sub.getEndDate())
                .autoRenew(sub.getAutoRenew())
                .isPremium(sub.isPremium())
                .daysRemaining(days)
                .build();
    }

    // Thứ tự ưu tiên gói: số càng cao càng cao cấp
    private static final Map<Plan, Integer> PLAN_RANK = Map.of(
            Plan.FREE,         0,
            Plan.MONTHLY,      1,
            Plan.THREE_MONTHS, 2,
            Plan.YEARLY,       3
    );

    // ── ACTIVATE ──────────────────────────────────────────────
    @Transactional
    public void activate(User user, SubscriptionPlan plan) {

        Subscription sub = subRepo.findByUserId(user.getId())
                .orElse(Subscription.builder().user(user).build());

        Instant now = Instant.now();

        Subscription.Plan enumPlan;
        try {
            enumPlan = Subscription.Plan.valueOf(plan.getName());
        } catch (Exception e) {
            enumPlan = Subscription.Plan.MONTHLY;
        }

        // Chặn downgrade: nếu đang còn hạn và gói mới thấp hơn gói hiện tại
        boolean stillActive = sub.getEndDate() != null && sub.getEndDate().isAfter(now);
        if (stillActive && sub.getPlan() != null) {
            int currentRank = PLAN_RANK.getOrDefault(sub.getPlan(), 0);
            int newRank     = PLAN_RANK.getOrDefault(enumPlan, 0);
            if (newRank < currentRank) {
                throw new BadRequestException(
                        "Cannot downgrade from " + sub.getPlan().name() +
                        " to " + enumPlan.name() + " while subscription is still active");
            }
        }

        // Nếu còn hạn thì nối tiếp (chỉ khi upgrade hoặc cùng gói)
        Instant start = stillActive ? sub.getEndDate() : now;
        Instant end   = start.plus(plan.getDurationDays(), ChronoUnit.DAYS);

        sub.setPlan(enumPlan);
        sub.setStatus(SubStatus.ACTIVE);
        sub.setStartDate(stillActive ? sub.getStartDate() : now);
        sub.setEndDate(end);

        subRepo.save(sub);

        log.info("Subscription activated: userId={} plan={} durationDays={} until={}",
                user.getId(), enumPlan, plan.getDurationDays(), end);
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