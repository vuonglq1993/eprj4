package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.entity.UserGameProfile;
import com.languageapp.language_learning_backend.repository.UserGameProfileRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class LeaderboardService {

    private final RedisTemplate<String, String> redisTemplate;
    private final UserGameProfileRepository gameRepo;

    public static final String KEY_WEEKLY  = "leaderboard:weekly";
    public static final String KEY_ALLTIME = "leaderboard:alltime";
    private static final String KEY_USERINFO_PREFIX = "leaderboard:userinfo:";

    public record Entry(UUID userId, String displayName, String avatarUrl, long score, int totalXp) {}

    public void updateScore(UUID userId, String displayName, String avatarUrl, long xpDelta, int currentTotalXp) {
        try {
            redisTemplate.opsForZSet().incrementScore(KEY_WEEKLY,  userId.toString(), xpDelta);
            redisTemplate.opsForZSet().incrementScore(KEY_ALLTIME, userId.toString(), xpDelta);
            String infoKey = KEY_USERINFO_PREFIX + userId;
            redisTemplate.opsForHash().put(infoKey, "displayName", displayName != null ? displayName : "");
            redisTemplate.opsForHash().put(infoKey, "avatarUrl",   avatarUrl   != null ? avatarUrl   : "");
            redisTemplate.opsForHash().put(infoKey, "totalXp",     String.valueOf(currentTotalXp));
        } catch (Exception e) {
            log.warn("Redis unavailable for leaderboard update: {}", e.getMessage());
        }
    }

    public List<Entry> getTop(String key, int limit) {
        try {
            Set<ZSetOperations.TypedTuple<String>> tuples =
                    redisTemplate.opsForZSet().reverseRangeWithScores(key, 0, limit - 1);
            if (tuples == null || tuples.isEmpty()) return List.of();
            return tuples.stream().map(t -> {
                String uid   = t.getValue();
                long score   = t.getScore() != null ? t.getScore().longValue() : 0;
                Map<Object, Object> info = redisTemplate.opsForHash().entries(KEY_USERINFO_PREFIX + uid);
                String displayName = (String) info.getOrDefault("displayName", "");
                String avatarUrl   = (String) info.getOrDefault("avatarUrl",   "");
                String totalXpStr  = (String) info.get("totalXp");
                int totalXp = totalXpStr != null ? Integer.parseInt(totalXpStr) : (int) score;
                return new Entry(UUID.fromString(uid), displayName, avatarUrl, score, totalXp);
            }).toList();
        } catch (Exception e) {
            log.warn("Redis unavailable for leaderboard getTop: {}", e.getMessage());
            return List.of();
        }
    }

    public long getRank(String key, UUID userId) {
        try {
            Long rank = redisTemplate.opsForZSet().reverseRank(key, userId.toString());
            return rank != null ? rank + 1 : -1;
        } catch (Exception e) {
            log.warn("Redis unavailable for leaderboard getRank: {}", e.getMessage());
            return -1;
        }
    }

    @Scheduled(cron = "0 0 0 * * MON", zone = "Asia/Ho_Chi_Minh")
    public void resetWeeklyLeaderboard() {
        try {
            redisTemplate.delete(KEY_WEEKLY);
            log.info("Weekly leaderboard reset");
        } catch (Exception e) {
            log.warn("Failed to reset weekly leaderboard: {}", e.getMessage());
        }
    }

    @EventListener(ApplicationReadyEvent.class)
    public void warmUp() {
        try {
            if (Boolean.TRUE.equals(redisTemplate.hasKey(KEY_ALLTIME))
                    && Boolean.TRUE.equals(redisTemplate.hasKey(KEY_WEEKLY))) return;

            log.info("Warming up leaderboard from DB...");
            List<UserGameProfile> top100 = gameRepo.findTopAllTime(PageRequest.of(0, 100));
            for (UserGameProfile g : top100) {
                String uid    = g.getUser().getId().toString();
                String name   = g.getUser().getFullName();
                String avatar = g.getUser().getAvatarUrl();
                redisTemplate.opsForZSet().add(KEY_ALLTIME, uid, g.getTotalXp());
                redisTemplate.opsForZSet().add(KEY_WEEKLY,  uid, g.getWeeklyXp());
                String infoKey = KEY_USERINFO_PREFIX + uid;
                redisTemplate.opsForHash().put(infoKey, "displayName", name   != null ? name   : "");
                redisTemplate.opsForHash().put(infoKey, "avatarUrl",   avatar != null ? avatar : "");
                redisTemplate.opsForHash().put(infoKey, "totalXp",     String.valueOf(g.getTotalXp()));
            }
            log.info("Leaderboard warm-up done ({} entries)", top100.size());
        } catch (Exception e) {
            log.warn("Leaderboard warm-up failed (Redis may be down): {}", e.getMessage());
        }
    }
}
