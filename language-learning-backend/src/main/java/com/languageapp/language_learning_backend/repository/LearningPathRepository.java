package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.LearningPath;
import com.languageapp.language_learning_backend.entity.LearningPath.TargetLevel;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface LearningPathRepository extends JpaRepository<LearningPath, UUID> {

    @Query("""
        SELECT lp FROM LearningPath lp
        JOIN FETCH lp.language l
        WHERE lp.isPublished = true
          AND (:languageId  IS NULL OR l.id           = :languageId)
          AND (:targetLevel IS NULL OR lp.targetLevel = :targetLevel)
          AND (:kw          IS NULL OR LOWER(lp.title) LIKE LOWER(CONCAT('%',:kw,'%')))
        ORDER BY lp.isOfficial DESC, lp.createdAt DESC
        """)
    Page<LearningPath> findPublished(@Param("languageId")  UUID languageId,
                                     @Param("targetLevel") TargetLevel targetLevel,
                                     @Param("kw")          String kw,
                                     Pageable pageable);

    @Query("SELECT lp FROM LearningPath lp WHERE lp.createdBy.id = :userId")
    List<LearningPath> findByCreatedById(@Param("userId") UUID userId);
}
