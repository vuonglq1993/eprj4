package com.languageapp.language_learning_backend.dto.language;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class LanguageResponse {
    private UUID    id;
    private String  code;
    private String  name;
    private String  nativeName;
    private String  flag;
    private Boolean isActive;
    private Integer totalPublishedCourses;
}
