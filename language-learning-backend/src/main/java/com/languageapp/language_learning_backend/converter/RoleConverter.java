package com.languageapp.language_learning_backend.converter;

import com.languageapp.language_learning_backend.entity.User.Role;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class RoleConverter implements AttributeConverter<Role, String> {

    @Override
    public String convertToDatabaseColumn(Role attribute) {
        if (attribute == null) return "STUDENT";
        return attribute.name();
    }

    @Override
    public Role convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isBlank()) return Role.STUDENT;
        try {
            return Role.valueOf(dbData.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return Role.STUDENT;
        }
    }
}
