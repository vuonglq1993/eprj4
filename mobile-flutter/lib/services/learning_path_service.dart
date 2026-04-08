import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/learning_path_model.dart';
import 'token_service.dart';

class LearningPathService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/learning-paths";

  static Future<Map<String, String>> _authHeaders() async {
    final token = await TokenService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token is missing");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<LearningPathModel>> getPublishedPaths({
    String? languageId,
    String? level,
    String? kw,
    int page = 0,
    int size = 10,
  }) async {
    final token = await TokenService.getToken();

    final query = <String, String>{
      "page": "$page",
      "size": "$size",
      if (languageId != null && languageId.isNotEmpty) "languageId": languageId,
      if (level != null && level.isNotEmpty) "level": level,
      if (kw != null && kw.isNotEmpty) "kw": kw,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: query);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("GET PATHS STATUS: ${response.statusCode}");
    print("GET PATHS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Lỗi khi tải danh sách lộ trình");
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final List list = data['content'] ?? [];
    return list.map((e) => LearningPathModel.fromJson(e)).toList();
  }

  static Future<LearningPathModel> getDetail(String id) async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("GET PATH DETAIL STATUS: ${response.statusCode}");
    print("GET PATH DETAIL BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Lỗi khi tải chi tiết lộ trình");
    }

    return LearningPathModel.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
  }

  static Future<bool> enroll(String id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$id/enroll"),
      headers: await _authHeaders(),
    );

    print("ENROLL STATUS: ${response.statusCode}");
    print("ENROLL BODY: ${response.body}");

    return response.statusCode == 200;
  }

  static Future<bool> unenroll(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id/enroll"),
      headers: await _authHeaders(),
    );

    print("UNENROLL STATUS: ${response.statusCode}");
    print("UNENROLL BODY: ${response.body}");

    return response.statusCode == 204;
  }

  static Future<List<LearningPathModel>> getMyPaths() async {
    final response = await http.get(
      Uri.parse("$baseUrl/my"),
      headers: await _authHeaders(),
    );

    print("GET MY PATHS STATUS: ${response.statusCode}");
    print("GET MY PATHS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Lỗi khi tải lộ trình của tôi");
    }

    final List list = jsonDecode(utf8.decode(response.bodyBytes));
    return list.map((e) => LearningPathModel.fromJson(e)).toList();
  }
}