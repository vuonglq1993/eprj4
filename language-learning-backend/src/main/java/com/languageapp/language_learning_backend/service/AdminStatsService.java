package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.entity.PaymentTransaction;
import com.languageapp.language_learning_backend.entity.Subscription;
import com.languageapp.language_learning_backend.repository.PaymentTransactionRepository;
import com.languageapp.language_learning_backend.repository.StudyLogRepository;
import com.languageapp.language_learning_backend.repository.SubscriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AdminStatsService {

    private final StudyLogRepository studyLogRepo;
    private final SubscriptionRepository subRepo;
    private final PaymentTransactionRepository paymentRepo;

    private static final ZoneId VN = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ISO_LOCAL_DATE;

    public record DailyActiveResponse(List<String> labels, List<Long> counts) {}

    public record SubscriptionBreakdownResponse(
            long total, long free, long monthly, long threeMonths, long yearly,
            double monthlyRevenue) {}

    public DailyActiveResponse getDailyActive(int days) {
        LocalDate today = LocalDate.now(VN);
        LocalDate since = today.minusDays(days - 1);

        List<Object[]> rows = studyLogRepo.countDailyActiveUsers(since);
        Map<LocalDate, Long> byDate = new LinkedHashMap<>();
        for (Object[] r : rows) {
            byDate.put((LocalDate) r[0], ((Number) r[1]).longValue());
        }

        List<String> labels = new ArrayList<>(days);
        List<Long> counts = new ArrayList<>(days);
        for (int i = 0; i < days; i++) {
            LocalDate d = since.plusDays(i);
            labels.add(d.format(DATE_FMT));
            counts.add(byDate.getOrDefault(d, 0L));
        }
        return new DailyActiveResponse(labels, counts);
    }

    public SubscriptionBreakdownResponse getSubscriptionBreakdown() {
        List<Object[]> rows = subRepo.countGroupedByPlan(Subscription.SubStatus.ACTIVE);

        long free = 0, monthly = 0, threeMonths = 0, yearly = 0;
        for (Object[] r : rows) {
            Subscription.Plan plan = (Subscription.Plan) r[0];
            long cnt = ((Number) r[1]).longValue();
            switch (plan) {
                case FREE         -> free = cnt;
                case MONTHLY      -> monthly = cnt;
                case THREE_MONTHS -> threeMonths = cnt;
                case YEARLY       -> yearly = cnt;
            }
        }

        ZonedDateTime startOfMonth = YearMonth.now(VN).atDay(1).atStartOfDay(VN);
        ZonedDateTime startOfNext  = startOfMonth.plusMonths(1);
        BigDecimal revenue = paymentRepo.sumRevenue(
                PaymentTransaction.TxStatus.SUCCESS,
                startOfMonth.toInstant(),
                startOfNext.toInstant());

        return new SubscriptionBreakdownResponse(
                free + monthly + threeMonths + yearly,
                free, monthly, threeMonths, yearly,
                revenue == null ? 0.0 : revenue.doubleValue());
    }
}
