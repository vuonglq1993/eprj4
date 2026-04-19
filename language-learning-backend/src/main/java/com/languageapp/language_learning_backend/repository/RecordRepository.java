package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.Record;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.*;

public interface RecordRepository extends JpaRepository<Record, UUID> {

    List<Record> findByExercise_Id(UUID exerciseId);

    List<Record> findByUser_Id(UUID userId);
}