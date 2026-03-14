package com.languageapp.language_learning_backend.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Err> notFound(NotFoundException e) { return err(404, "NOT_FOUND", e.getMessage()); }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<Err> conflict(ConflictException e) { return err(409, "CONFLICT", e.getMessage()); }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<Err> unauthorized(UnauthorizedException e) { return err(401, "UNAUTHORIZED", e.getMessage()); }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<Err> forbidden(ForbiddenException e) { return err(403, "FORBIDDEN", e.getMessage()); }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<Err> badRequest(BadRequestException e) { return err(400, "BAD_REQUEST", e.getMessage()); }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Err> validation(MethodArgumentNotValidException e) {
        Map<String,String> errors = new LinkedHashMap<>();
        e.getBindingResult().getAllErrors().forEach(err -> {
            String field = err instanceof FieldError fe ? fe.getField() : err.getObjectName();
            errors.put(field, err.getDefaultMessage());
        });
        return ResponseEntity.badRequest().body(new Err("VALIDATION_ERROR", "Validation failed", errors, LocalDateTime.now()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Err> general(Exception e) {
        log.error("Unhandled: {}", e.getMessage(), e);
        return err(500, "INTERNAL_ERROR", "An unexpected error occurred");
    }

    private ResponseEntity<Err> err(int status, String code, String message) {
        return ResponseEntity.status(status).body(new Err(code, message, null, LocalDateTime.now()));
    }

    public record Err(String code, String message, Map<String,String> errors, LocalDateTime timestamp) {}

    // Custom exceptions
    public static class NotFoundException     extends RuntimeException { public NotFoundException(String m)     { super(m); } }
    public static class ConflictException     extends RuntimeException { public ConflictException(String m)     { super(m); } }
    public static class UnauthorizedException extends RuntimeException { public UnauthorizedException(String m) { super(m); } }
    public static class ForbiddenException    extends RuntimeException { public ForbiddenException(String m)    { super(m); } }
    public static class BadRequestException   extends RuntimeException { public BadRequestException(String m)   { super(m); } }
}
