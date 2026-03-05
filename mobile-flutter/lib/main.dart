import 'package:flutter/material.dart';
import 'homescreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // Nền trắng toàn app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F2EFF),
          brightness: Brightness.light,
        ),
      ),
      // Bắt đầu từ SplashScreen để có luồng đi đúng thiết kế
      home: const SplashScreen(),
    );
  }
}