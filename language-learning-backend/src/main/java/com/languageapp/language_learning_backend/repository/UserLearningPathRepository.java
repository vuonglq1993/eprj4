package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.UserLearningPath;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;
import java.util.*;

@Repository
public interface UserLearningPathRepository extends JpaRepository<UserLearningPath, UUID> {

    Optional<UserLearningPath> findByUserIdAndLearningPathId(UUID userId, UUID learningPathId);

    List<UserLearningPath> findByUserIdOrderByUpdatedAtDesc(UUID userId);

    boolean existsByUserIdAndLearningPathId(UUID userId, UUID learningPathId);
}
