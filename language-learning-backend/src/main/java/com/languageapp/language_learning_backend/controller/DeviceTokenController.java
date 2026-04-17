package com.languageapp.language_learning_backend.controller;

import com.languageapp.language_learning_backend.entity.DeviceToken;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/device")
@RequiredArgsConstructor
public class DeviceTokenController {

    private final DeviceTokenRepository repo;
    private final UserRepository userRepo;

    @PostMapping("/token")
    public void saveToken(@RequestBody Map<String, String> body,
                          @AuthenticationPrincipal UserPrincipal p) {

        String token = body.get("token");

        if (repo.findByToken(token).isPresent()) return;

        repo.save(DeviceToken.builder()
                .token(token)
                .user(userRepo.getReferenceById(p.getUserId()))
                .deviceType("ANDROID")
                .build());
    }
}