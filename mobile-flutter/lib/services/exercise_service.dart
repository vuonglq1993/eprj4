import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class ExerciseService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  // Lấy danh sách câu hỏi của một bài học
  static Future<List<dynamic>> getExercises(String courseId, String lessonId) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/courses/$courseId/lessons/$lessonId/exercises"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Không thể tải bài tập");
    }
  }

  // Nộp bài để Backend lưu tiến độ (Status: COMPLETED)
  // static Future<bool> submitQuiz(String courseId, String lessonId, List<Map<String, dynamic>> answers) async {
  //   final token = await TokenService.getToken();
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/courses/$courseId/lessons/$lessonId/exercises/submit"),
  //     headers: {
  //       "Content-Type": "application/json",
  //       if (token != null) "Authorization": "Bearer $token",
  //     },
  //     body: jsonEncode({
  //       "answers": answers, // Khớp với SubmitRequest.java ở Backend
  //     }),
  //   );
  //
  //   return response.statusCode == 200;
  // }

  static Future<bool> submitSingle(
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

    print("SUBMIT BODY: ${jsonEncode({
      "exerciseId": exerciseId,
      "answer": answer,
    })}");

    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");

    return response.statusCode == 200;
  }
}