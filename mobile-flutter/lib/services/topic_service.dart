import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/topic_model.dart';
import '../models/course_model.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class TopicService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static Future<List<TopicModel>> getTopics() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/topics"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("GET TOPICS STATUS: ${response.statusCode}");
    print("GET TOPICS BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final topics = data.map((e) => TopicModel.fromJson(e)).toList();

      topics.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      return topics.where((e) => e.isActive).toList();
    } else {
      throw Exception("Lỗi khi tải danh sách chủ đề");
    }
  }

  static Future<List<Course>> getCoursesByTopic(String topicId) async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/topics/$topicId/courses"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("GET TOPIC COURSES STATUS: ${response.statusCode}");
    print("GET TOPIC COURSES BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi tải khóa học theo chủ đề");
    }
  }
}