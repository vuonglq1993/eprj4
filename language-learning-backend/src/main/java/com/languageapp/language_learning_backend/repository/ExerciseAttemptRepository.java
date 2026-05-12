package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.ExerciseAttempt;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ExerciseAttemptRepository extends JpaRepository<ExerciseAttempt, UUID> {

    void deleteByUserId(UUID userId);

    // ✅ Lấy danh sách bài làm sai
    @Query("""
        SELECT a FROM ExerciseAttempt a
        JOIN FETCH a.exercise e
        JOIN FETCH e.lesson l
        JOIN FETCH l.course c
        WHERE a.user.id = :uid
          AND a.isCorrect = false
        ORDER BY a.submittedAt DESC
    """)
    List<ExerciseAttempt> findMistakesByUser(
            @Param("uid") UUID uid,
            Pageable pageable
    );

    // ✅ COUNT GROUP
    @Query("""
        SELECT a.exercise.id, COUNT(a)
        FROM ExerciseAttempt a
        WHERE a.user.id = :uid AND a.isCorrect = false
        GROUP BY a.exercise.id
    """)
    List<Object[]> countWrongGrouped(@Param("uid") UUID uid);
}