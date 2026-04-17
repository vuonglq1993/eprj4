package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.topic.*;
import com.languageapp.language_learning_backend.entity.Topic;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.TopicRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TopicService {

    private final TopicRepository repo;

    // ── LIST (public) ─────────────────────────────────────────
    @Cacheable("topics")
    @Transactional(readOnly = true)
    public List<TopicResponse> getAll() {
        return repo.findActiveWithCourseCount().stream()
                .map(row -> toResponse((Topic) row[0], ((Long) row[1]).intValue()))
                .collect(Collectors.toList());
    }

    // ── GET BY ID ─────────────────────────────────────────────
    @Transactional(readOnly = true)
    public TopicResponse getById(UUID id) {
        return toResponse(findOrThrow(id), null);
    }

    // ── CREATE (Admin) ────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "topics", allEntries = true)
    public TopicResponse create(TopicRequest req) {
        if (repo.existsByNameIgnoreCase(req.getName()))
            throw new ConflictException("Topic already exists: " + req.getName());
        return toResponse(repo.save(Topic.builder()
                .name(req.getName())
                .description(req.getDescription())
                .iconUrl(req.getIconUrl())
                .isActive(Boolean.TRUE.equals(req.getIsActive()))
                .orderIndex(req.getOrderIndex() != null ? req.getOrderIndex() : 0)
                .build()), 0);
    }

    // ── UPDATE (Admin) ────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "topics", allEntries = true)
    public TopicResponse update(UUID id, TopicRequest req) {
        Topic t = findOrThrow(id);
        t.setName(req.getName());
        t.setDescription(req.getDescription());
        t.setIconUrl(req.getIconUrl());
        if (req.getIsActive()    != null) t.setIsActive(req.getIsActive());
        if (req.getOrderIndex()  != null) t.setOrderIndex(req.getOrderIndex());
        return toResponse(repo.save(t), null);
    }

    // ── DELETE (Admin) ────────────────────────────────────────
    @Transactional
    @CacheEvict(value = "topics", allEntries = true)
    public void delete(UUID id) {
        Topic t = findOrThrow(id);
        if (!t.getCourses().isEmpty())
            throw new BadRequestException("Cannot delete topic that has courses");
        repo.delete(t);
    }

    // ── PUBLIC HELPER ─────────────────────────────────────────
    public Topic findOrThrow(UUID id) {
        return repo.findById(id)
                .orElseThrow(() -> new NotFoundException("Topic not found: " + id));
    }

    // ── MAPPER ────────────────────────────────────────────────
    private TopicResponse toResponse(Topic t, Integer count) {
        return TopicResponse.builder()
                .id(t.getId())
                .name(t.getName())
                .description(t.getDescription())
                .iconUrl(t.getIconUrl())
                .isActive(t.getIsActive())
                .orderIndex(t.getOrderIndex())
                .totalCourses(count)
                .build();
    }
}
