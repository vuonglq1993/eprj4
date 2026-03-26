package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.dto.subscription.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import com.languageapp.language_learning_backend.service.SubscriptionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@Tag(name = "08 · Subscriptions")
@RestController
@RequestMapping("/api/v1/subscriptions")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("isAuthenticated()")
public class SubscriptionController {

    private final SubscriptionService service;

    @Operation(summary = "Trạng thái subscription hiện tại")
    @GetMapping("/status")
    public ResponseEntity<SubscriptionStatusResponse> getStatus(@AuthenticationPrincipal UserPrincipal p) {
        return ResponseEntity.ok(service.getStatus(p));
    }

    @Operation(summary = "Huỷ auto-renew subscription")
    @PostMapping("/cancel")
    public ResponseEntity<Map<String,String>> cancel(@AuthenticationPrincipal UserPrincipal p) {
        service.cancel(p);
        return ResponseEntity.ok(Map.of("message", "Subscription cancelled — still active until end date"));
    }
}
