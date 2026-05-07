package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.User;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.*;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);
    boolean        existsByEmail(String email);
    Optional<User> findByProviderAndProviderId(User.AuthProvider provider, String providerId);

    @Query("SELECT COUNT(u) FROM User u WHERE u.isActive = true")
    long countActiveUsers();

    List<User> findByEmailContainingIgnoreCase(String email);

    // Lấy user có streak hôm qua nhưng chưa học hôm nay → gửi reminder
    @Query("""
        SELECT u.email, u.firstName, COUNT(DISTINCT s.studyDate)
        FROM User u
        JOIN StudyLog s ON s.user.id = u.id AND s.studyDate = :yesterday
        WHERE u.isActive = true AND u.emailVerified = true
          AND NOT EXISTS (
              SELECT 1 FROM StudyLog s2
              WHERE s2.user.id = u.id AND s2.studyDate = :today )
        GROUP BY u.id, u.email, u.firstName
        """)
    List<Object[]> findUsersToRemind(@Param("today") LocalDate today,
                                     @Param("yesterday") LocalDate yesterday);
}
