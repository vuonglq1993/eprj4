package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.BroadcastHistoryDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.*;

@Slf4j
@Repository
public class BroadcastHistoryRepository {

    private static final String COLLECTION = "app_notifications";

    public void save(BroadcastHistoryDocument doc) {
        try {
            Firestore db = FirestoreClient.getFirestore();

            Map<String, Object> data = new LinkedHashMap<>();
            data.put("title", doc.getTitle());
            data.put("body", doc.getBody());
            data.put("type", doc.getType());
            data.put("sentBy", doc.getSentBy());
            data.put("sentAt", doc.getSentAt() != null ? doc.getSentAt().toString() : null);
            data.put("target", doc.getTarget());
            data.put("recipientCount", doc.getRecipientCount());

            DocumentReference ref = db.collection(COLLECTION).document();
            ref.set(data).get();
            log.debug("✅ Broadcast history saved: {}", ref.getId());

        } catch (Exception e) {
            log.error("❌ Failed to save broadcast history: {}", e.getMessage());
        }
    }

    public List<BroadcastHistoryDocument> findRecent(int limit) {
        List<BroadcastHistoryDocument> result = new ArrayList<>();
        try {
            Firestore db = FirestoreClient.getFirestore();

            QuerySnapshot qs = db.collection(COLLECTION)
                    .orderBy("sentAt", Query.Direction.DESCENDING)
                    .limit(limit)
                    .get().get();

            for (QueryDocumentSnapshot snap : qs.getDocuments()) {
                result.add(toDocument(snap.getId(), snap));
            }
        } catch (Exception e) {
            log.error("❌ Failed to fetch broadcast history: {}", e.getMessage());
        }
        return result;
    }

    private BroadcastHistoryDocument toDocument(String id, DocumentSnapshot snap) {
        Date sentAt = null;
        Object sentAtVal = snap.get("sentAt");
        if (sentAtVal instanceof Date) {
            sentAt = (Date) sentAtVal;
        } else if (sentAtVal instanceof String) {
            try { sentAt = new Date(Long.parseLong((String) sentAtVal)); } catch (Exception ignored) {}
        }

        return BroadcastHistoryDocument.builder()
                .id(id)
                .title(snap.getString("title"))
                .body(snap.getString("body"))
                .type(snap.getString("type"))
                .sentBy(snap.getString("sentBy"))
                .sentAt(sentAt)
                .target(snap.getString("target"))
                .recipientCount(snap.contains("recipientCount") ? Objects.requireNonNull(snap.getLong("recipientCount")).intValue() : 0)
                .build();
    }
}
