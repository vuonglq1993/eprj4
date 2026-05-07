import 'dart:convert';
import 'dart:developer' as dev;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';

// Handler chạy ở background isolate — phải là top-level function
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  dev.log('[FCM] Background: ${message.notification?.title}', name: 'NOTIF');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _localNotif = FlutterLocalNotificationsPlugin();

  static const _channelId   = 'study_reminder';
  static const _channelName = 'Nhắc nhở học tập';
  static const _channelDesc = 'Thông báo nhắc nhở học mỗi ngày';

  /// Gọi 1 lần sau khi Firebase.initializeApp() trong main()
  Future<void> init() async {
    // Tạo channel Android
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
        ));

    // Init local notifications
    await _localNotif.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Xin quyền
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    // Foreground handler — hiện local notification
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    dev.log('[FCM] NotificationService initialized', name: 'NOTIF');
  }

  /// Lấy FCM token và đăng ký lên backend
  Future<void> registerToken() async {
    try {
      final token = await _fcm.getToken();
      if (token == null) return;
      dev.log('[FCM] Token: $token', name: 'NOTIF');
      await _sendTokenToBackend(token);

      // Lắng nghe token refresh
      _fcm.onTokenRefresh.listen(_sendTokenToBackend);
    } catch (e) {
      dev.log('[FCM] registerToken error: $e', name: 'NOTIF');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final accessToken = await TokenService.getAccessToken();
      if (accessToken == null) return;
      await http.post(
        Uri.parse('${AppConfig.baseUrl}/fcm/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'token': token, 'deviceType': 'ANDROID'}),
      );
      dev.log('[FCM] Token registered to backend', name: 'NOTIF');
    } catch (e) {
      dev.log('[FCM] sendTokenToBackend error: $e', name: 'NOTIF');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    dev.log('[FCM] Foreground: ${message.notification?.title}', name: 'NOTIF');
    final notif = message.notification;
    if (notif == null) return;

    _localNotif.show(
      id: notif.hashCode,
      title: notif.title,
      body: notif.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
