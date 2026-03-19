package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Course;
import com.languageapp.language_learning_backend.entity.Course.Level;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.UUID;

@Repository
public interface CourseRepository extends JpaRepository<Course, UUID> {

    @Query("""
        SELECT c FROM Course c JOIN FETCH c.language l
        WHERE c.isPublished = true
          AND (:languageId IS NULL OR l.id        = :languageId)
          AND (:level      IS NULL OR c.level     = :level)
          AND (:kw         IS NULL OR LOWER(c.title) LIKE LOWER(CONCAT('%',:kw,'%')))
        ORDER BY c.createdAt DESC
        """)
    Page<Course> findPublished(@Param("languageId") UUID languageId,
                               @Param("level")      Level level,
                               @Param("kw")         String kw,
                               Pageable pageable);

    @Query("""
        SELECT c FROM Course c
        WHERE (:teacherId IS NULL OR c.createdBy.id = :teacherId)
          AND (:kw        IS NULL OR LOWER(c.title) LIKE LOWER(CONCAT('%',:kw,'%')))
        ORDER BY c.createdAt DESC
        """)
    Page<Course> findForAdmin(@Param("teacherId") UUID teacherId,
                              @Param("kw")        String kw,
                              Pageable pageable);

    boolean existsByIdAndCreatedById(UUID courseId, UUID userId);
}
