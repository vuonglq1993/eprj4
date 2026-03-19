import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';

class NotificationService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // lưu notification trong app
  static List<AppNotification> notifications = [];

  Future init() async {

    await _messaging.requestPermission();

    String? token = await _messaging.getToken();

    print("FCM TOKEN:");
    print(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      final title = message.notification?.title ?? "Notification";
      final body = message.notification?.body ?? "";

      final newNotification = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: body,
        time: DateTime.now(),
      );

      notifications.insert(0, newNotification);

      print("Notification received: $title");
    });
  }

  // đếm unread
  static int unreadCount() {
    return notifications.where((n) => !n.isRead).length;
  }

  // mark tất cả đã đọc
  static void markAllRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
  }
}




////có backend thì dùng bản này để thông báo
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../models/notification_model.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationService {
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   static List<AppNotification> notifications = [];
//
//   Future init() async {
//
//     await _messaging.requestPermission();
//
//     String? token = await _messaging.getToken();
//
//     print("FCM TOKEN:");
//     print(token);
//
//     // ✅ Gửi token về backend
//     if (token != null) {
//       await http.post(
//         Uri.parse("${dotenv.env['API_URL']}/save-token"),
//         body: {
//           "token": token,
//         },
//       );
//     }
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//
//       final title = message.notification?.title ?? "Notification";
//       final body = message.notification?.body ?? "";
//
//       final newNotification = AppNotification(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: title,
//         message: body,
//         time: DateTime.now(),
//       );
//
//       notifications.insert(0, newNotification);
//
//       print("Notification received: $title");
//     });
//   }
//
//   static int unreadCount() {
//     return notifications.where((n) => !n.isRead).length;
//   }
//
//   static void markAllRead() {
//     for (var n in notifications) {
//       n.isRead = true;
//     }
//   }
// }