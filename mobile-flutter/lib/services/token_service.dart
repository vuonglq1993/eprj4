import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Lưu JWT token vào secure storage (tương đương HttpOnly cookie trên mobile).
/// - Android: EncryptedSharedPreferences (AES-256)
/// - iOS: Keychain
class TokenService {
  static const _store = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyAccess = 'jwt_access_token';
  static const _keyRefresh = 'jwt_refresh_token';

  // ─── Write ──────────────────────────────────────────────────────────────

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _store.write(key: _keyAccess, value: accessToken),
      _store.write(key: _keyRefresh, value: refreshToken),
    ]);
  }

  // ─── Read ───────────────────────────────────────────────────────────────

  static Future<String?> getAccessToken() =>
      _store.read(key: _keyAccess);

  static Future<String?> getRefreshToken() =>
      _store.read(key: _keyRefresh);

  static Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ─── Delete ─────────────────────────────────────────────────────────────

  static Future<void> clearTokens() async {
    await Future.wait([
      _store.delete(key: _keyAccess),
      _store.delete(key: _keyRefresh),
    ]);
  }
}
