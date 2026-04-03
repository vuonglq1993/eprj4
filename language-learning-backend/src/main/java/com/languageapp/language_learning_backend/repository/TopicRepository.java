package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Topic;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.UUID;

@Repository
public interface TopicRepository extends JpaRepository<Topic, UUID> {

    List<Topic> findByIsActiveTrueOrderByOrderIndexAsc();

    boolean existsByNameIgnoreCase(String name);

    @Query("""
        SELECT t, COUNT(c) FROM Topic t
        LEFT JOIN t.courses c ON c.isPublished = true
        WHERE t.isActive = true
        GROUP BY t
        ORDER BY t.orderIndex ASC
        """)
    List<Object[]> findActiveWithCourseCount();
}
