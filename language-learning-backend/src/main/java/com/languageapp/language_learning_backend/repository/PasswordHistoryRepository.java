package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.PasswordHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface PasswordHistoryRepository extends JpaRepository<PasswordHistory, UUID> {

    @Query("SELECT p FROM PasswordHistory p WHERE p.userId = :userId ORDER BY p.createdAt DESC")
    List<PasswordHistory> findRecentByUserId(UUID userId, org.springframework.data.domain.Pageable pageable);

    @Modifying
    @Query("DELETE FROM PasswordHistory p WHERE p.userId = :userId")
    void deleteByUserId(UUID userId);
}
