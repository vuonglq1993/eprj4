package com.languageapp.language_learning_backend.security;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
@RequiredArgsConstructor
public class JwtFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwt;

    @Override
    protected void doFilterInternal(HttpServletRequest req,
                                    HttpServletResponse res,
                                    FilterChain chain) throws ServletException, IOException {

        String header = req.getHeader("Authorization");

        if (StringUtils.hasText(header) && header.startsWith("Bearer ")) {

            String token = header.substring(7);

            if (jwt.validate(token)) {

                var principal = new UserPrincipal(
                        jwt.getUserId(token),
                        jwt.getEmail(token),
                        jwt.getRole(token)
                );

                // ✅ FIX ROLE FORMAT CHO SPRING SECURITY
                String role = jwt.getRole(token);

                UsernamePasswordAuthenticationToken auth =
                        new UsernamePasswordAuthenticationToken(
                                principal,
                                null,
                                List.of(new SimpleGrantedAuthority("ROLE_" + role))
                        );

                auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(req));

                SecurityContextHolder.getContext().setAuthentication(auth);

                // ================== DEBUG LOG ==================
                System.out.println("========== JWT FILTER DEBUG ==========");
                System.out.println("URI: " + req.getRequestURI());
                System.out.println("USER ID: " + principal.getUserId());
                System.out.println("EMAIL: " + principal.getEmail());
                System.out.println("ROLE FROM TOKEN: " + role);
                System.out.println("AUTHORITIES: " + auth.getAuthorities());
                System.out.println("AUTH SET SUCCESS: " +
                        SecurityContextHolder.getContext().getAuthentication());
                System.out.println("======================================");
            }
        }

        chain.doFilter(req, res);
    }
}