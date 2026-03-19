package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Lesson;
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

    @Query("SELECT COALESCE(SUM(p.attempts),0) FROM UserProgress p WHERE p.user.id=:uid")
    long sumAttempts(@Param("uid") UUID userId);

    @Query("SELECT COALESCE(AVG(p.score),0) FROM UserProgress p WHERE p.user.id=:uid AND p.status='COMPLETED'")
    double avgScore(@Param("uid") UUID userId);

    @Query("SELECT l.type, AVG(p.score), COUNT(p) FROM UserProgress p JOIN p.lesson l WHERE p.user.id=:uid AND p.status='COMPLETED' GROUP BY l.type")
    List<Object[]> avgScoreByType(@Param("uid") UUID userId);

    @Query("""
        SELECT l FROM Lesson l WHERE l.course.id=:cid
          AND l.id NOT IN (
              SELECT p.lesson.id FROM UserProgress p
              WHERE p.user.id=:uid AND p.status='COMPLETED')
        ORDER BY l.orderIndex ASC
        """)
    Page<Lesson> nextLesson(@Param("uid") UUID userId, @Param("cid") UUID courseId, Pageable p);

    default int calculateProgress(UUID userId, UUID courseId, int total) {
        if (total == 0) return 0;
        return (int)(countCompleted(userId, courseId, ProgressStatus.COMPLETED) * 100 / total);
    }
}
