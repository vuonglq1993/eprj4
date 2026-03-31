import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';
import 'token_service.dart';

class SubmitResponse {
  final bool correct;
  final int pointsEarned;
  final String? correctAnswer;
  final String? explanation;
  final int totalLessonScore;

  SubmitResponse({
    required this.correct,
    required this.pointsEarned,
    this.correctAnswer,
    this.explanation,
    required this.totalLessonScore,
  });

  factory SubmitResponse.fromJson(Map<String, dynamic> json) {
    return SubmitResponse(
      correct: json['correct'] ?? false,
      pointsEarned: json['pointsEarned'] ?? 0,
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      totalLessonScore: json['totalLessonScore'] ?? 0,
    );
  }
}

class ExerciseService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  // Lấy danh sách bài tập của một bài học
  static Future<List<Question>> getExercises(String courseId, String lessonId) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/courses/$courseId/lessons/$lessonId/exercises"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => Question.fromExercise(e)).toList();
    } else {
      throw Exception("Không thể tải bài tập");
    }
  }

  static Future<SubmitResponse> submitSingle(
      String courseId,
      String lessonId,
      String exerciseId,
      String answer,
      ) async {
    final token = await TokenService.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/courses/$courseId/lessons/$lessonId/exercises/submit"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "exerciseId": exerciseId,
        "answer": answer,
      }),
    );

    if (response.statusCode == 200) {
      return SubmitResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Submit failed");
    }
  }
}