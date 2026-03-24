import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson_model.dart';
import 'token_service.dart';

class LessonService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  static Future<Lesson> getLessonDetail(
      String courseId, String lessonId) async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/courses/$courseId/lessons/$lessonId"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return Lesson.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load lesson");
    }
  }
}