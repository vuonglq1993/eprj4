package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.SubscriptionPlan;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface SubscriptionPlanRepository extends JpaRepository<SubscriptionPlan, UUID> {
}