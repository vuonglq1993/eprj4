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
        log.debug("✅ Reminder settings saved for user {}", doc.getUserId());
    }

    public Optional<ReminderSettingsDocument> findByUserId(String userId)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentSnapshot doc = db.collection(COLLECTION).document(userId).get().get();
        if (!doc.exists()) return Optional.empty();
        return Optional.of(toDocument(doc));
    }

    /** Lấy tất cả user có enabled=true và hour == giờ hiện tại */
    public List<ReminderSettingsDocument> findEnabledAtHour(int hour)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(COLLECTION)
                .whereEqualTo("enabled", true)
                .whereEqualTo("hour", hour);
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
