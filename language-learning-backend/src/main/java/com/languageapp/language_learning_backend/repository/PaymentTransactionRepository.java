package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.PaymentTransaction;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, UUID> {
    Page<PaymentTransaction> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable p);
    Optional<PaymentTransaction> findByGatewayRef(String gatewayRef);
    void deleteByUserId(UUID userId);
}