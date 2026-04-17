package com.languageapp.language_learning_backend.service;

import com.google.firebase.messaging.*;
import com.languageapp.language_learning_backend.entity.DeviceToken;
import com.languageapp.language_learning_backend.repository.DeviceTokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class FirebaseService {

    private final DeviceTokenRepository repo;

    public void sendToUser(UUID userId, String title, String body) {

        List<DeviceToken> tokens = repo.findByUserId(userId);

        for (DeviceToken t : tokens) {
            Message message = Message.builder()
                    .setToken(t.getToken())
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build())
                    .build();

            try {
                FirebaseMessaging.getInstance().send(message);
            } catch (Exception e) {
                repo.delete(t);
            }
        }
    }

    public void sendToTopic(String topic, String title, String body) {

        Message message = Message.builder()
                .setTopic(topic)
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                .build();

        try {
            FirebaseMessaging.getInstance().send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}