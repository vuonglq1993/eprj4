package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.UserBadge;
import com.languageapp.language_learning_backend.entity.UserBadge.BadgeType;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface UserBadgeRepository extends JpaRepository<UserBadge, UUID> {

    List<UserBadge> findByUserIdOrderByEarnedAtDesc(UUID userId);

    boolean existsByUserIdAndBadgeType(UUID userId, BadgeType badgeType);

    void deleteByUserId(UUID userId);
}
