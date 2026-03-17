package com.languageapp.language_learning_backend.config;
// Truy cập: http://localhost:8080/swagger-ui.html
// JSON spec: http://localhost:8080/v3/api-docs

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

    @Value("${app.frontend-url:http://localhost:3000}")
    private String frontendUrl;

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
                new Server().url("http://localhost:8080").description("Local Development"),
                new Server().url("https://api.linguanext.com").description("Production")
        );
    }

    // ── TAGS — thứ tự hiển thị trong Swagger UI ──────────────
    private List<Tag> tags() {
        return List.of(
                new Tag().name("01 · Users & Auth")
                        .description("Đăng ký, đăng nhập, refresh token, xác thực email, reset mật khẩu"),
                new Tag().name("02 · Languages")
                        .description("Danh sách ngôn ngữ học (en, ja, ko, zh, fr, vi...)"),
                new Tag().name("03 · Courses")
                        .description("Khoá học — tìm kiếm, filter, publish/unpublish"),
                new Tag().name("04 · Lessons")
                        .description("Bài học trong khoá — nội dung, video, audio"),
                new Tag().name("05 · Exercises")
                        .description("Bài tập — multiple choice, fill-in-blank, speaking, matching. Tự động chấm điểm"),
                new Tag().name("06 · Progress")
                        .description("Dashboard học tập, tiến độ theo khoá, stats tuần/tháng/năm, chứng chỉ"),
                new Tag().name("07 · Study Logs & Streak")
                        .description("Ghi nhận phiên học, streak liên tiếp, heatmap hoạt động"),
                new Tag().name("08 · Subscriptions")
                        .description("Trạng thái Premium, huỷ auto-renew"),
                new Tag().name("09 · Payments")
                        .description("Tạo đơn thanh toán PayPal / MoMo, lịch sử giao dịch, webhook IPN"),
                new Tag().name("10 · AI Features")
                        .description("Chat gia sư AI, kiểm tra ngữ pháp, chấm phát âm, bài kiểm tra trình độ CEFR")
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
