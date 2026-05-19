package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.OtpDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.*;
import java.util.Date;
import java.util.concurrent.ExecutionException;

@Slf4j
@Repository
public class FirebaseOtpRepository {

    private static final String COLLECTION = "otps";

    // ══════════════════════════════════════════════
    // SAVE
    // ══════════════════════════════════════════════
    public void save(OtpDocument doc) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = doc.getEmail() + "_" + doc.getType();

        Map<String, Object> data = new HashMap<>();
        data.put("email", doc.getEmail());
        data.put("otp", doc.getOtp());
        data.put("type", doc.getType());
        data.put("createdAt", Date.from(doc.getCreatedAt()));
        data.put("expiresAt", Date.from(doc.getExpiresAt()));
        data.put("used", doc.isUsed());
        data.put("attempts", doc.getAttempts());

        db.collection(COLLECTION).document(docId).set(data).get();
        log.debug("✅ OTP saved: {}", docId);
    }

    // ══════════════════════════════════════════════
    // FIND BY EMAIL AND TYPE
    // ══════════════════════════════════════════════
    public Optional<OtpDocument> findByEmailAndType(String email, String type)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = email + "_" + type;

        DocumentSnapshot doc = db.collection(COLLECTION).document(docId).get().get();

        if (!doc.exists()) {
            return Optional.empty();
        }

        return Optional.of(toDocument(doc));
    }

    // ══════════════════════════════════════════════
    // UPDATE ATTEMPTS
    // ══════════════════════════════════════════════
    public void updateAttempts(String email, String type, int attempts)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = email + "_" + type;

        db.collection(COLLECTION).document(docId)
                .update("attempts", attempts).get();
    }

    // ══════════════════════════════════════════════
    // MARK AS USED
    // ══════════════════════════════════════════════
    public void markAsUsed(String email, String type)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = email + "_" + type;

        db.collection(COLLECTION).document(docId)
                .update("used", true).get();
    }

    // ══════════════════════════════════════════════
    // DELETE EXPIRED
    // ══════════════════════════════════════════════
    public int deleteExpired() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();

        Query query = db.collection(COLLECTION)
                .whereLessThan("expiresAt", Instant.now().toString());

        List<QueryDocumentSnapshot> docs = query.get().get().getDocuments();

        for (DocumentSnapshot doc : docs) {
            doc.getReference().delete().get();
        }

        return docs.size();
    }

    // ══════════════════════════════════════════════
    // CONVERTER
    // ══════════════════════════════════════════════
    private OtpDocument toDocument(DocumentSnapshot doc) {
        return OtpDocument.builder()
                .email(doc.getString("email"))
                .otp(doc.getString("otp"))
                .type(doc.getString("type"))
                .createdAt(readInstant(doc, "createdAt"))
                .expiresAt(readInstant(doc, "expiresAt"))
                .used(Boolean.TRUE.equals(doc.getBoolean("used")))
                .attempts(doc.getLong("attempts") != null ? doc.getLong("attempts").intValue() : 0)
                .build();
    }

    private Instant readInstant(DocumentSnapshot doc, String field) {
        com.google.cloud.Timestamp ts = doc.getTimestamp(field);
        if (ts != null) return ts.toDate().toInstant();
        // Fallback: old data stored as Instant POJO {epochSecond, nano}
        Object raw = doc.get(field);
        if (raw instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> m = (Map<String, Object>) raw;
            Object sec = m.get("epochSecond");
            if (sec instanceof Number) {
                Object ns = m.get("nano");
                return Instant.ofEpochSecond(((Number) sec).longValue(),
                        ns instanceof Number ? ((Number) ns).intValue() : 0);
            }
        }
        return Instant.EPOCH; // unreadable → treated as expired
    }
}