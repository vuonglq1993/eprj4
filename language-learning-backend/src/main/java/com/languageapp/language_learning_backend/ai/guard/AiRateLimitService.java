package com.languageapp.language_learning_backend.ai.guard;

import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.TooManyRequestsException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.*;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiRateLimitService {

    private final RedisTemplate<String, String> redisTemplate;

    private static final ZoneId VN_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    /**
     * Tăng counter cho userId+aiType hôm nay.
     * Nếu vượt dailyLimit → throw TooManyRequestsException.
     * Nếu Redis down → fallback cho qua (không crash app).
     */
    public void checkAndIncrement(UUID userId, String aiType, int dailyLimit) {
        String date = LocalDate.now(VN_ZONE).toString();
        String key  = "ai:limit:" + userId + ":" + aiType + ":" + date;

        try {
            Long count = redisTemplate.opsForValue().increment(key);
            if (count == 1) {
                redisTemplate.expire(key, secondsUntilMidnight(), TimeUnit.SECONDS);
            }
            if (count != null && count > dailyLimit) {
                throw new TooManyRequestsException(
                        "Đã đạt giới hạn " + dailyLimit + " lần/ngày cho " + aiType);
            }
        } catch (TooManyRequestsException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Redis unavailable for AI rate limit, allowing request: {}", e.getMessage());
        }
    }

    private long secondsUntilMidnight() {
        ZonedDateTime now      = ZonedDateTime.now(VN_ZONE);
        ZonedDateTime midnight = now.toLocalDate().plusDays(1).atStartOfDay(VN_ZONE);
        return midnight.toEpochSecond() - now.toEpochSecond();
    }
}
