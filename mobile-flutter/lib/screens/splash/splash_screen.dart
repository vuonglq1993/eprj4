import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '../../main.dart';
import '../../core/ai_button_controller.dart';
import '../../services/notification_service.dart';
import '../../services/token_service.dart';
import '../../services/api_service.dart';
import '../auth/register_page.dart';
import '../auth/login_page.dart';
import '../home/home_placeholder.dart';
import '../onboarding/onboarding_flow.dart';
import 'dart:developer' as developer;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedLang;
  bool _checkingSession = true;

  // ── Entrance animation ────────────────────────────────────────────────────
  late AnimationController _entranceCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _midOpacity;
  late Animation<double> _bottomOpacity;

  static const _prefKeyLang = 'locale';

  static const _langs = [
    ('vi', '🇻🇳', 'Tiếng Việt'),
    ('en', '🇺🇸', 'English'),
    ('ja', '🇯🇵', '日本語'),
  ];

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    ));
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _midOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.4, 0.78, curve: Curves.easeOut),
      ),
    );
    _bottomOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _init();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKeyLang);
    developer.log('[splash._init] saved=$saved | stateNull=${appStateKey.currentState == null}', name: 'L10N');

    if (saved != null) {
      setState(() => _selectedLang = saved);
      appStateKey.currentState?.setLocale(Locale(saved));
      developer.log('[splash._init] setLocale($saved) called', name: 'L10N');
    }

    final hasToken = await TokenService.hasToken();
    if (!mounted) return;

    if (hasToken) {
      final profile = await ApiService.getProfile();
      if (!mounted) return;
      if (profile != null) {
        final onboardingDone = await ApiService.isOnboardingCompleted();
        if (!mounted) return;
        AiButtonController.onLogin();
        NotificationService.instance.registerToken();
        Navigator.pushReplacement(
          context,
          _buildRoute(
            onboardingDone ? const HomePlaceholder() : const OnboardingFlow(),
          ),
        );
        return;
      }
      await TokenService.clearTokens();
    }

    if (!mounted) return;
    setState(() => _checkingSession = false);
    _entranceCtrl.forward();
  }

  Future<void> _onStart() async {
    if (_selectedLang == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyLang, _selectedLang!);
    if (!mounted) return;
    Navigator.pushReplacement(context, _buildRoute(const RegisterPage()));
  }

  PageRouteBuilder _buildRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        transitionsBuilder: (_, anim, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: SlideTransition(position: slide, child: child),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Subtle top gradient overlay for depth
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.bgTop),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _checkingSession ? _buildLoading() : _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),

          // ── Logo ──────────────────────────────────────────────────────────
          FadeTransition(
            opacity: _logoOpacity,
            child: ScaleTransition(
              scale: _logoScale,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryIcon,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppShadows.primaryGlowSoft,
                ),
                child: const Icon(Icons.layers_rounded,
                    color: Colors.white, size: 34),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Title ─────────────────────────────────────────────────────────
          FadeTransition(
            opacity: _titleOpacity,
            child: SlideTransition(
              position: _titleSlide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.appName,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.splashTagline,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Language selection ────────────────────────────────────────────
          FadeTransition(
            opacity: _midOpacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.interfaceLanguage,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: _langs
                      .map((l) => Expanded(child: _langChip(l)))
                      .expand((w) => [w, const SizedBox(width: 10)])
                      .toList()
                    ..removeLast(),
                ),
              ],
            ),
          ),

          const Spacer(flex: 3),

          // ── CTA button ────────────────────────────────────────────────────
          FadeTransition(
            opacity: _bottomOpacity,
            child: Column(
              children: [
                GradientButton(
                  label: context.l10n.splashGetStarted,
                  enabled: _selectedLang != null,
                  onTap: _onStart,
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      _buildRoute(const LoginPage()),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: context.l10n.alreadyHaveAccount,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: context.l10n.login,
                            style: TextStyle(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _langChip((String, String, String) lang) {
    final (code, flag, name) = lang;
    final isSelected = _selectedLang == code;

    return TappableScale(
      onTap: () {
        developer.log('[langChip.tap] code=$code | stateNull=${appStateKey.currentState == null}', name: 'L10N');
        setState(() => _selectedLang = code);
        final state = appStateKey.currentState;
        if (state != null) {
          state.setLocale(Locale(code));
          developer.log('[langChip.tap] setLocale($code) OK', name: 'L10N');
        } else {
          developer.log('[langChip.tap] ERROR: appStateKey.currentState is null!', name: 'L10N');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? AppShadows.subtle : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded,
                  size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
