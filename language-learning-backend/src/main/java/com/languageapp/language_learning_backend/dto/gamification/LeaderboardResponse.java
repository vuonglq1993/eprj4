package com.languageapp.language_learning_backend.dto.gamification;

import lombok.*;
import java.util.List;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LeaderboardResponse {
    private List<LeaderboardEntry> weekly;
    private List<LeaderboardEntry> allTime;
    private LeaderboardEntry       myRank;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class LeaderboardEntry {
        private Integer rank;
        private UUID    userId;
        private String  userName;
        private String  avatarUrl;
        private Integer xp;
        private Integer level;
        private String  levelTitle;
    }
}
