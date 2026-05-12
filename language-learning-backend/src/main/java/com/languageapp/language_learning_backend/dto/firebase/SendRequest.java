package com.languageapp.language_learning_backend.dto.firebase;

import lombok.Getter;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
public class SendRequest {
    private String title;
    private String body;
    private Map<String, String> data;
}
