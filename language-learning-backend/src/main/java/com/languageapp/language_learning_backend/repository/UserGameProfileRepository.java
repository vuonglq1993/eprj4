package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.UserGameProfile;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface UserGameProfileRepository extends JpaRepository<UserGameProfile, UUID> {

    Optional<UserGameProfile> findByUserId(UUID userId);

    // Top 20 theo totalXp (leaderboard all time)
    @Query("SELECT g FROM UserGameProfile g JOIN g.user u WHERE u.isActive = true ORDER BY g.totalXp DESC")
    List<UserGameProfile> findTopAllTime(org.springframework.data.domain.Pageable p);

    // Top 20 theo weeklyXp (leaderboard tuần)
    @Query("SELECT g FROM UserGameProfile g JOIN g.user u WHERE u.isActive = true ORDER BY g.weeklyXp DESC")
    List<UserGameProfile> findTopWeekly(org.springframework.data.domain.Pageable p);

    // Rank của user (all time)
    @Query("SELECT COUNT(g) + 1 FROM UserGameProfile g WHERE g.totalXp > :xp")
    int rankAllTime(@Param("xp") int xp);

    // Rank của user (weekly)
    @Query("SELECT COUNT(g) + 1 FROM UserGameProfile g WHERE g.weeklyXp > :xp")
    int rankWeekly(@Param("xp") int xp);
}
