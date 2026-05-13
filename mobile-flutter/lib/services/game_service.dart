import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../core/secure_client.dart';
import '../core/session_manager.dart';
import 'token_service.dart';

class GameService {
  static String get _base => AppConfig.baseUrl;
  static final http.Client _client = SecureClient.create();

  static Future<Map<String, String>> _auth() async {
    final token = await TokenService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response?> _send(Future<http.Response> Function() call) async {
    try {
      final res = await call();
      if (res.statusCode == 401) {
        await TokenService.clearTokens();
        SessionManager.instance.notifyExpired();
        return null;
      }
      return res;
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/game/profile'),
      headers: await _auth(),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> getStreak() async {
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/study-logs/streak'),
      headers: await _auth(),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> getWeeklyLogs() async {
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/study-logs/weekly'),
      headers: await _auth(),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
