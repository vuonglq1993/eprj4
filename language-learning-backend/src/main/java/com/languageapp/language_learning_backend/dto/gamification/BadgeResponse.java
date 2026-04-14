package com.languageapp.language_learning_backend.dto.gamification;

import com.languageapp.language_learning_backend.entity.UserBadge.BadgeType;
import lombok.*;
import java.time.Instant;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class BadgeResponse {
    private BadgeType badgeType;
    private String    name;
    private String    description;
    private String    iconUrl;
    private Instant   earnedAt;
}
