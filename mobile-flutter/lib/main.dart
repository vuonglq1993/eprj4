import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'core/theme.dart';
import 'core/ai_floating_button.dart';
import 'screens/splash/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AppConfig.init();
  runApp(const LinguaNextApp());
}

final _navigatorKey = GlobalKey<NavigatorState>();

class LinguaNextApp extends StatelessWidget {
  const LinguaNextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinguaNext',
      theme: AppTheme.dark,
      navigatorKey: _navigatorKey,
      home: const SplashScreen(),
      builder: (context, child) {
        // Bottom offset: bottom nav (~60) + safe area padding
        final bottomPad = MediaQuery.of(context).padding.bottom;
        return Stack(
          children: [
            child!,
            Positioned(
              right: 20,
              bottom: 72 + bottomPad,
              child: AiFloatingButton(navigatorKey: _navigatorKey),
            ),
          ],
        );
      },
    );
  }
}
