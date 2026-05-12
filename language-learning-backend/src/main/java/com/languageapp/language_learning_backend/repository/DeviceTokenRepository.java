package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.DeviceToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.*;

public interface DeviceTokenRepository extends JpaRepository<DeviceToken, Long> {

    List<DeviceToken> findByUserId(UUID userId);

    Optional<DeviceToken> findByToken(String token);
    void deleteByUserId(UUID userId);
}