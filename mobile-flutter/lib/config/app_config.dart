import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String _apiUrl = '';
  static bool _initialized = false;

  /// Gọi 1 lần trong main() sau khi dotenv đã load.
  /// - Android emulator  → đổi 127.0.0.1/localhost → 10.0.2.2
  /// - Android real device → giữ nguyên API_URL (user đặt IP LAN trong .env)
  /// - iOS simulator/device → giữ nguyên API_URL
  static Future<void> init() async {
    if (_initialized) return;
    final raw = dotenv.env['API_URL'] ?? 'http://localhost:8080';

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (!info.isPhysicalDevice) {
        // Emulator: thay localhost → 10.0.2.2 để reach host machine
        _apiUrl = raw
            .replaceAll('127.0.0.1', '10.0.2.2')
            .replaceAll('localhost', '10.0.2.2');
        _initialized = true;
        return;
      }
    }

    _apiUrl = raw;
    _initialized = true;
  }

  static String get apiUrl => _apiUrl;
  static String get baseUrl => '$_apiUrl/api/v1';
  static String get appName => dotenv.env['APP_NAME'] ?? 'LinguaNext';
}
