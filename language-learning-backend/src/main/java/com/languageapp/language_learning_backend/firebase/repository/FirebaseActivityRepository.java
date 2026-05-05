package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.UserActivityDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ExecutionException;

@Slf4j
@Repository
public class FirebaseActivityRepository {

    private static final String COLLECTION = "user_activities";

    // ══════════════════════════════════════════════
    // SAVE (Async - không cần chờ response)
    // ══════════════════════════════════════════════
    public void save(UserActivityDocument doc) {
        try {
            Firestore db = FirestoreClient.getFirestore();

            Map<String, Object> data = new HashMap<>();
            data.put("userId", doc.getUserId());
            data.put("activityType", doc.getActivityType());
            data.put("timestamp", doc.getTimestamp().toString());
            data.put("metadata", doc.getMetadata());

            // Auto-generate document ID
            db.collection(COLLECTION).add(data);

            log.debug("✅ Activity logged: {} - {}", doc.getUserId(), doc.getActivityType());

        } catch (Exception e) {
            log.error("❌ Failed to log activity: {}", e.getMessage());
        }
    }

    // ══════════════════════════════════════════════
    // FIND BY USER (Last 100 activities)
    // ══════════════════════════════════════════════
    public List<UserActivityDocument> findByUserId(String userId, int limit)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();

        Query query = db.collection(COLLECTION)
                .whereEqualTo("userId", userId)
                .orderBy("timestamp", Query.Direction.DESCENDING)
                .limit(limit);

        List<UserActivityDocument> activities = new ArrayList<>();
        for (DocumentSnapshot doc : query.get().get().getDocuments()) {
            activities.add(toDocument(doc));
        }

        return activities;
    }

    // ══════════════════════════════════════════════
    // CONVERTER
    // ══════════════════════════════════════════════
    @SuppressWarnings("unchecked")
    private UserActivityDocument toDocument(DocumentSnapshot doc) {
        return UserActivityDocument.builder()
                .userId(doc.getString("userId"))
                .activityType(doc.getString("activityType"))
                .timestamp(Instant.parse(doc.getString("timestamp")))
                .metadata((Map<String, Object>) doc.get("metadata"))
                .build();
    }
}