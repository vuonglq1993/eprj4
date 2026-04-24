package com.languageapp.language_learning_backend.dto.firebase;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpResponse {

    private String message;
    private String email;
    private String type;
    private long expiresIn; // seconds (vd: 300)
}