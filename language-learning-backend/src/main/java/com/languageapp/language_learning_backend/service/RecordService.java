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
                         Record.RecordType type,
                         UUID userId,
                         UUID exerciseId) {

        try {
            Map uploadResult = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap("resource_type", "video")
            );

            Record.RecordBuilder builder = Record.builder()
                    .title(title)
                    .audioUrl((String) uploadResult.get("secure_url"))
                    .publicId((String) uploadResult.get("public_id"))
                    .type(type);

            // USER
            if (type == Record.RecordType.USER_PRACTICE && userId != null) {
                builder.user(userRepo.getReferenceById(userId));
            }

            // EXERCISE
            if (exerciseId != null) {
                builder.exercise(exerciseRepo.getReferenceById(exerciseId));
            }

            Record saved = recordRepo.save(builder.build());

            // 🔔 notify
            if (type == Record.RecordType.USER_PRACTICE) {
                firebaseService.sendToUser(userId,
                        "Đã upload",
                        "Audio của bạn đã được lưu");
            } else {
                firebaseService.sendToTopic("listening",
                        "Audio mới",
                        "Có audio mới cho bài nghe");
            }

            return saved;

        } catch (Exception e) {
            throw new RuntimeException("Upload failed", e);
        }
    }
}