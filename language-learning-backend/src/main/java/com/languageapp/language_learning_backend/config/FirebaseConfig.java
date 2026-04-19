package com.languageapp.language_learning_backend.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.*;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource; // Import thêm cái này

import java.io.InputStream;

@Configuration
public class FirebaseConfig {

    @Value("${firebase.config-path}")
    private String firebaseConfigPath;

    @PostConstruct
    public void init() {
        try {

            ClassPathResource resource = new ClassPathResource(firebaseConfigPath);
            InputStream serviceAccount = resource.getInputStream();

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("✅ Firebase initialized successfully for LinguaNext!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Firebase init failed: " + e.getMessage(), e);
        }
    }
}