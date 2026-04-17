package com.languageapp.language_learning_backend.dto.gamification;

import lombok.*;
import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class XpEarnedResponse {
    private Integer           xpEarned;
    private Integer           totalXp;
    private Integer           level;
    private Boolean           leveledUp;
    private Integer           newLevel;
    private String            levelTitle;
    private List<BadgeResponse> newBadges;
}
