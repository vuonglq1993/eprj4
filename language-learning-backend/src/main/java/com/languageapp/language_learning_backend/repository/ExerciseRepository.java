package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Exercise;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, UUID> {

    List<Exercise> findByLessonIdOrderByOrderIndexAsc(UUID lessonId);

    @Query("SELECT COUNT(e) FROM Exercise e WHERE e.lesson.id = :lessonId")
    int countByLesson(@Param("lessonId") UUID lessonId);
    @Query("SELECT SUM(e.points) FROM Exercise e WHERE e.lesson.id = :lessonId")
    Integer sumPointsByLessonId(UUID lessonId);

}
