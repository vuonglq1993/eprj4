package com.languageapp.language_learning_backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

@Configuration
@EnableRetry       // cho @Retryable trong OpenAIClient
@EnableAsync       // cho @Async trong EmailService
@EnableScheduling  // cho @Scheduled trong StudyReminderScheduler
public class AppConfig {

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}