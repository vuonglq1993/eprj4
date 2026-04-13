import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_recommend_model.dart';
import 'token_service.dart';

class AiRecommendService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/ai/recommend";

  static Future<Map<String, dynamic>> recommend(
      RecommendRequestModel request,
      ) async {
    final token = await TokenService.getToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Map<String, dynamic>.from(data as Map);
    }

    throw Exception("Recommend failed: ${response.statusCode}");
  }
}