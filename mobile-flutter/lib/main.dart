// import 'package:flutter/material.dart';
// import 'homescreen/splash_screen.dart';
// import '../homepage/homepagesetting/theme_notifier.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: themeNotifier,
//       builder: (context, ThemeMode mode, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Language App',
//
//           theme: ThemeData(
//             useMaterial3: true,
//             scaffoldBackgroundColor: const Color(0xFFF6F7FB),
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: const Color(0xFF5F2EFF),
//               brightness: Brightness.light,
//             ),
//             cardColor: Colors.white,
//           ),
//
//           darkTheme: ThemeData(
//             useMaterial3: true,
//             scaffoldBackgroundColor: const Color(0xFF0B1023),
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: const Color(0xFF5F2EFF),
//               brightness: Brightness.dark,
//             ),
//             cardColor: const Color(0xFF121A35),
//           ),
//
//           themeMode: mode,
//           home: const SplashScreen(),
//         );
//       },
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'homescreen/splash_screen.dart';
import '../homepage/homepagesetting/theme_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print("API_BASE_URL: ${dotenv.env['API_BASE_URL']}");
  print("APP_NAME: ${dotenv.env['APP_NAME']}");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await NotificationService().init(); //nếu chưa có backend là lỗi
  NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Language App',

          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF6F7FB),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5F2EFF),
              brightness: Brightness.light,
            ),
            cardColor: Colors.white,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF0B1023),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5F2EFF),
              brightness: Brightness.dark,
            ),
            cardColor: const Color(0xFF121A35),
          ),

          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}