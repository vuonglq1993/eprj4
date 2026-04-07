package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Lesson;
import com.languageapp.language_learning_backend.entity.Lesson.AccessTier;
import com.languageapp.language_learning_backend.entity.UserProgress;
import com.languageapp.language_learning_backend.entity.UserProgress.ProgressStatus;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface UserProgressRepository extends JpaRepository<UserProgress, UUID> {

    Optional<UserProgress> findByUserIdAndLessonId(UUID userId, UUID lessonId);

    List<UserProgress> findByUserIdAndCourseId(UUID userId, UUID courseId);

    List<UserProgress> findByUserId(UUID userId);

    @Query("SELECT COUNT(p) FROM UserProgress p WHERE p.user.id=:uid AND p.course.id=:cid AND p.status=:s")
    long countCompleted(@Param("uid") UUID userId, @Param("cid") UUID courseId, @Param("s") ProgressStatus s);

    @Query("""
        SELECT COUNT(p) FROM UserProgress p
        WHERE p.user.id = :uid
          AND p.course.id = :cid
          AND p.status = 'COMPLETED'
          AND (p.lesson.isFree = true OR p.lesson.accessTier IN :tiers)
        """)
    long countCompletedAccessible(@Param("uid") UUID userId,
                                  @Param("cid") UUID courseId,
                                  @Param("tiers") Collection<AccessTier> tiers);

    @Query("""
    SELECT l FROM Lesson l
    WHERE l.course.id = :cid
      AND (l.isFree = true OR l.accessTier IN :tiers)
      AND NOT EXISTS (
          SELECT 1 FROM UserProgress p
          WHERE p.lesson.id = l.id
            AND p.user.id = :uid
            AND p.status = 'COMPLETED'
      )
    ORDER BY l.orderIndex ASC
    """)
    Page<Lesson> nextAccessibleLesson(@Param("uid") UUID userId,
                                      @Param("cid") UUID courseId,
                                      @Param("tiers") Collection<AccessTier> tiers,
                                      Pageable pageable);

    @Query("""
        SELECT p.lesson FROM UserProgress p
        WHERE p.user.id = :uid
          AND p.course.id = :cid
          AND p.status = 'IN_PROGRESS'
        ORDER BY p.updatedAt DESC
        """)
    Page<Lesson> currentLesson(@Param("uid") UUID userId,
                               @Param("cid") UUID courseId,
                               Pageable p);

    @Query("SELECT COALESCE(SUM(p.attempts),0) FROM UserProgress p WHERE p.user.id=:uid")
    long sumAttempts(@Param("uid") UUID userId);

    @Query("SELECT COALESCE(AVG(p.score),0) FROM UserProgress p WHERE p.user.id=:uid AND p.status='COMPLETED'")
    double avgScore(@Param("uid") UUID userId);

    @Query("SELECT l.type, AVG(p.score), COUNT(p) FROM UserProgress p JOIN p.lesson l WHERE p.user.id=:uid AND p.status='COMPLETED' GROUP BY l.type")
    List<Object[]> avgScoreByType(@Param("uid") UUID userId);

    // ❌ DEPRECATED – ĐỪNG DÙNG NỮA
    default int calculateProgress(UUID userId, UUID courseId, int total) {
        if (total == 0) return 0;
        return (int)(countCompleted(userId, courseId, ProgressStatus.COMPLETED) * 100 / total);
    }
}
