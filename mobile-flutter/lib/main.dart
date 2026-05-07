import 'dart:developer' as dev;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'core/theme.dart';
import 'core/ai_floating_button.dart';
import 'firebase_options.dart';
import 'screens/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/notification_service.dart';

const _kLocaleKey = 'locale';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.init();
  await dotenv.load(fileName: '.env');
  await AppConfig.init();

  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString(_kLocaleKey) ?? 'vi';
  dev.log('[main] initialLocale=$langCode', name: 'L10N');

  runApp(LinguaNextApp(key: appStateKey, initialLocale: Locale(langCode)));
}

final _navigatorKey = GlobalKey<NavigatorState>();

// GlobalKey để các màn hình khác có thể gọi setLocale
final appStateKey = GlobalKey<LinguaNextAppState>();

class LinguaNextApp extends StatefulWidget {
  final Locale initialLocale;
  const LinguaNextApp({super.key, required this.initialLocale});

  @override
  State<LinguaNextApp> createState() => LinguaNextAppState();
}

class LinguaNextAppState extends State<LinguaNextApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale locale) {
    dev.log('[setLocale] ${_locale.languageCode} → ${locale.languageCode}', name: 'L10N');
    setState(() => _locale = locale);
    SharedPreferences.getInstance()
        .then((p) => p.setString(_kLocaleKey, locale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinguaNext',
      theme: AppTheme.dark,
      navigatorKey: _navigatorKey,

      // Localization
      locale: _locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const SplashScreen(),
      builder: (context, child) {
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
