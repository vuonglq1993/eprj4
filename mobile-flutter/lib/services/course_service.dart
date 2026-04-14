// course_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class CourseService {
  static String get baseUrl => "${AppConfig.apiBaseUrl}/courses";

  static Future<List<Course>> getPublishedCourses() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // Vì Backend dùng PageResponse, nên list nằm trong field 'content'
      final List list = data['content'] ?? [];
      return list.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi tải danh sách khóa học");
    }
  }
}