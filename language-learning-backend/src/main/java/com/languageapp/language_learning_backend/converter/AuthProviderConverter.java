package com.languageapp.language_learning_backend.converter;

import com.languageapp.language_learning_backend.entity.User.AuthProvider;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class AuthProviderConverter implements AttributeConverter<AuthProvider, String> {

    @Override
    public String convertToDatabaseColumn(AuthProvider attribute) {
        if (attribute == null) return "LOCAL";
        return attribute.name();
    }

    @Override
    public AuthProvider convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isBlank()) return AuthProvider.LOCAL;
        try {
            return AuthProvider.valueOf(dbData.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return AuthProvider.LOCAL;
        }
    }
}
