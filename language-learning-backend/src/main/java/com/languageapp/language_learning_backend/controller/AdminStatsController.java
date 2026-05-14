package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.service.AdminStatsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/admin/stats")
@RequiredArgsConstructor
public class AdminStatsController {

    private final AdminStatsService service;

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/daily-active")
    public ResponseEntity<?> dailyActive(
            @RequestParam(defaultValue = "7") int days) {
        return ResponseEntity.ok(service.getDailyActive(days));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/subscription-breakdown")
    public ResponseEntity<?> subscriptionBreakdown() {
        return ResponseEntity.ok(service.getSubscriptionBreakdown());
    }
}
