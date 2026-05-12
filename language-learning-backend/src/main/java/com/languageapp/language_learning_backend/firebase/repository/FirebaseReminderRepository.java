package com.languageapp.language_learning_backend.firebase.repository;

import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.languageapp.language_learning_backend.firebase.document.ReminderSettingsDocument;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Slf4j
@Repository
public class FirebaseReminderRepository {

    private static final String COLLECTION = "reminder_settings";

    public void save(ReminderSettingsDocument doc) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Map<String, Object> data = new HashMap<>();
        data.put("userId", doc.getUserId());
        data.put("enabled", doc.isEnabled());
        data.put("hour", doc.getHour());
        data.put("minute", doc.getMinute());
        data.put("timezone", doc.getTimezone() != null ? doc.getTimezone() : "Asia/Ho_Chi_Minh");
        db.collection(COLLECTION).document(doc.getUserId()).set(data).get();
    }

    public Optional<ReminderSettingsDocument> findByUserId(String userId)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentSnapshot doc = db.collection(COLLECTION).document(userId).get().get();
        if (!doc.exists()) return Optional.empty();
        return Optional.of(toDocument(doc));
    }

    private static final int BATCH_SIZE = 500;

    /**
     * Paginated fetch — processes up to BATCH_SIZE docs per call.
     * Pass null as lastDoc for the first page, then pass the last
     * DocumentSnapshot returned to get the next page.
     * Returns empty list when no more results.
     */
    public List<ReminderSettingsDocument> findAllEnabledBatch(DocumentSnapshot lastDoc)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(COLLECTION)
                .whereEqualTo("enabled", true)
                .orderBy(FieldPath.documentId())
                .limit(BATCH_SIZE);
        if (lastDoc != null) {
            query = query.startAfter(lastDoc);
        }
        return query.get().get().getDocuments().stream()
                .map(this::toDocument)
                .collect(Collectors.toList());
    }

    /**
     * Returns the raw DocumentSnapshot for the last item in a batch,
     * used as cursor for the next page.
     */
    public DocumentSnapshot findAllEnabledBatchCursor(DocumentSnapshot lastDoc)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(COLLECTION)
                .whereEqualTo("enabled", true)
                .orderBy(FieldPath.documentId())
                .limit(BATCH_SIZE);
        if (lastDoc != null) {
            query = query.startAfter(lastDoc);
        }
        List<QueryDocumentSnapshot> docs = query.get().get().getDocuments();
        return docs.isEmpty() ? null : docs.get(docs.size() - 1);
    }

    public List<ReminderSettingsDocument> findAllEnabled()
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(COLLECTION).whereEqualTo("enabled", true);
        return query.get().get().getDocuments().stream()
                .map(this::toDocument)
                .collect(Collectors.toList());
    }

    public List<ReminderSettingsDocument> findEnabledAtTime(int hour, int minute)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(COLLECTION)
                .whereEqualTo("enabled", true)
                .whereEqualTo("hour", hour)
                .whereEqualTo("minute", minute);
        return query.get().get().getDocuments().stream()
                .map(this::toDocument)
                .collect(Collectors.toList());
    }

    private ReminderSettingsDocument toDocument(DocumentSnapshot doc) {
        return ReminderSettingsDocument.builder()
                .userId(doc.getString("userId"))
                .enabled(Boolean.TRUE.equals(doc.getBoolean("enabled")))
                .hour(Objects.requireNonNull(doc.getLong("hour"), "hour").intValue())
                .minute(Objects.requireNonNull(doc.getLong("minute"), "minute").intValue())
                .timezone(doc.getString("timezone"))
                .build();
    }
}
