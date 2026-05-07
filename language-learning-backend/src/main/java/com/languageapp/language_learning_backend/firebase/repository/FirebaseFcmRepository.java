package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.FcmTokenDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Slf4j
@Repository
public class FirebaseFcmRepository {

    private static final String COLLECTION = "fcm_tokens";

    // ══════════════════════════════════════════════
    // SAVE
    // ══════════════════════════════════════════════
    public void save(FcmTokenDocument doc) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = doc.getUserId() + "_" + doc.getDeviceType();

        Map<String, Object> data = new HashMap<>();
        data.put("userId", doc.getUserId());
        data.put("token", doc.getToken());
        data.put("deviceType", doc.getDeviceType());
        data.put("createdAt", doc.getCreatedAt().toString());
        data.put("lastUsedAt", doc.getLastUsedAt().toString());
        data.put("active", doc.isActive());

        db.collection(COLLECTION).document(docId).set(data).get();
        log.debug("✅ FCM token saved: {}", docId);
    }

    // ══════════════════════════════════════════════
    // FIND BY USER ID
    // ══════════════════════════════════════════════
    public List<FcmTokenDocument> findByUserId(String userId)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();

        Query query = db.collection(COLLECTION)
                .whereEqualTo("userId", userId)
                .whereEqualTo("active", true);

        return query.get().get().getDocuments().stream()
                .map(this::toDocument)
                .collect(Collectors.toList());
    }

    // ══════════════════════════════════════════════
    // GET TOKENS BY USER ID
    // ══════════════════════════════════════════════
    public List<String> getTokensByUserId(String userId)
            throws ExecutionException, InterruptedException {
        return findByUserId(userId).stream()
                .map(FcmTokenDocument::getToken)
                .collect(Collectors.toList());
    }

    // ══════════════════════════════════════════════
    // DELETE BY TOKEN
    // ══════════════════════════════════════════════
    public void deleteByToken(String token) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();

        Query query = db.collection(COLLECTION)
                .whereEqualTo("token", token);

        for (DocumentSnapshot doc : query.get().get().getDocuments()) {
            doc.getReference().delete().get();
        }

        log.debug("🗑️ FCM token deleted: {}", token);
    }

    // ══════════════════════════════════════════════
    // DELETE BY USER ID + DEVICE TYPE
    // ══════════════════════════════════════════════
    public void deleteByUserIdAndDeviceType(String userId, String deviceType)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = userId + "_" + deviceType;
        db.collection(COLLECTION).document(docId).delete().get();
        log.debug("🗑️ FCM token deleted: {}", docId);
    }

    // ══════════════════════════════════════════════
    // UPDATE LAST USED
    // ══════════════════════════════════════════════
    public void updateLastUsed(String userId, String deviceType)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        String docId = userId + "_" + deviceType;

        db.collection(COLLECTION).document(docId)
                .update("lastUsedAt", Instant.now().toString()).get();
    }

    // ══════════════════════════════════════════════
    // GET ALL ACTIVE TOKENS
    // ══════════════════════════════════════════════
    public List<FcmTokenDocument> getAllActiveTokens()
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        QuerySnapshot qs = db.collection(COLLECTION)
                .whereEqualTo("active", true)
                .get().get();
        return qs.getDocuments().stream()
                .map(this::toDocument)
                .collect(Collectors.toList());
    }

    // ══════════════════════════════════════════════
    // CONVERTER
    // ══════════════════════════════════════════════
    private FcmTokenDocument toDocument(DocumentSnapshot doc) {
        return FcmTokenDocument.builder()
                .userId(doc.getString("userId"))
                .token(doc.getString("token"))
                .deviceType(doc.getString("deviceType"))
                .createdAt(Instant.parse(doc.getString("createdAt")))
                .lastUsedAt(Instant.parse(doc.getString("lastUsedAt")))
                .active(doc.getBoolean("active"))
                .build();
    }
}