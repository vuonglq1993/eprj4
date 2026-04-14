import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';
import '../models/game_profile_model.dart';
import '../models/leaderboard_model.dart';

class GamificationService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static Future<GameProfile?> getGameProfile() async {
    try {
      final token = await TokenService.getToken();

      final res = await http.get(
        Uri.parse("$baseUrl/game/profile"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("GAME PROFILE URL: $baseUrl/game/profile");
      print("GAME PROFILE STATUS: ${res.statusCode}");
      print("GAME PROFILE BODY: ${res.body}");

      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        return GameProfile.fromJson(json);
      }

      return null;
    } catch (e) {
      print("getGameProfile error: $e");
      return null;
    }
  }

  static Future<Leaderboard?> getLeaderboard() async {
    try {
      final token = await TokenService.getToken();

      final res = await http.get(
        Uri.parse("$baseUrl/game/leaderboard"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("LEADERBOARD URL: $baseUrl/game/leaderboard");
      print("LEADERBOARD STATUS: ${res.statusCode}");
      print("LEADERBOARD BODY: ${res.body}");

      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        return Leaderboard.fromJson(json);
      }

      return null;
    } catch (e) {
      print("getLeaderboard error: $e");
      return null;
    }
  }
}