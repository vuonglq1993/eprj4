package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Subscription;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SubscriptionRepository extends JpaRepository<Subscription, UUID> {
    Optional<Subscription> findByUserId(UUID userId);

    @Query("SELECT s.plan, COUNT(s) FROM Subscription s WHERE s.status = :status GROUP BY s.plan")
    List<Object[]> countGroupedByPlan(@Param("status") Subscription.SubStatus status);
}
