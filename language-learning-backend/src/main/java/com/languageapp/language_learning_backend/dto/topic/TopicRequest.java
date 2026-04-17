package com.languageapp.language_learning_backend.dto.topic;
import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TopicRequest {
    @NotBlank @Size(max = 100) private String  name;
    @Size(max = 500)           private String  description;
    @Size(max = 100)           private String  iconUrl;
    private Boolean isActive   = true;
    private Integer orderIndex = 0;
}
