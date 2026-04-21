package com.languageapp.language_learning_backend.config;

import com.languageapp.language_learning_backend.entity.SubscriptionPlan;
import com.languageapp.language_learning_backend.repository.SubscriptionPlanRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class SubscriptionPlanSeeder implements ApplicationRunner {

    private final SubscriptionPlanRepository repo;

    @Override
    public void run(ApplicationArguments args) {
        if (repo.count() > 0) return;

        repo.save(SubscriptionPlan.builder()
                .name("FREE")
                .description("Gói miễn phí – 5 bài học mỗi ngày, flashcard cơ bản")
                .price(0)
                .durationDays(36500)
                .isActive(true)
                .build());

        repo.save(SubscriptionPlan.builder()
                .name("MONTHLY")
                .description("Pro Monthly – Không giới hạn bài học, toàn bộ AI features")
                .price(199000)
                .durationDays(30)
                .isActive(true)
                .build());

        repo.save(SubscriptionPlan.builder()
                .name("THREE_MONTHS")
                .description("Pro 3 tháng – Tiết kiệm 20% so với gói tháng")
                .price(479000)
                .durationDays(90)
                .isActive(true)
                .build());

        repo.save(SubscriptionPlan.builder()
                .name("YEARLY")
                .description("Pro Yearly – Tiết kiệm 40%, ưu tiên hỗ trợ & tính năng mới")
                .price(1390000)
                .durationDays(365)
                .isActive(true)
                .build());

        log.info("Subscription plans seeded.");
    }
}
