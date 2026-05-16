package com.languageapp.language_learning_backend.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.*;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // Custom exceptions — defined first so they are reachable by the handlers below
    public static class NotFoundException     extends RuntimeException { public NotFoundException(String m)     { super(m); } }
    public static class ConflictException     extends RuntimeException { public ConflictException(String m)     { super(m); } }
    public static class UnauthorizedException extends RuntimeException { public UnauthorizedException(String m) { super(m); } }
    public static class ForbiddenException    extends RuntimeException { public ForbiddenException(String m)    { super(m); } }
    public static class BadRequestException        extends RuntimeException { public BadRequestException(String m)        { super(m); } }
    public static class TooManyRequestsException   extends RuntimeException { public TooManyRequestsException(String m)   { super(m); } }

    // ── Specific handlers (most-specific first) ──────────────

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Err> notFound(NotFoundException e) { return err(404, "NOT_FOUND", e.getMessage()); }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<Err> conflict(ConflictException e) { return err(409, "CONFLICT", e.getMessage()); }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<Err> unauthorized(UnauthorizedException e) { return err(401, "UNAUTHORIZED", e.getMessage()); }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<Err> forbidden(ForbiddenException e) { return err(403, "FORBIDDEN", e.getMessage()); }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<Err> badRequest(BadRequestException e) {
        log.warn("BadRequest: {}", e.getMessage());
        return err(400, "BAD_REQUEST", e.getMessage());
    }

    @ExceptionHandler(TooManyRequestsException.class)
    public ResponseEntity<Err> tooManyRequests(TooManyRequestsException e) { return err(429, "TOO_MANY_REQUESTS", e.getMessage()); }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Err> validation(MethodArgumentNotValidException e) {
        Map<String, String> errors = new LinkedHashMap<>();
        e.getBindingResult().getAllErrors().forEach(err -> {
            String field = err instanceof FieldError fe ? fe.getField() : err.getObjectName();
            errors.put(field, err.getDefaultMessage());
        });
        return ResponseEntity.badRequest().body(new Err("VALIDATION_ERROR", "Validation failed", errors, LocalDateTime.now()));
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<Err> authenticationFailed(AuthenticationException e) {
        return err(401, "UNAUTHORIZED", "Authentication required");
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Err> accessDenied(AccessDeniedException e) {
        return err(403, "FORBIDDEN", "Access denied");
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<Err> missingParam(MissingServletRequestParameterException e) {
        return err(400, "BAD_REQUEST", "Missing required parameter: " + e.getParameterName());
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<Err> typeMismatch(MethodArgumentTypeMismatchException e) {
        return err(400, "BAD_REQUEST", "Invalid value for parameter: " + e.getName());
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Err> messageNotReadable(HttpMessageNotReadableException e) {
        return err(400, "BAD_REQUEST", "Invalid request body: " + e.getMostSpecificCause().getMessage());
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<Err> noResourceFound(NoResourceFoundException e) {
        return err(404, "NOT_FOUND", "Endpoint not found");
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<Err> dataIntegrity(DataIntegrityViolationException e) {
        return err(409, "CONFLICT", "Resource is in use and cannot be deleted");
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<?> handleIllegalArgument(IllegalArgumentException e) {
        return ResponseEntity.badRequest().body(Map.of(
                "error", e.getMessage(),
                "timestamp", System.currentTimeMillis()
        ));
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<?> handleRuntimeException(RuntimeException e) {
        log.error("Runtime error: {}", e.getMessage());

        String message = e.getMessage();
        HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

        if (message != null && message.contains("API error: 429")) {
            status = HttpStatus.TOO_MANY_REQUESTS;
            message = "AI service rate limit exceeded. Please try again later.";
        } else if (message != null && message.contains("API error: 401")) {
            status = HttpStatus.UNAUTHORIZED;
            message = "AI service authentication failed. Check your API key.";
        }

        return ResponseEntity.status(status).body(Map.of(
                "error", message != null ? message : "Unknown error",
                "timestamp", System.currentTimeMillis()
        ));
    }

    // ── Catch-all (least-specific last) ──────────────────────
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Err> general(Exception e) {
        log.error("Unhandled: {}", e.getMessage(), e);
        return err(500, "INTERNAL_ERROR", "An unexpected error occurred");
    }

    // ── Helpers ──────────────────────────────────────────────
    private ResponseEntity<Err> err(int status, String code, String message) {
        return ResponseEntity.status(status).body(new Err(code, message, null, LocalDateTime.now()));
    }

    public record Err(String code, String message, Map<String, String> errors, LocalDateTime timestamp) {}
}
