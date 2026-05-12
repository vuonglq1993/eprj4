import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../core/secure_client.dart';
import '../core/session_manager.dart';
import 'token_service.dart';

class ApiService {
  static String get _base => AppConfig.baseUrl;
  static final http.Client _client = SecureClient.create();

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

  // ─── 401 / session helpers ────────────────────────────────────────────────

  /// Wrapper cho mọi request có auth. Tự động handle 401 toàn cục.
  /// Trả về null nếu 401 hoặc network error.
  static Future<http.Response?> _send(
      Future<http.Response> Function() call) async {
    try {
      final res = await call();
      if (res.statusCode == 401) {
        await _onUnauthorized();
        return null;
      }
      return res;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _onUnauthorized() async {
    await TokenService.clearTokens();
    SessionManager.instance.notifyExpired();
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
      final res = await _client.post(
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
      final res = await _client.post(
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
      final res = await _client.post(
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
    await _send(() async => _client.post(
      Uri.parse('$_base/auth/logout'),
      headers: await _authHeaders(),
    ));
    await TokenService.clearTokens();
  }

  // ─── USER ────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getProfile() async {
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/users/me'),
      headers: await _authHeaders(),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ─── CHECK EMAIL / PHONE ─────────────────────────────────────────────────

  /// true = đã tồn tại, false = còn trống, null = lỗi mạng
  static Future<bool?> checkEmail(String email) async {
    try {
      final res = await _client.get(
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
      final res = await _client.get(
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
      final res = await _client.get(Uri.parse('$_base/languages'));
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
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/onboarding/status'),
      headers: await _authHeaders(),
    ));
    if (res == null || res.statusCode != 200) return false;
    return (jsonDecode(res.body) as Map<String, dynamic>)['onboardingCompleted'] == true;
  }

  static Future<Map<String, dynamic>?> getOnboardingMe() async {
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/onboarding/me'),
      headers: await _authHeaders(),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? phone,
    String? gender,
    String? dateOfBirth,
    String? country,
    String? timezone,
    String? bio,
    String? uiLanguage,
  }) async {
    final res = await _send(() async => _client.put(
      Uri.parse('$_base/users/me'),
      headers: await _authHeaders(),
      body: jsonEncode({
        if (firstName   != null) 'firstName':  firstName,
        if (lastName    != null) 'lastName':   lastName,
        if (avatarUrl   != null) 'avatarUrl':  avatarUrl,
        if (uiLanguage  != null) 'uiLanguage': uiLanguage,
        if (phone       != null) 'phone':      phone,
        if (gender      != null) 'gender':     gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        if (country     != null) 'country':    country,
        if (timezone    != null) 'timezone':   timezone,
        if (bio         != null) 'bio':        bio,
      }),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<String?> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    final body = <String, dynamic>{'newPassword': newPassword};
    if (currentPassword != null) body['currentPassword'] = currentPassword;
    final res = await _send(() async => _client.patch(
      Uri.parse('$_base/users/me/password'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    ));
    if (res == null) return 'Lỗi mạng';
    if (res.statusCode == 200) return null;
    return (jsonDecode(res.body) as Map)['message'] as String? ?? 'Đổi mật khẩu thất bại';
  }

  static Future<Map<String, dynamic>?> submitOnboarding({
    required String targetLanguageId,
    required String selfLevel,
    required String goal,
    required String dailyTime,
    String nativeLanguageCode = 'vi',
    String? ageGroup,
  }) async {
    final res = await _send(() async => _client.post(
      Uri.parse('$_base/onboarding'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'targetLanguageId': targetLanguageId,
        'selfLevel': selfLevel,
        'goal': goal,
        'dailyTime': dailyTime,
        'nativeLanguageCode': nativeLanguageCode,
        if (ageGroup != null) 'ageGroup': ageGroup,
      }),
    ));
    if (res == null) return null;
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<String?> uploadAvatar(File file) async {
    try {
      final token = await TokenService.getAccessToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_base/users/me/avatar'),
      );
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      final streamed = await _client.send(request);
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode == 401) { await _onUnauthorized(); return null; }
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map<String, dynamic>)['avatarUrl'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> registerFcmToken(String token) async {
    await _send(() async => _client.post(
      Uri.parse('$_base/fcm/register'),
      headers: await _authHeaders(),
      body: jsonEncode({'token': token}),
    ));
  }

  static Future<Map<String, dynamic>?> getReminderSettings() async {
    final res = await _send(() async => _client.get(
      Uri.parse('$_base/notifications/reminder-settings'),
      headers: await _authHeaders(),
    ));
    if (res == null || res.statusCode != 200) return null;
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<bool> updateReminderSettings({
    required bool enabled,
    required int hour,
    required int minute,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    final res = await _send(() async => _client.put(
      Uri.parse('$_base/notifications/reminder-settings'),
      headers: await _authHeaders(),
      body: jsonEncode({'enabled': enabled, 'hour': hour, 'minute': minute, 'timezone': timezone}),
    ));
    return res?.statusCode == 200;
  }

  static Future<void> sendTestNotification() async {
    await _send(() async => _client.post(
      Uri.parse('$_base/notifications/test'),
      headers: await _authHeaders(),
    ));
  }
}
