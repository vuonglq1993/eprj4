import 'dart:async';
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

  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;

  /// Thử làm mới access token bằng refresh token.
  /// Trả về access token mới nếu thành công, null nếu thất bại.
  static Future<String?> _tryRefresh() async {
    final refreshToken = await TokenService.getRefreshToken();
    if (refreshToken == null) return null;
    try {
      final res = await _client.post(
        Uri.parse('$_base/auth/refresh'),
        headers: _jsonHeaders,
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess  = data['accessToken']  as String;
        final newRefresh = data['refreshToken'] as String? ?? refreshToken;
        await TokenService.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return newAccess;
      }
    } catch (_) {}
    return null;
  }

  /// Wrapper cho mọi request có auth.
  /// Khi nhận 401 → tự động thử refresh token → retry 1 lần → nếu vẫn lỗi thì logout.
  static Future<http.Response?> _send(
      Future<http.Response> Function() call) async {
    try {
      final res = await call().timeout(const Duration(seconds: 15));
      if (res.statusCode != 401) return res;

      // Nếu đang có refresh khác chạy → đợi kết quả rồi retry
      if (_isRefreshing) {
        final success = await _refreshCompleter!.future;
        if (!success) return null;
        return await call();
      }

      _isRefreshing = true;
      _refreshCompleter = Completer<bool>();

      final newToken = await _tryRefresh();
      final success = newToken != null;

      _refreshCompleter!.complete(success);
      _isRefreshing = false;
      _refreshCompleter = null;

      if (success) return await call();

      await _onUnauthorized();
      return null;
    } catch (_) {
      _isRefreshing = false;
      _refreshCompleter?.complete(false);
      _refreshCompleter = null;
      return null;
    }
  }

  static Future<void> _onUnauthorized() async {
    await TokenService.clearTokens();
    SessionManager.instance.notifyExpired();
  }

  /// Public wrapper — cho phép các service khác dùng 401-auto-refresh.
  static Future<http.Response?> sendRequest(
          Future<http.Response> Function() call) =>
      _send(call);

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
      if (res.statusCode == 201) return null; // OTP sent, no tokens
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
      if (res.statusCode == 403) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['message'] == 'email_not_verified') {
          return {'_error': 'email_not_verified', '_email': email};
        }
      }
      return await _parseAndSaveAuth(res);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> verifyEmail(String email, String otp) async {
    try {
      final res = await _client.post(
        Uri.parse('$_base/auth/verify-email'),
        headers: _jsonHeaders,
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (res.statusCode == 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['message'] ?? 'verify_failed';
    } catch (_) {
      return 'network_error';
    }
  }

  static Future<String?> resendOtp(String email) async {
    try {
      final res = await _client.post(
        Uri.parse('$_base/auth/resend-otp'),
        headers: _jsonHeaders,
        body: jsonEncode({'email': email, 'type': 'VERIFY_EMAIL'}),
      );
      if (res.statusCode == 200) return null;
      return 'resend_failed';
    } catch (_) {
      return 'network_error';
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
    final refreshToken = await TokenService.getRefreshToken();
    try {
      await _client.post(
        Uri.parse('$_base/auth/logout'),
        headers: await _authHeaders(),
        body: jsonEncode(refreshToken != null ? {'refreshToken': refreshToken} : {}),
      ).timeout(const Duration(seconds: 8));
    } catch (_) {}
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
