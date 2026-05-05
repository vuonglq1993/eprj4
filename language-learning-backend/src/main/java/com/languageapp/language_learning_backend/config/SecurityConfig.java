package com.languageapp.language_learning_backend.config;

import com.languageapp.language_learning_backend.security.JwtFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.*;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.*;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    @Value("${frontend.url}")
    private String frontendUrl;
    @Value("${backend.url}")
    private String backendUrl;
    @Value("${android.url}")
    private String androidUrl;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(c -> c.disable())
                .cors(c -> c.configurationSource(corsSource()))
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(a -> a
                        .requestMatchers("/api/v1/auth/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/courses/**", "/api/v1/languages/**","/api/v1/subscription-plans/**").permitAll()
                        .requestMatchers("/api/v1/payments/webhook/**").permitAll()
                        .requestMatchers("/api/v1/payments/vnpay/**").permitAll()
                        .requestMatchers("/api/v1/payments/paypal/return", "/api/v1/payments/paypal/cancel").permitAll()
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/swagger-ui.html").permitAll()
                        .requestMatchers("/static/**", "/*.html").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/courses/**").permitAll()
                        .requestMatchers(HttpMethod.POST,
                                "/api/v1/courses/*/lessons/*/exercises/submit"
                        ).authenticated()
                        .requestMatchers(
                                "/firebase-messaging-sw.js",
                                "/index.html",
                                "/favicon.ico",
                                "/static/**"
                        ).permitAll()
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    public CorsConfigurationSource corsSource() {
        var cfg = new CorsConfiguration();
        cfg.setAllowedOriginPatterns(List.of(
                frontendUrl,
                backendUrl,
                androidUrl
        ));
        cfg.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        cfg.setAllowedHeaders(List.of("*"));
        cfg.setAllowCredentials(true);
        var src = new UrlBasedCorsConfigurationSource();
        src.registerCorsConfiguration("/**", cfg);
        return src;
    }
}