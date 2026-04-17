package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.record.RecordResponse;
import com.languageapp.language_learning_backend.entity.Record;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.RecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/records")
@RequiredArgsConstructor
public class RecordController {

    private final RecordService recordService;

    @PostMapping("/upload")
    public ResponseEntity<Record> upload(
            @RequestParam MultipartFile file,
            @RequestParam String title,
            @RequestParam Record.RecordType type,
            @RequestParam(required = false) UUID userId,
            @RequestParam(required = false) UUID exerciseId
    ) {
        return ResponseEntity.ok(
                recordService.upload(file, title, type, userId, exerciseId)
        );
    }

    @GetMapping("/exercise/{exerciseId}")
    public ResponseEntity<List<RecordResponse>> getByExercise(@PathVariable UUID exerciseId) {
        return ResponseEntity.ok(
                recordService.getByExercise(exerciseId)
        );
    }
}