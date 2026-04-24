import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';

class GameService {
  static String get _base => AppConfig.baseUrl;

  static Future<Map<String, String>> _auth() async {
    final token = await TokenService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/game/profile'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
      return null;
    } catch (_) { return null; }
  }

  static Future<Map<String, dynamic>?> getStreak() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/study-logs/streak'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
      return null;
    } catch (_) { return null; }
  }

  static Future<Map<String, dynamic>?> getWeeklyLogs() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/study-logs/weekly'),
        headers: await _auth(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
      return null;
    } catch (_) { return null; }
  }
}
