package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Lesson;
import com.languageapp.language_learning_backend.entity.Lesson.AccessTier;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, UUID> {

    List<Lesson> findByCourseIdOrderByOrderIndexAsc(UUID courseId);

    @Query("""
        SELECT COUNT(l) FROM Lesson l
        WHERE l.course.id = :cid
          AND (l.isFree = true OR l.accessTier IN :tiers)
        """)
    long countAccessible(UUID cid, Collection<AccessTier> tiers);

    @Query("SELECT COALESCE(MAX(l.orderIndex), -1) FROM Lesson l WHERE l.course.id = :courseId")
    Integer maxOrderIndex(@Param("courseId") UUID courseId);

    @Query("SELECT COUNT(e) FROM Exercise e WHERE e.lesson.id = :lessonId")
    int countExercises(@Param("lessonId") UUID lessonId);
}

