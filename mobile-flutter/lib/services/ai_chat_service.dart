import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_chat_model.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class AiChatService {
  static String get baseUrl => "${AppConfig.apiBaseUrl}/ai/chat";

  static Future<AiChatResponseModel> sendMessage(
      AiChatRequestModel request,
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
      return AiChatResponseModel.fromJson(data);
    }

    String message = "AI chat failed (${response.statusCode})";
    try {
      final errorData = jsonDecode(utf8.decode(response.bodyBytes));
      if (errorData is Map<String, dynamic>) {
        message = errorData["message"]?.toString() ??
            errorData["error"]?.toString() ??
            message;
      }
    } catch (_) {}

    throw Exception(message);
  }
}