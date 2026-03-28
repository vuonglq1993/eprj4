package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.ExerciseAttempt;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ExerciseAttemptRepository extends JpaRepository<ExerciseAttempt, UUID> {
}