import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_vocab_model.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class AiVocabService {
  static String get generateUrl =>
      "${AppConfig.apiBaseUrl}/ai/vocab/generate";
  static String get gameUrl =>
      "${AppConfig.apiBaseUrl}/ai/vocab/game";

  static Future<Map<String, dynamic>> generateWordData(
      VocabRequestModel request,
      ) async {
    final token = await TokenService.getToken();

    final response = await http.post(
      Uri.parse(generateUrl),
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

    throw Exception("Vocab generate failed: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> generateGameQuestion(
      VocabGameRequestModel request,
      ) async {
    final token = await TokenService.getToken();

    final response = await http.post(
      Uri.parse(gameUrl),
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

    throw Exception("Vocab game failed: ${response.statusCode}");
  }
}