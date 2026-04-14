import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'core/theme.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AppConfig.init();
  runApp(const LinguaNextApp());
}

class LinguaNextApp extends StatelessWidget {
  const LinguaNextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinguaNext',
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
