package com.languageapp.language_learning_backend.dto.record;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecordResponse {

    private String audioUrl;
    private String title;
}