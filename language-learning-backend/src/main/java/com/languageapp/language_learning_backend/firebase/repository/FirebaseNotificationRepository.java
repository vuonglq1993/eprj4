package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.NotificationDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ExecutionException;

@Slf4j
@Repository
public class FirebaseNotificationRepository {

    private static final String COLLECTION = "notifications";

    // ══════════════════════════════════════════════
    // SAVE
    // ══════════════════════════════════════════════
    public void save(NotificationDocument doc) {
        try {
            Firestore db = FirestoreClient.getFirestore();

            Map<String, Object> data = new HashMap<>();
            data.put("userId", doc.getUserId());
            data.put("title", doc.getTitle());
            data.put("body", doc.getBody());
            data.put("type", doc.getType());
            data.put("sentAt", doc.getSentAt().toString());
            data.put("read", doc.isRead());
            data.put("data", doc.getData());

            db.collection(COLLECTION).add(data);

            log.debug("✅ Notification saved for user: {}", doc.getUserId());

        } catch (Exception e) {
            log.error("❌ Failed to save notification: {}", e.getMessage());
        }
    }

    // ══════════════════════════════════════════════
    // FIND UNREAD BY USER
    // ══════════════════════════════════════════════
    public List<NotificationDocument> findUnreadByUserId(String userId)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();

        Query query = db.collection(COLLECTION)
                .whereEqualTo("userId", userId)
                .whereEqualTo("read", false)
                .orderBy("sentAt", Query.Direction.DESCENDING)
                .limit(50);

        List<NotificationDocument> notifications = new ArrayList<>();
        for (DocumentSnapshot doc : query.get().get().getDocuments()) {
            notifications.add(toDocument(doc));
        }

        return notifications;
    }

    // ══════════════════════════════════════════════
    // MARK AS READ
    // ══════════════════════════════════════════════
    public void markAsRead(String docId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        db.collection(COLLECTION).document(docId).update("read", true).get();
    }

    // ══════════════════════════════════════════════
    // CONVERTER
    // ══════════════════════════════════════════════
    @SuppressWarnings("unchecked")
    private NotificationDocument toDocument(DocumentSnapshot doc) {
        return NotificationDocument.builder()
                .userId(doc.getString("userId"))
                .title(doc.getString("title"))
                .body(doc.getString("body"))
                .type(doc.getString("type"))
                .sentAt(Instant.parse(doc.getString("sentAt")))
                .read(doc.getBoolean("read"))
                .data((Map<String, String>) doc.get("data"))
                .build();
    }
}