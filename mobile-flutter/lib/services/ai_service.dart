import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';

class AiChatMessage {
  final String role; // 'user' | 'assistant'
  final String text;
  final DateTime time;

  AiChatMessage({required this.role, required this.text, DateTime? time})
      : time = time ?? DateTime.now();
}

class AiChatResult {
  final String reply;
  final int remainingToday;
  AiChatResult({required this.reply, required this.remainingToday});
}

// ── Grammar check models ───────────────────────────────────────────────────

class GrammarError {
  final String type;        // GRAMMAR | SPELLING | PUNCTUATION
  final String wrong;
  final String correct;
  final String explanation;
  final String rule;

  GrammarError({
    required this.type,
    required this.wrong,
    required this.correct,
    required this.explanation,
    required this.rule,
  });

  factory GrammarError.fromJson(Map<String, dynamic> j) => GrammarError(
        type: j['type'] as String? ?? '',
        wrong: j['wrong'] as String? ?? '',
        correct: j['correct'] as String? ?? '',
        explanation: j['explanation'] as String? ?? '',
        rule: j['rule'] as String? ?? '',
      );
}

class GrammarCheckResult {
  final String original;
  final String corrected;
  final bool isCorrect;
  final List<GrammarError> errors;
  final String betterExpression;
  final String tip;

  GrammarCheckResult({
    required this.original,
    required this.corrected,
    required this.isCorrect,
    required this.errors,
    required this.betterExpression,
    required this.tip,
  });

  factory GrammarCheckResult.fromJson(Map<String, dynamic> j) =>
      GrammarCheckResult(
        original: j['original'] as String? ?? '',
        corrected: j['corrected'] as String? ?? '',
        isCorrect: j['isCorrect'] as bool? ?? false,
        errors: ((j['errors'] as List?) ?? [])
            .map((e) => GrammarError.fromJson(e as Map<String, dynamic>))
            .toList(),
        betterExpression: j['betterExpression'] as String? ?? '',
        tip: j['tip'] as String? ?? '',
      );
}

// ── Recommend models ───────────────────────────────────────────────────────

class AiRecommendLesson {
  final String lessonId;
  final String title;
  final String reason;
  final int priority;

  AiRecommendLesson({
    required this.lessonId,
    required this.title,
    required this.reason,
    required this.priority,
  });

  factory AiRecommendLesson.fromJson(
          Map<String, dynamic> j, Map<String, String> titleMap) =>
      AiRecommendLesson(
        lessonId: j['lessonId'] as String? ?? '',
        title: titleMap[j['lessonId']] ?? j['lessonTitle'] as String? ?? '',
        reason: j['reason'] as String? ?? '',
        priority: (j['priority'] as num?)?.toInt() ?? 0,
      );
}

class AiRecommendResult {
  final List<AiRecommendLesson> lessons;
  final List<String> focusSkills;
  final String studyTip;

  AiRecommendResult({
    required this.lessons,
    required this.focusSkills,
    required this.studyTip,
  });

  factory AiRecommendResult.fromJson(
          Map<String, dynamic> j, Map<String, String> titleMap) =>
      AiRecommendResult(
        lessons: ((j['recommendedLessons'] as List?) ?? [])
            .map((e) => AiRecommendLesson.fromJson(
                e as Map<String, dynamic>, titleMap))
            .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority)),
        focusSkills: ((j['focusSkills'] as List?) ?? []).cast<String>(),
        studyTip: j['studyTip'] as String? ?? '',
      );
}

// ── Pronunciation models ───────────────────────────────────────────────────

class PronunciationResult {
  final int score;
  final String cefrLevel;
  final String feedback;
  final String phonemeErrors;
  final String improvement;

  PronunciationResult({
    required this.score,
    required this.cefrLevel,
    required this.feedback,
    required this.phonemeErrors,
    required this.improvement,
  });

  factory PronunciationResult.fromJson(Map<String, dynamic> j) =>
      PronunciationResult(
        score: (j['score'] as num?)?.toInt() ?? 0,
        cefrLevel: j['cefrLevel'] as String? ?? '',
        feedback: _asString(j['feedback']),
        phonemeErrors: _asString(j['phonemeErrors']),
        improvement: _asString(j['improvement']),
      );

  static String _asString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is List) return v.map((e) => '• $e').join('\n');
    return v.toString();
  }
}

// ── Service ────────────────────────────────────────────────────────────────

class AiService {
  static String get _base => AppConfig.baseUrl;

