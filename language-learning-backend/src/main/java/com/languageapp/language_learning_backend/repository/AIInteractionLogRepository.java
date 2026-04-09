package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.AIInteractionLog;
import com.languageapp.language_learning_backend.entity.AIInteractionLog.InteractionType;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface AIInteractionLogRepository extends JpaRepository<AIInteractionLog, UUID> {

    /**
     * Đếm số lần user dùng một feature AI trong ngày — dùng cho rate limiting (thay Redis).
     * Chỉ đếm SUCCESS để tránh tính nhầm lỗi mạng vào quota.
     */
    @Query("""
    SELECT COUNT(l)
    FROM AIInteractionLog l
    WHERE l.user.id = :userId
      AND l.interactionType = :type
      AND l.status = :status
      AND l.createdAt >= :start
      AND l.createdAt < :end
""")
    long countTodayByUserAndType(
            @Param("userId") UUID userId,
            @Param("type") InteractionType type,
            @Param("status") AIInteractionLog.AIStatus status,
            @Param("start") Instant start,
            @Param("end") Instant end);
    /** Tổng cost AI trong khoảng thời gian — dùng cho admin dashboard */
    @Query("""
        SELECT COALESCE(SUM(l.cost), 0)
        FROM AIInteractionLog l
        WHERE CAST(l.createdAt AS localdate) BETWEEN :from AND :to
    """)
    BigDecimal sumCostBetween(@Param("from") LocalDate from, @Param("to") LocalDate to);

    /** Lịch sử AI chat của user trong 1 lesson — để khôi phục conversation */
    @Query("""
    SELECT l FROM AIInteractionLog l
    WHERE l.user.id = :userId
      AND l.lessonId = :lessonId
      AND l.interactionType = :type
      AND l.status = :status
    ORDER BY l.createdAt ASC
""")
    List<AIInteractionLog> findChatHistory(
            @Param("userId") UUID userId,
            @Param("lessonId") UUID lessonId,
            @Param("type") InteractionType type,
            @Param("status") AIInteractionLog.AIStatus status);
}