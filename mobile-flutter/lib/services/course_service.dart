// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/course_model.dart';
// import 'token_service.dart';
//
// class CourseService {
//   static const String baseUrl =
//       "http://10.0.2.2:8080/api/v1/courses";
//
//   static Future<List<Course>> getCourses() async {
//     final token = await TokenService.getToken();
//
//     final response = await http.get(
//       Uri.parse(baseUrl),
//       headers: {
//         "Content-Type": "application/json",
//         if (token != null) "Authorization": "Bearer $token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List list = data['content'];
//       return list.map((e) => Course.fromJson(e)).toList();
//     } else {
//       throw Exception("Failed to load courses");
//     }
//   }
// }




import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';
import 'token_service.dart';

class CourseService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  // ===== GET LESSONS =====
  static Future<List<dynamic>> getLessons(String courseId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/courses/$courseId/lessons"),
      headers: {
        "Authorization": "Bearer ${await TokenService.getToken()}",
      },
    );

    return jsonDecode(res.body);
  }

  // ===== GET EXERCISES =====
  static Future<List<Question>> getExercises(
      String courseId, String lessonId) async {
    final res = await http.get(
      Uri.parse(
          "$baseUrl/courses/$courseId/lessons/$lessonId/exercises"),
      headers: {
        "Authorization": "Bearer ${await TokenService.getToken()}",
      },
    );

    final data = jsonDecode(res.body);
    return data.map<Question>((e) => Question.fromExercise(e)).toList();
  }

  // ===== SUBMIT =====
  static Future<Map<String, dynamic>> submit(
      String courseId,
      String lessonId,
      String exerciseId,
      String answer) async {
    final res = await http.post(
      Uri.parse(
          "$baseUrl/courses/$courseId/lessons/$lessonId/exercises/submit"),
      headers: {
        "Authorization": "Bearer ${await TokenService.getToken()}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "exerciseId": exerciseId,
        "answer": answer,
      }),
    );

    return jsonDecode(res.body);
  }
}