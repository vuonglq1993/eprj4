package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.language.*;
import com.languageapp.language_learning_backend.entity.Language;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.LanguageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LanguageService {

    private final LanguageRepository repo;

    @Cacheable("languages")
    @Transactional(readOnly = true)
    public List<LanguageResponse> getAll() {
        return repo.findActiveWithCourseCount().stream()
                .map(row -> toResponse((Language) row[0], ((Long) row[1]).intValue()))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public LanguageResponse getById(UUID id) {
        return toResponse(findOrThrow(id), null);
    }

    @Transactional
    @CacheEvict(value = "languages", allEntries = true)
    public LanguageResponse create(LanguageRequest req) {
        if (repo.existsByCode(req.getCode()))
            throw new ConflictException("Language code already exists: " + req.getCode());
        return toResponse(repo.save(Language.builder()
                .code(req.getCode()).name(req.getName()).nativeName(req.getNativeName())
                .flag(req.getFlag()).isActive(req.getIsActive()).build()), 0);
    }

    @Transactional
    @CacheEvict(value = "languages", allEntries = true)
    public LanguageResponse update(UUID id, LanguageRequest req) {
        Language l = findOrThrow(id);
        l.setName(req.getName()); l.setNativeName(req.getNativeName());
        l.setFlag(req.getFlag()); l.setIsActive(req.getIsActive());
        return toResponse(repo.save(l), null);
    }

    @Transactional
    @CacheEvict(value = "languages", allEntries = true)
    public void delete(UUID id) {
        Language l = findOrThrow(id);
        if (!l.getCourses().isEmpty())
            throw new BadRequestException("Cannot delete language that has courses");
        repo.delete(l);
    }

    // helpers
    public Language findOrThrow(UUID id) {
        return repo.findById(id).orElseThrow(() -> new NotFoundException("Language not found: " + id));
    }

    private LanguageResponse toResponse(Language l, Integer count) {
        return LanguageResponse.builder()
                .id(l.getId()).code(l.getCode()).name(l.getName())
                .nativeName(l.getNativeName()).flag(l.getFlag()).isActive(l.getIsActive())
                .totalPublishedCourses(count).build();
    }
}