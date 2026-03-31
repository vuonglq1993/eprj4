import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson_model.dart';
import 'token_service.dart';

class LessonService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  // Lấy danh sách bài học của một khóa học
  // static Future<List<Lesson>> getLessonsByCourse(String courseId) async {
  //   final token = await TokenService.getToken();
  //   final url = "$baseUrl/courses/$courseId/lessons";
  //   print("GET LESSONS URL: $url");
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         if (token != null) "Authorization": "Bearer $token",
  //       },
  //     ).timeout(const Duration(seconds: 15));
  //
  //     print("GET LESSONS STATUS: ${response.statusCode}");
  //
  //     if (response.statusCode == 200) {
  //       final dynamic decodedData = jsonDecode(utf8.decode(response.bodyBytes));
  //       List<dynamic> list;
  //
  //       // Kiểm tra nếu Backend trả về PageResponse hoặc List trực tiếp
  //       if (decodedData is Map && decodedData.containsKey('content')) {
  //         list = decodedData['content'] ?? [];
  //       } else if (decodedData is List) {
  //         list = decodedData;
  //       } else {
  //         list = [];
  //       }
  //
  //       return list.map((e) => Lesson.fromJson(e)).toList();
  //     } else {
  //       throw Exception("Lỗi ${response.statusCode}: Không thể tải danh sách bài học");
  //     }
  //   } catch (e) {
  //     print("GET LESSONS EXCEPTION: $e");
  //     throw Exception("Lỗi kết nối server: $e");
  //   }
  // }



  static Future<List<Lesson>> getLessonsByCourse(String courseId) async {
    final token = await TokenService.getToken();
    // Đảm bảo URL đúng cấu trúc Backend: /api/v1/courses/{courseId}/lessons
    final url = "$baseUrl/courses/$courseId/lessons";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        // Backend của bạn trả về List<LessonDetailResponse> trực tiếp
        if (decodedData is List) {
          return decodedData.map((e) => Lesson.fromJson(e)).toList();
        }
        // Trường hợp nếu có bọc trong 'content' (PageResponse)
        else if (decodedData is Map && decodedData.containsKey('content')) {
          final List list = decodedData['content'] ?? [];
          return list.map((e) => Lesson.fromJson(e)).toList();
        }
        return [];
      } else {
        // In ra body lỗi từ Backend để debug (rất quan trọng)
        print("SERVER ERROR BODY: ${response.body}");
        throw Exception("Lỗi ${response.statusCode}: Server không trả về dữ liệu");
      }
    } catch (e) {
      print("GET LESSONS EXCEPTION: $e");
      throw Exception("Không thể kết nối server");
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