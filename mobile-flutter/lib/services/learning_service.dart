import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';

class LearningService {
  static String get _base => AppConfig.baseUrl;

  static Future<Map<String, String>> _auth() async {
    final token = await TokenService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── Dashboard ───────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/dashboard'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── Learning Paths ──────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getMyLearningPaths() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/learning-paths/my'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // may be List or PageResponse {content: [...]}
        if (body is List) return body.cast<Map<String, dynamic>>();
        if (body is Map && body['content'] is List) {
          return (body['content'] as List).cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPublicLearningPaths({
    String? languageCode,
  }) async {
    try {
      final query = languageCode != null
          ? '?languageCode=${Uri.encodeComponent(languageCode)}'
          : '';
      final res = await http.get(
        Uri.parse('$_base/learning-paths$query'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body is List) return body.cast<Map<String, dynamic>>();
        if (body is Map && body['content'] is List) {
          return (body['content'] as List).cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getLearningPathDetail(
      String id) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/learning-paths/$id'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> enrollLearningPath(String id) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/learning-paths/$id/enroll'),
        headers: await _auth(),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // ─── Courses ─────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getCourseDetail(
      String courseId) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/courses/$courseId'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── Lessons ─────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getLessons(
      String courseId) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/courses/$courseId/lessons'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body is List) return body.cast<Map<String, dynamic>>();
        if (body is Map && body['content'] is List) {
          return (body['content'] as List).cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getLessonDetail(
      String courseId, String lessonId) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/courses/$courseId/lessons/$lessonId'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── Exercises ───────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getExercises(
      String courseId, String lessonId) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/courses/$courseId/lessons/$lessonId/exercises'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body is List) return body.cast<Map<String, dynamic>>();
        if (body is Map && body['content'] is List) {
          return (body['content'] as List).cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Submit một exercise. Trả về SubmitResponse hoặc null nếu lỗi.
  static Future<Map<String, dynamic>?> submitExercise({
    required String courseId,
    required String lessonId,
    required String exerciseId,
    required dynamic answer, // Map, int, String — bất kỳ kiểu JSON nào
    required int clientStartMs,
    required int clientSubmitMs,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
            '$_base/courses/$courseId/lessons/$lessonId/exercises/submit'),
        headers: await _auth(),
        body: jsonEncode({
          'exerciseId': exerciseId,
          'answer': answer,
          'clientStartTime': clientStartMs,
          'clientSubmitTime': clientSubmitMs,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── Progress ────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getCourseProgress(
      String courseId) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/progress/courses/$courseId'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body is List) return body.cast<Map<String, dynamic>>();
        if (body is Map && body['content'] is List) {
          return (body['content'] as List).cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ─── Study logs ──────────────────────────────────────────────────────────

  static Future<void> logStudy({
    required String lessonId,
    required int durationSeconds,
    required String activityType, // LESSON_VIEW | EXERCISE_SUBMIT | ...
    int score = 0,
  }) async {
    try {
      await http.post(
        Uri.parse('$_base/study-logs'),
        headers: await _auth(),
        body: jsonEncode({
          'lessonId': lessonId,
          'durationSeconds': durationSeconds,
          'activityType': activityType,
          'score': score,
        }),
      );
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> getStreak() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/study-logs/streak'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
