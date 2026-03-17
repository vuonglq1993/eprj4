package com.languageapp.language_learning_backend.repository;
import com.languageapp.language_learning_backend.entity.Language;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface LanguageRepository extends JpaRepository<Language, UUID> {

    Optional<Language> findByCode(String code);
    boolean            existsByCode(String code);
    List<Language>     findByIsActiveTrueOrderByNameAsc();

    @Query("""
        SELECT l, COUNT(c)
        FROM Language l LEFT JOIN l.courses c ON c.isPublished = true
        WHERE l.isActive = true
        GROUP BY l ORDER BY l.name ASC
        """)
    List<Object[]> findActiveWithCourseCount();
}
