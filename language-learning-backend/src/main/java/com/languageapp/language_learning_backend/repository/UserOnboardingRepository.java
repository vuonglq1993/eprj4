package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.UserOnboarding;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserOnboardingRepository extends JpaRepository<UserOnboarding, UUID> {
    Optional<UserOnboarding> findByUserId(UUID userId);
    boolean existsByUserId(UUID userId);
}