  static Future<Map<String, String>> _auth() async {
    final token = await TokenService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Chat với AI gia sư. Returns null on error.
  static Future<AiChatResult?> chat({
    required String message,
    String cefrLevel = 'B1',
    String? lessonId,
    String? lessonTitle,
    String? lessonContent,
  }) async {
    try {
      final body = <String, dynamic>{
        'message': message,
        'cefrLevel': cefrLevel,
        if (lessonId != null) 'lessonId': lessonId,
        if (lessonTitle != null) 'lessonTitle': lessonTitle,
        if (lessonContent != null) 'lessonContent': lessonContent,
      };
      final res = await http.post(
        Uri.parse('$_base/ai/chat'),
        headers: await _auth(),
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return AiChatResult(
          reply: data['reply'] as String? ?? '',
          remainingToday: (data['remainingToday'] as num?)?.toInt() ?? 0,
        );
      }
      if (res.statusCode == 429) {
        return AiChatResult(
          reply: '⚠️ Bạn đã đạt giới hạn chat hôm nay. Hãy quay lại vào ngày mai nhé!',
          remainingToday: 0,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Tra từ vựng đầy đủ. Trả về `(data, null)` nếu thành công,
  /// `(null, errorMessage)` nếu lỗi.
  static Future<({Map<String, dynamic>? data, String? error})>
      generateVocab({
    required String word,
    String cefrLevel = 'B1',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/ai/vocab/generate'),
        headers: await _auth(),
        body: jsonEncode({'word': word, 'cefrLevel': cefrLevel}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          return (data: decoded, error: null);
        }
        return (data: null, error: 'Dữ liệu trả về không hợp lệ.');
      }
      // Lấy message lỗi từ backend
      final errMsg = _extractError(res.body, res.statusCode);
      return (data: null, error: errMsg);
    } catch (e) {
      return (data: null, error: 'Lỗi kết nối. Vui lòng kiểm tra mạng.');
    }
  }

  /// Trích message lỗi từ body JSON của backend.
  static String _extractError(String body, int statusCode) {
    try {
      final j = jsonDecode(body);
      if (j is Map) {
        final msg = j['message'] ?? j['error'] ?? j['detail'];
        if (msg != null) return msg.toString();
      }
    } catch (_) {}
    if (statusCode == 403) return 'Đã đạt giới hạn sử dụng AI hôm nay. Hãy thử lại vào ngày mai.';
    if (statusCode == 401) return 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
    if (statusCode == 429) return 'Quá nhiều yêu cầu. Vui lòng thử lại sau ít phút.';
    return 'Đã xảy ra lỗi (HTTP $statusCode). Vui lòng thử lại.';
  }

  /// Kiểm tra ngữ pháp. Returns null on error.
  static Future<GrammarCheckResult?> checkGrammar({
    required String text,
    String cefrLevel = 'B1',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/ai/grammar/check'),
        headers: await _auth(),
        body: jsonEncode({'text': text, 'cefrLevel': cefrLevel}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return GrammarCheckResult.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Gợi ý bài học dựa trên dữ liệu học của user.
  static Future<AiRecommendResult?> getRecommendations({
    Map<String, dynamic>? dashboard,
    List<Map<String, dynamic>>? learningPaths,
  }) async {
    try {
      final avgScore = (dashboard?['averageScore'] as num?)?.toDouble() ?? 0.0;

      // All 6 skills with scores
      final skillsRaw = dashboard?['skills'] as Map<String, dynamic>?;
      final allSkills = <String, dynamic>{};
      final weakSkills = <String>[];
      if (skillsRaw != null) {
        skillsRaw.forEach((skill, val) {
          final avg = (val as Map<String, dynamic>?)?['averageScore'] as num?;
          final score = avg?.toDouble() ?? 0.0;
          allSkills[_capitalizeSkill(skill)] = score;
          if (score < 60) weakSkills.add(_capitalizeSkill(skill));
        });
      }

      final titleMap = <String, String>{};
      final availableLessons = <Map<String, dynamic>>[];

      // Lessons from active courses (dashboard)
      final activeCourses = (dashboard?['activeCourses'] as List?) ?? [];
      for (final c in activeCourses.cast<Map<String, dynamic>>()) {
        final nextId = c['nextLessonId'] as String?;
        final nextTitle = c['nextLessonTitle'] as String? ?? '';
        if (nextId != null) {
          availableLessons.add({
            'id': nextId,
            'title': nextTitle,
            'source': 'course',
            'courseName': c['courseTitle'] as String? ?? '',
          });
          titleMap[nextId] = nextTitle;
        }
      }

      // Lessons from enrolled learning paths
      if (learningPaths != null) {
        for (final path in learningPaths) {
          final pathName = path['name'] as String? ?? path['title'] as String? ?? '';
          final courses = (path['courses'] as List?) ?? [];
          for (final course in courses.cast<Map<String, dynamic>>()) {
            final lessons = (course['lessons'] as List?) ?? [];
            for (final lesson in lessons.cast<Map<String, dynamic>>()) {
              final id = lesson['id'] as String?;
              final title = lesson['title'] as String? ?? '';
              final completed = lesson['completed'] as bool? ?? false;
              if (id != null && !completed) {
                availableLessons.add({
                  'id': id,
                  'title': title,
                  'source': 'learningPath',
                  'pathName': pathName,
                  'skill': lesson['skill'] as String? ?? '',
                  'cefrLevel': lesson['cefrLevel'] as String? ?? '',
                });
                titleMap[id] = title;
              }
            }
          }
        }
      }

      final body = <String, dynamic>{
        'avgScore': avgScore,
        'allSkills': allSkills,
        'weakSkills': weakSkills,
        'learningPace': 'NORMAL',
        'completedLessonIds': <String>[],
        'availableLessons': availableLessons,
      };

      final res = await http.post(
        Uri.parse('$_base/ai/recommend'),
        headers: await _auth(),
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        if (data is Map<String, dynamic>) {
          return AiRecommendResult.fromJson(data, titleMap);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Upload audio phát âm lên Cloudinary qua backend (không lưu DB).
  static Future<String?> uploadPronunciationAudio(File audioFile) async {
    try {
      final token = await TokenService.getAccessToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_base/ai/pronunciation/upload'),
      );
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', audioFile.path));
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final json = jsonDecode(body) as Map<String, dynamic>;
        return json['audioUrl'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Phân tích phát âm từ audio URL (Cloudinary).
  static Future<PronunciationResult?> analyzePronunciation({
    required String targetText,
    required String audioUrl,
    String cefrLevel = 'B1',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/ai/pronunciation/analyze-audio'),
        headers: await _auth(),
        body: jsonEncode({
          'targetText': targetText,
          'audioUrl': audioUrl,
          'cefrLevel': cefrLevel,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return PronunciationResult.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static String _capitalizeSkill(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}
