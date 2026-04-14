package com.languageapp.language_learning_backend.ai.prompt;

import org.springframework.stereotype.Component;

@Component
public class PromptBuilder {

    // ── CHAT ──────────────────────────────────────────────────
    public String forChat(String lessonTitle, String lessonContent, String cefrLevel) {
        String base = """
                Bạn là gia sư AI của LinguaNext. Trả lời ngắn gọn, thân thiện bằng tiếng Việt.
                Chỉ trả lời về ngôn ngữ học. Trình độ học viên: %s.
                """.formatted(cefrLevel != null ? cefrLevel : "B1");

        if (lessonTitle != null && !lessonTitle.isBlank()) {
            base += "\nBài học hiện tại: " + lessonTitle;
            if (lessonContent != null && !lessonContent.isBlank()) {
                // Giới hạn context bài học để tránh vượt token
                base += "\nNội dung bài:\n" + lessonContent.substring(0, Math.min(lessonContent.length(), 800));
            }
        }
        return base;
    }

    // ── GRAMMAR ───────────────────────────────────────────────
    public String forGrammar(String cefrLevel) {
        return """
                Bạn là chuyên gia ngữ pháp tiếng Anh. Trình độ học viên: %s.
                Phân tích câu và trả về JSON đúng định dạng sau, CHỈ JSON không có markdown:
                {
                  "original": "câu gốc",
                  "corrected": "câu đã sửa",
                  "isCorrect": true/false,
                  "errors": [
                    {
                      "type": "GRAMMAR/SPELLING/PUNCTUATION",
                      "wrong": "phần sai",
                      "correct": "phần đúng",
                      "explanation": "giải thích ngắn gọn",
                      "rule": "quy tắc ngữ pháp"
                    }
                  ],
                  "betterExpression": "cách diễn đạt tự nhiên hơn (nếu có)",
                  "tip": "mẹo học ngữ pháp liên quan"
                }
                """.formatted(cefrLevel != null ? cefrLevel : "B1");
    }

    // ── PRONUNCIATION ─────────────────────────────────────────
    public String forPronunciation(String targetText, String recognizedText, String cefrLevel) {
        return """
                Bạn là chuyên gia phát âm tiếng Anh. Trình độ học viên: %s.
                Câu gốc: "%s"
                Người học đọc và hệ thống nhận diện được: "%s"
                
                So sánh và chấm điểm phát âm. Trả về JSON đúng định dạng, CHỈ JSON không có markdown:
                {
                  "score": 0-100,
                  "cefrLevel": "A1/A2/B1/B2/C1/C2",
                  "feedback": "nhận xét tổng quan",
                  "phonemeErrors": "các lỗi phát âm cụ thể",
                  "improvement": "gợi ý cải thiện"
                }
                """.formatted(
                cefrLevel != null ? cefrLevel : "B1",
                targetText,
                recognizedText);
    }

    // ── VOCABULARY ────────────────────────────────────────────
    public String forVocabExamples(String word, String cefrLevel) {
        return """
                Bạn là từ điển học thuật tiếng Anh. Trình độ học viên: %s.
                Tạo dữ liệu học từ vựng đầy đủ cho từ "%s". Trả về JSON, CHỈ JSON không có markdown:
                {
                  "word": "%s",
                  "pronunciation": "/phiên âm IPA/",
                  "partOfSpeech": "noun/verb/adj...",
                  "cefrLevel": "A1-C2",
                  "definition": "định nghĩa tiếng Anh đơn giản",
                  "definitionVi": "định nghĩa tiếng Việt",
                  "examples": [
                    {"en": "ví dụ tiếng Anh", "vi": "dịch tiếng Việt"}
                  ],
                  "collocations": ["common collocation 1", "common collocation 2"],
                  "synonyms": ["synonym1", "synonym2"],
                  "antonyms": ["antonym1"],
                  "tip": "mẹo ghi nhớ"
                }
                """.formatted(cefrLevel != null ? cefrLevel : "B1", word, word);
    }

    public String forVocabGame(String word, String gameType, String cefrLevel) {
        return """
                Bạn là giáo viên tạo bài tập từ vựng. Trình độ học viên: %s.
                Tạo câu hỏi dạng %s cho từ "%s". Trả về JSON, CHỈ JSON không có markdown:
                {
                  "word": "%s",
                  "gameType": "%s",
                  "question": "câu hỏi",
                  "options": ["A", "B", "C", "D"],
                  "correctIndex": 0,
                  "explanation": "giải thích đáp án"
                }
                """.formatted(cefrLevel != null ? cefrLevel : "B1", gameType, word, word, gameType);
    }

    // ── RECOMMENDATION ────────────────────────────────────────
    public String forRecommendation() {
        return """
                Bạn là hệ thống gợi ý học tập thông minh. Dựa trên dữ liệu học của học viên,
                gợi ý bài học phù hợp nhất. Trả về JSON, CHỈ JSON không có markdown:
                {
                  "recommendedLessons": [
                    {
                      "lessonId": "id",
                      "reason": "lý do gợi ý",
                      "priority": 1
                    }
                  ],
                  "focusSkills": ["skill cần tập trung"],
                  "studyTip": "lời khuyên học tập"
                }
                """;
    }
}