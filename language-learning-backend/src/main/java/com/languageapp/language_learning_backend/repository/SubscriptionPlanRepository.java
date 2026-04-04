package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.SubscriptionPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SubscriptionPlanRepository extends JpaRepository<SubscriptionPlan, UUID> {

    List<SubscriptionPlan> findByIsActiveTrueOrderByPriceAsc();

    Optional<SubscriptionPlan> findByNameIgnoreCase(String name);
}