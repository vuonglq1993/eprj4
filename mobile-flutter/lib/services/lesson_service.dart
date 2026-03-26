import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson_model.dart';
import 'token_service.dart';

class LessonService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  // Lấy danh sách bài học của một khóa học
  static Future<List<Lesson>> getLessonsByCourse(String courseId) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/courses/$courseId/lessons"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => Lesson.fromJson(e)).toList();
    } else {
      throw Exception("Không thể tải danh sách bài học");
    }
  }

  // Lấy chi tiết bài học (bao gồm content)
  static Future<Lesson> getLessonDetail(String courseId, String lessonId) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/courses/$courseId/lessons/$lessonId"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return Lesson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Failed to load lesson");
    }
  }
}