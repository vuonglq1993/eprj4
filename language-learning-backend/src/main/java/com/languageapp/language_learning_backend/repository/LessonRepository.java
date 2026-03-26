package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Lesson;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, UUID> {

    List<Lesson> findByCourseIdOrderByOrderIndexAsc(UUID courseId);

    @Query("""
        SELECT l FROM Lesson l
        WHERE l.course.id = :courseId
          AND (l.isFree = true OR :premium = true)
        ORDER BY l.orderIndex ASC
        """)
    List<Lesson> findAccessible(@Param("courseId") UUID courseId,
                                @Param("premium")  boolean premium);

    @Query("SELECT COALESCE(MAX(l.orderIndex), -1) FROM Lesson l WHERE l.course.id = :courseId")
    Integer maxOrderIndex(@Param("courseId") UUID courseId);

    @Query("SELECT COUNT(e) FROM Exercise e WHERE e.lesson.id = :lessonId")
    int countExercises(@Param("lessonId") UUID lessonId);
}

