package com.languageapp.language_learning_backend.config;


import io.swagger.v3.oas.models.*;
import io.swagger.v3.oas.models.info.*;
import io.swagger.v3.oas.models.security.*;
import io.swagger.v3.oas.models.servers.*;
import io.swagger.v3.oas.models.tags.Tag;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.*;

import java.util.List;

@Configuration
public class SwaggerConfig {

    @Value("${backend.url}")
    private String backendUrl;

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(apiInfo())
                .servers(servers())
                .tags(tags())
                .components(components())
                .addSecurityItem(globalSecurity());
    }

    // ── API INFO ──────────────────────────────────────────────
    private Info apiInfo() {
        return new Info()
                .title("LinguaNext API")
                .description("""
                        ## 🌍 LinguaNext — AI-powered Language Learning Platform
                        
                        ### Authentication
                        1. `POST /api/v1/auth/register` hoặc `POST /api/v1/auth/login`
                        2. Copy **accessToken** từ response
                        3. Click **Authorize** (🔒) ở góc phải trên, nhập `Bearer <token>`
                        
                        ### Rate Limits (AI endpoints)
                        | Feature | Free | Premium |
                        |---------|------|---------|
                        | Chat | 20/ngày | 200/ngày |
                        | Grammar Check | 10/ngày | 100/ngày |
                        | Pronunciation | 5/ngày | 50/ngày |
                        
                        ### Subscription Plans
                        | Plan | Price |
                        |------|-------|
                        | Monthly | $4.99 USD / 119,000 VND |
                        | Yearly | $39.99 USD / 959,000 VND |
                        """)
                .version("1.0.0")
                .contact(new Contact()
                        .name("LinguaNext Team")
                        .email("dev@linguanext.com")
                        .url("https://linguanext.com"))
                .license(new License()
                        .name("Private — All rights reserved")
                        .url("https://linguanext.com/terms"));
    }

    // ── SERVERS ───────────────────────────────────────────────
    private List<Server> servers() {
        return List.of(
                new Server().url(backendUrl).description("Current Environment")
        );
    }

    // ── TAGS — thứ tự hiển thị trong Swagger UI ──────────────
    private List<Tag> tags() {
        return List.of(
                new Tag().name("01 · Users & Auth"),
                new Tag().name("02 · Languages"),
                new Tag().name("03 · Courses"),
                new Tag().name("04 · Lessons"),
                new Tag().name("05 · Exercises"),
                new Tag().name("06 · Progress"),
                new Tag().name("07 · Study Logs & Streak"),
                new Tag().name("08 · Subscriptions"),
                new Tag().name("09 · Payments"),
                new Tag().name("10 · AI Features"),
                new Tag().name("11 · Topics"),
                new Tag().name("12 · Learning Paths"),
                new Tag().name("13 · Gamification"),
                new Tag().name("14 · Something"),
                new Tag().name("15 · Review Mistakes"),
                new Tag().name("16 · Reports")
        );
    }

    // ── SECURITY SCHEME — Bearer JWT ─────────────────────────
    private Components components() {
        return new Components()
                .addSecuritySchemes("bearerAuth",
                        new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("Nhập accessToken nhận được từ /auth/login hoặc /auth/register"));
    }

    // Áp dụng bearerAuth cho tất cả endpoint (những endpoint public
    // vẫn hoạt động bình thường — Spring Security quyết định, không phải Swagger)
    private SecurityRequirement globalSecurity() {
        return new SecurityRequirement().addList("bearerAuth");
    }
}
