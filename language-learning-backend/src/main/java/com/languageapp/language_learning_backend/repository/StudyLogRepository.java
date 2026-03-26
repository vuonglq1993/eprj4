package com.languageapp.language_learning_backend.repository;

import com.languageapp.language_learning_backend.entity.StudyLog;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.*;

@Repository
public interface StudyLogRepository extends JpaRepository<StudyLog, UUID> {

    // Danh sách ngày đã học (để tính streak)
    @Query("SELECT DISTINCT s.studyDate FROM StudyLog s WHERE s.user.id=:uid AND s.studyDate>=:since ORDER BY s.studyDate DESC")
    List<LocalDate> studyDates(@Param("uid") UUID uid, @Param("since") LocalDate since);

    // Tổng giây học mỗi ngày (dùng cho chart)
    @Query("SELECT s.studyDate, SUM(s.durationSeconds) FROM StudyLog s WHERE s.user.id=:uid AND s.studyDate BETWEEN :from AND :to GROUP BY s.studyDate ORDER BY s.studyDate")
    List<Object[]> dailySeconds(@Param("uid") UUID uid, @Param("from") LocalDate from, @Param("to") LocalDate to);

    // Số bài hoàn thành mỗi ngày
    @Query("SELECT s.studyDate, COUNT(s) FROM StudyLog s WHERE s.user.id=:uid AND s.activityType='EXERCISE_SUBMIT' AND s.studyDate BETWEEN :from AND :to GROUP BY s.studyDate")
    List<Object[]> dailyCount(@Param("uid") UUID uid, @Param("from") LocalDate from, @Param("to") LocalDate to);

    @Query("SELECT COALESCE(SUM(s.durationSeconds),0) FROM StudyLog s WHERE s.user.id=:uid AND s.studyDate BETWEEN :from AND :to")
    long sumSeconds(@Param("uid") UUID uid, @Param("from") LocalDate from, @Param("to") LocalDate to);

    boolean existsByUserIdAndStudyDate(UUID userId, LocalDate date);
}
