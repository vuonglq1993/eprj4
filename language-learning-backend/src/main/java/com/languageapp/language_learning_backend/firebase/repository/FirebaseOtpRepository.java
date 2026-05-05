package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.OtpDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.*;
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
        data.put("createdAt", doc.getCreatedAt());
        data.put("expiresAt", doc.getExpiresAt());
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
                .createdAt(doc.getTimestamp("createdAt").toDate().toInstant())
                .expiresAt(doc.getTimestamp("expiresAt").toDate().toInstant())
                .used(doc.getBoolean("used"))
                .attempts(doc.getLong("attempts").intValue())
                .build();
    }
}