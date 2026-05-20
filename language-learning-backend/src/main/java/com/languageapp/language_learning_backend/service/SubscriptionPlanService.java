package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.payment.*;
import com.languageapp.language_learning_backend.entity.SubscriptionPlan;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.SubscriptionPlanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SubscriptionPlanService {

    private final SubscriptionPlanRepository repo;

    // ── LIST (public) ─────────────────────────────────────────
    @Transactional(readOnly = true)
    public List<SubscriptionPlanResponse> getAll() {
        return repo.findByIsActiveTrueOrderByPriceAsc()
                .stream().map(this::toResponse)
                .collect(Collectors.toList());
    }

    // ── GET BY NAME (dùng trong PaymentService) ───────────────
    @Transactional(readOnly = true)
    public SubscriptionPlan getByName(String name) {
        return repo.findByNameIgnoreCase(name)
                .orElseThrow(() -> new NotFoundException("Plan not found: " + name));
    }

    // ── CREATE (Admin) ────────────────────────────────────────
    @Transactional
    public SubscriptionPlanResponse create(SubscriptionPlanRequest req) {
        if (repo.findByNameIgnoreCase(req.getName()).isPresent())
            throw new ConflictException("Plan already exists: " + req.getName());
        return toResponse(repo.save(SubscriptionPlan.builder()
                .name(req.getName().toUpperCase())
                .description(req.getDescription())
                .price(req.getPrice())
                .durationDays(req.getDurationDays())
                .features(req.getFeatures() != null ? req.getFeatures() : List.of())
                .isActive(req.getIsActive())
                .build()));
    }

    // ── UPDATE (Admin) ────────────────────────────────────────
    @Transactional
    public SubscriptionPlanResponse update(UUID id, SubscriptionPlanRequest req) {
        SubscriptionPlan plan = repo.findById(id)
                .orElseThrow(() -> new NotFoundException("Plan not found"));

        // check trùng name
        repo.findByNameIgnoreCase(req.getName())
                .filter(p -> !p.getId().equals(id))
                .ifPresent(p -> {
                    throw new ConflictException("Plan already exists: " + req.getName());
                });

        // update FULL
        plan.setName(req.getName().toUpperCase());
        plan.setDescription(req.getDescription());
        plan.setPrice(req.getPrice());
        plan.setDurationDays(req.getDurationDays());
        plan.setFeatures(req.getFeatures() != null ? req.getFeatures() : List.of());

        if (req.getIsActive() != null) {
            plan.setIsActive(req.getIsActive());
        }

        return toResponse(repo.save(plan));
    }

    // ── TOGGLE (Admin) ────────────────────────────────────────
    @Transactional
    public SubscriptionPlanResponse toggle(UUID id) {
        SubscriptionPlan plan = repo.findById(id)
                .orElseThrow(() -> new NotFoundException("Plan not found"));
        plan.setIsActive(!plan.getIsActive());
        return toResponse(repo.save(plan));
    }

    // ── DELETE (Admin) ────────────────────────────────────────
    @Transactional
    public void delete(UUID id) {
        if (!repo.existsById(id))
            throw new NotFoundException("Plan not found");
        repo.deleteById(id);
    }

    // ── MAPPER ────────────────────────────────────────────────
    private SubscriptionPlanResponse toResponse(SubscriptionPlan p) {
        return SubscriptionPlanResponse.builder()
                .id(p.getId()).name(p.getName()).description(p.getDescription())
                .price(p.getPrice()).durationDays(p.getDurationDays())
                .features(p.getFeatures()).isActive(p.getIsActive()).build();
    }
}