package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.PaymentTransaction;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, UUID> {
    Page<PaymentTransaction> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable p);
    Optional<PaymentTransaction> findByGatewayRef(String gatewayRef);
    void deleteByUserId(UUID userId);

    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM PaymentTransaction t WHERE t.status = :status AND t.paidAt >= :from AND t.paidAt < :to")
    BigDecimal sumRevenue(@Param("status") PaymentTransaction.TxStatus status, @Param("from") Instant from, @Param("to") Instant to);

    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM PaymentTransaction t WHERE t.status = :status")
    BigDecimal sumRevenueAllTime(@Param("status") PaymentTransaction.TxStatus status);
}