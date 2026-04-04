package com.languageapp.language_learning_backend.dto.topic;
import lombok.*;
import java.util.UUID;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TopicResponse {
    private UUID    id;
    private String  name;
    private String  description;
    private String  iconUrl;
    private Boolean isActive;
    private Integer orderIndex;
    private Integer totalCourses;
}
