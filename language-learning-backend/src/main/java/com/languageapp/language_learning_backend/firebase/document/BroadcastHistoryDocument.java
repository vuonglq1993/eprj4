package com.languageapp.language_learning_backend.firebase.document;

import lombok.*;
import java.util.Date;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class BroadcastHistoryDocument {
    private String id;
    private String title;
    private String body;
    private String type;      // PROMOTION, SYSTEM, EVENT
    private String sentBy;
    private Date sentAt;
    private String target;     // ALL_USERS
    private int recipientCount;
}
