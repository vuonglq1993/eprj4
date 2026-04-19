import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/token_service.dart';
import '../../services/api_service.dart';
import '../auth/register_page.dart';
import '../auth/login_page.dart';
import '../home/home_placeholder.dart';
import '../onboarding/onboarding_flow.dart';

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

  static const _prefKeyLang = 'ui_language';

  static const _langs = [
    ('en', '🇺🇸', 'English'),
    ('ja', '🇯🇵', '日本語'),
    ('ko', '🇰🇷', '한국어'),
    ('zh', '🇨🇳', '中文'),
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
    if (saved != null) setState(() => _selectedLang = saved);

    final hasToken = await TokenService.hasToken();
    if (!mounted) return;

    if (hasToken) {
      final profile = await ApiService.getProfile();
      if (!mounted) return;
      if (profile != null) {
        final onboardingDone = await ApiService.isOnboardingCompleted();
        if (!mounted) return;
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
                  const Text(
                    'LinguaNext',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Học ngoại ngữ thông minh\ncùng AI cá nhân hóa',
                    style: TextStyle(
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
                const Text(
                  'Chọn ngôn ngữ giao diện',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: _langChip(_langs[0])),
                    const SizedBox(width: 10),
                    Expanded(child: _langChip(_langs[1])),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _langChip(_langs[2])),
                    const SizedBox(width: 10),
                    Expanded(child: _langChip(_langs[3])),
                  ],
                ),

                if (_selectedLang != null && _selectedLang != 'vi')
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        const Text(
                          'Giao diện hiện tại: Tiếng Việt',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
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
                  label: 'Bắt đầu miễn phí',
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
                        text: 'Đã có tài khoản? ',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Đăng nhập',
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
      onTap: () => setState(() => _selectedLang = code),
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
