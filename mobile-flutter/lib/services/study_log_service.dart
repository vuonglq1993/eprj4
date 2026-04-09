// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'token_service.dart'; // File quản lý Token của bạn
//
// class StudyLogService {
//   static const String baseUrl = "http://10.0.2.2:8080/api/v1/study-logs";
//
//   // Gọi POST /api/v1/study-logs khi hoàn thành bài học
//   static Future<void> logStudySession({
//     required String lessonId,
//     required int durationSeconds,
//     required int score,
//     required String activityType, // LESSON_VIEW, EXERCISE_SUBMIT...
//   }) async {
//     final token = await TokenService.getToken();
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "lessonId": lessonId,
//           "durationSeconds": durationSeconds,
//           "score": score,
//           "activityType": activityType,
//         }),
//       );
//       if (response.statusCode != 204) {
//         print("Lỗi ghi log: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Lỗi kết nối API log: $e");
//     }
//   }
//
//   // Gọi GET /api/v1/study-logs/streak để lấy dữ liệu biểu đồ và streak
//   static Future<Map<String, dynamic>?> getStreakData() async {
//     final token = await TokenService.getToken();
//     try {
//       final response = await http.get(
//         Uri.parse("$baseUrl/streak"),
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(utf8.decode(response.bodyBytes));
//       }
//     } catch (e) {
//       print("Lỗi lấy streak: $e");
//     }
//     return null;
//   }
//
//
//
//
//
//
//   static Future<List<dynamic>> getStudyHistoryRaw() async {
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
//       return jsonDecode(utf8.decode(response.bodyBytes));
//     } else {
//       throw Exception("Không lấy được study logs");
//     }
//   }
// }



//bản mới nối task
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class StudyLogService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/study-logs";

  static Future<void> logStudySession({
    required String lessonId,
    required int durationSeconds,
    required int score,
    required String activityType,
  }) async {
    final token = await TokenService.getToken();
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "lessonId": lessonId,
          "durationSeconds": durationSeconds,
          "score": score,
          "activityType": activityType,
        }),
      );

      if (response.statusCode != 204) {
        print("Lỗi ghi log: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Lỗi kết nối API log: $e");
    }
  }

  static Future<Map<String, dynamic>?> getStreakData() async {
    final token = await TokenService.getToken();
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/streak"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print("Lỗi lấy streak: $e");
    }
    return null;
  }

  // ✅ Dùng cho TaskPage
  static Future<Map<String, dynamic>> getWeeklyLogs() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/weekly"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } else {
      throw Exception("Không lấy được weekly study logs: ${response.statusCode}");
    }
  }
}