package com.languageapp.language_learning_backend.dto.gamification;

import com.languageapp.language_learning_backend.entity.UserBadge.BadgeType;
import lombok.*;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

// ── GameProfileResponse ──────────────────────────────────────
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class GameProfileResponse {
    private UUID    userId;
    private String  userName;
    private String  avatarUrl;
    private Integer totalXp;
    private Integer level;
    private Integer weeklyXp;
    private String  levelTitle;          // "Beginner", "Explorer"...
    private Integer xpToNextLevel;       // XP cần để lên level tiếp
    private Integer xpCurrentLevel;      // XP đã có trong level này
    private Integer progressPercent;     // % tiến độ trong level hiện tại
    private List<BadgeResponse> badges;
}
