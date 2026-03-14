package com.languageapp.language_learning_backend.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.*;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
// import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.*;
import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    // TODO enable when JWT authentication is implemented
    // private final JwtFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(c -> c.disable())
                .cors(c -> c.configurationSource(corsSource()))

                // Using stateless session because this project is designed for JWT auth
                // (currently JWT filter is disabled)
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                .authorizeHttpRequests(a -> a
                        .requestMatchers("/api/v1/auth/**").permitAll()

                        // Public GET endpoints
                        .requestMatchers(HttpMethod.GET,
                                "/api/v1/courses/**",
                                "/api/v1/languages/**"
                        ).permitAll()

                        .requestMatchers("/api/v1/payments/webhook/**").permitAll()

                        // Swagger + health check
                        .requestMatchers(
                                "/swagger-ui/**",
                                "/v3/api-docs/**",
                                "/actuator/health"
                        ).permitAll()

                        // TODO when JWT is enabled this should require authentication
                        .anyRequest().permitAll()
                )

                /*
                // JWT filter (currently disabled)

                .addFilterBefore(
                        jwtFilter,
                        UsernamePasswordAuthenticationFilter.class
                )
                */

                .build();
    }

    // Password hashing using BCrypt
    // strength = 12 (recommended for production)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    // CORS configuration for frontend access
    @Bean
    public CorsConfigurationSource corsSource() {

        var cfg = new CorsConfiguration();

        // Allow local frontend + production domain
        cfg.setAllowedOriginPatterns(
                List.of(
                        "http://localhost:3000",
                        "https://*.linguanext.com"
                )
        );

        cfg.setAllowedMethods(
                List.of("GET","POST","PUT","PATCH","DELETE","OPTIONS")
        );

        cfg.setAllowedHeaders(List.of("*"));
        cfg.setAllowCredentials(true);

        var src = new UrlBasedCorsConfigurationSource();
        src.registerCorsConfiguration("/**", cfg);

        return src;
    }
}
