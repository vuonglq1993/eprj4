import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';

class ApiService {
  static String get _base => AppConfig.baseUrl;

  static Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
      };

  static Future<Map<String, String>> _authHeaders() async {
    final token = await TokenService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── Helpers ────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> _parseAndSaveAuth(http.Response res) async {
    if (res.statusCode != 200 && res.statusCode != 201) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    await TokenService.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    return data['user'] as Map<String, dynamic>;
  }

  // ─── AUTH ────────────────────────────────────────────────────────────────

  static Future<String?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/auth/register'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        }),
      );
      if (res.statusCode == 201) {
        await _parseAndSaveAuth(res);
        return null;
      }
      if (res.statusCode == 409) return 'email_exists';
      return 'register_failed';
    } catch (_) {
      return 'network_error';
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/auth/login'),
        headers: _jsonHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      );
      return await _parseAndSaveAuth(res);
    } catch (_) {
      return null;
    }
  }

  /// Đăng nhập bằng Google idToken.
  static Future<Map<String, dynamic>?> loginWithGoogle(String idToken) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/auth/google'),
        headers: _jsonHeaders,
        body: jsonEncode({'idToken': idToken}),
      );
      return await _parseAndSaveAuth(res);
    } catch (_) {
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$_base/auth/logout'),
        headers: await _authHeaders(),
      );
    } catch (_) {}
    await TokenService.clearTokens();
  }

  // ─── USER ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/users/me'),
        headers: await _authHeaders(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      if (res.statusCode == 401) await TokenService.clearTokens();
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── CHECK EMAIL / PHONE ─────────────────────────────────────────────────

  /// true = đã tồn tại, false = còn trống, null = lỗi mạng
  static Future<bool?> checkEmail(String email) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/auth/check-email?email=${Uri.encodeComponent(email)}'),
        headers: _jsonHeaders,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['exists'] as bool;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// true = đã tồn tại, false = còn trống, null = lỗi mạng
  static Future<bool?> checkPhone(String phone) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/auth/check-phone?phone=${Uri.encodeComponent(phone)}'),
        headers: _jsonHeaders,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['exists'] as bool;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─── LANGUAGES ───────────────────────────────────────────────────────────

  /// Lấy danh sách ngôn ngữ (public, không cần auth).
  static Future<List<Map<String, dynamic>>> getLanguages() async {
    try {
      final res = await http.get(Uri.parse('$_base/languages'));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ─── ONBOARDING ──────────────────────────────────────────────────────────

  static Future<bool> isOnboardingCompleted() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/onboarding/status'),
        headers: await _authHeaders(),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['onboardingCompleted'] == true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getOnboardingMe() async {
    try {
      final res = await http.get(
        Uri.parse('$_base/onboarding/me'),
        headers: await _authHeaders(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? uiLanguage,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$_base/users/me'),
        headers: await _authHeaders(),
        body: jsonEncode({
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
          if (uiLanguage != null) 'uiLanguage': uiLanguage,
        }),
      );
      if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await http.patch(
        Uri.parse('$_base/users/me/password'),
        headers: await _authHeaders(),
        body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
      );
      if (res.statusCode == 200) return null; // success
      final msg = (jsonDecode(res.body) as Map)['message'] as String? ?? 'Đổi mật khẩu thất bại';
      return msg;
    } catch (_) {
      return 'Lỗi mạng';
    }
  }

  /// Submit onboarding và trả về full response (recommendedPath, motivationMessage, v.v.).
  /// Trả về null nếu lỗi.
  ///
  /// selfLevel:  COMPLETE_BEGINNER | BEGINNER | INTERMEDIATE | ADVANCED
  /// goal:       TRAVEL | SCHOOL | WORK | FAMILY_FRIENDS | SKILL_IMPROVEMENT | OTHERS
  /// dailyTime:  FIVE_MIN | FIFTEEN_MIN | THIRTY_MIN | SIXTY_MIN
  static Future<Map<String, dynamic>?> submitOnboarding({
    required String targetLanguageId,
    required String selfLevel,
    required String goal,
    required String dailyTime,
    String nativeLanguageCode = 'vi',
    String? ageGroup,
  }) async {
    try {
      final body = <String, dynamic>{
        'targetLanguageId': targetLanguageId,
        'selfLevel': selfLevel,
        'goal': goal,
        'dailyTime': dailyTime,
        'nativeLanguageCode': nativeLanguageCode,
        if (ageGroup != null) 'ageGroup': ageGroup,
      };
      final res = await http.post(
        Uri.parse('$_base/onboarding'),
        headers: await _authHeaders(),
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
