import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_pronunciation_model.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class AiPronunciationService {
  static String get baseUrl =>
      "${AppConfig.apiBaseUrl}/ai/pronunciation/analyze";

  static Future<PronunciationResponseModel> analyze(
      PronunciationRequestModel request,
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
      return PronunciationResponseModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    }

    throw Exception("Pronunciation analyze failed: ${response.statusCode}");
  }
}