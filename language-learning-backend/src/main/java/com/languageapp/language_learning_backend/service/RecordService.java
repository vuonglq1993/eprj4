package com.languageapp.language_learning_backend.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.languageapp.language_learning_backend.dto.record.RecordResponse;
import com.languageapp.language_learning_backend.entity.Record;
import com.languageapp.language_learning_backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@Service
@RequiredArgsConstructor
public class RecordService {

    private final Cloudinary cloudinary;
    private final RecordRepository recordRepo;
    private final UserRepository userRepo;
    private final ExerciseRepository exerciseRepo;
    private final FirebaseService firebaseService;


    public List<RecordResponse> getByExercise(UUID exerciseId) {
        return recordRepo.findByExercise_Id(exerciseId)
                .stream()
                .map(r -> RecordResponse.builder()
                        .audioUrl(r.getAudioUrl())
                        .title(r.getTitle())
                        .build())
                .toList();
    }

    public Record upload(MultipartFile file,
                         String title,
                         UUID userId,
                         UUID exerciseId) {

        try {
            Map uploadResult = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap(
                            "resource_type", "auto"
                    )
            );

            Record record = Record.builder()
                    .audioUrl((String) uploadResult.get("secure_url"))
                    .title(title)
                    .user(userRepo.getReferenceById(userId))
                    .exercise(exerciseRepo.getReferenceById(exerciseId))
                    .build();

            return recordRepo.save(record);

        } catch (Exception e) {
            throw new RuntimeException("Upload failed", e);
        }
    }
}