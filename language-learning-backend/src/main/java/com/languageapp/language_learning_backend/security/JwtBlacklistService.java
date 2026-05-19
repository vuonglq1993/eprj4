package com.languageapp.language_learning_backend.security;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class JwtBlacklistService {

    private final RedisTemplate<String, String> redisTemplate;

    private static final String PREFIX = "blacklist:token:";

    public void blacklist(String jti, long remainingSeconds) {
        try {
            redisTemplate.opsForValue().set(PREFIX + jti, "1", remainingSeconds, TimeUnit.SECONDS);
        } catch (Exception e) {
            log.warn("Redis unavailable, token blacklist skipped: {}", e.getMessage());
        }
    }

    public boolean isBlacklisted(String jti) {
        try {
            return Boolean.TRUE.equals(redisTemplate.hasKey(PREFIX + jti));
        } catch (Exception e) {
            log.warn("Redis unavailable, blacklist check skipped: {}", e.getMessage());
            return false;
        }
    }
}
