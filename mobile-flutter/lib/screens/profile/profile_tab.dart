import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '../../services/api_service.dart';
import '../../services/game_service.dart';
import '../game/streak_screen.dart';
import '../game/badges_screen.dart';
import '../subscription/plan_selection_screen.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'subscription_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _gameProfile;
  Map<String, dynamic>? _streak;
  Map<String, dynamic>? _onboarding;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      ApiService.getProfile(),
      GameService.getProfile(),
      GameService.getStreak(),
      ApiService.getOnboardingMe(),
    ]);
    if (mounted) {
      setState(() {
        _user = results[0];
        _gameProfile = results[1];
        _streak = results[2];
        _onboarding = results[3];
        _loading = false;
      });
    }
  }

  // ── Helpers ────────────────────────────────────────────────
  String get _fullName {
    final first = _user?['firstName'] as String? ?? '';
    final last = _user?['lastName'] as String? ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : context.l10n.user;
  }

  String get _initials {
    final parts = _fullName.trim().split(' ');
    if (parts.length >= 2) return (parts.first[0] + parts.last[0]).toUpperCase();
    return _fullName.isNotEmpty ? _fullName[0].toUpperCase() : 'U';
  }

  String get _langDisplay {
    final langName = _onboarding?['targetLanguageName'] as String? ?? '';
    final flag = _onboarding?['targetLanguageFlag'] as String? ?? '🌐';
    final selfLevel = _onboarding?['selfLevel'] as String? ?? '';
    final levelShort = _mapSelfLevel(selfLevel);
    if (langName.isEmpty) return '';
    return '$flag $langName${levelShort.isNotEmpty ? ' $levelShort' : ''}';
  }

  String _mapSelfLevel(String level) => switch (level) {
        'COMPLETE_BEGINNER' => 'A1',
        'BEGINNER' => 'A2',
        'INTERMEDIATE' => 'B1',
        'ADVANCED' => 'C1',
        _ => '',
      };

  bool get _isPremium => _user?['isPremium'] == true;
  String get _plan => _user?['subscriptionPlan'] as String? ?? 'FREE';

  int get _longestStreak => _streak?['longestStreak'] as int? ?? 0;
  int get _totalDays => (_streak?['studyDates'] as List?)?.length ?? 0;
  int get _badgeCount => (_gameProfile?['badges'] as List?)?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 220,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: _load,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topBar(),
                          const SizedBox(height: 8),
                          _heroCard(),
                          const SizedBox(height: 16),
                          _statsRow(),
                          const SizedBox(height: 20),
                          _menuSection(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(context.l10n.profile,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          TappableScale(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())).then((_) => _load()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.settings_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(context.l10n.settings, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero user card ────────────────────────────────────────
  Widget _heroCard() {
    final avatar = _user?['avatarUrl'] as String?;
    final email = _user?['email'] as String? ?? '';
    final level = _gameProfile?['level'] as int? ?? 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Avatar + edit button
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryIcon,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.primaryGlowSoft,
                ),
                child: avatar != null
                    ? ClipOval(child: Image.network(avatar, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(_initials, style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)))))
                    : Center(child: Text(_initials,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              Positioned(
                right: -4, bottom: -4,
                child: TappableScale(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(user: _user ?? {}))).then((updated) { if (updated == true) _load(); }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppShadows.primaryGlowSoft,
                    ),
                    child: Text(context.l10n.editProfile,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(_fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
          if ((_user?['bio'] as String?)?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              _user!['bio'] as String,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
          const SizedBox(height: 10),
          // Badges row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              if (_isPremium)
                _badge(context.l10n.proMember, AppGradients.primaryIcon, Colors.white),
              _badgeSolid('Level $level', AppColors.warning.withValues(alpha: 0.2),
                  AppColors.warning),
              if (_langDisplay.isNotEmpty)
                _badgeSolid(_langDisplay, AppColors.surface, AppColors.textSecondary,
                    border: AppColors.border),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, LinearGradient gradient, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _badgeSolid(String text, Color bg, Color fg, {Color? border}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border != null ? Border.all(color: border) : null,
      ),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  // ── Stats row ──────────────────────────────────────────────
  Widget _statsRow() {
    final totalXp = _gameProfile?['totalXp'] as int? ?? 0;

    return Row(
      children: [
        _statBox('$_totalDays', context.l10n.studyDays, null),
        _divider(),
        _statBox('🏆 $_longestStreak', context.l10n.bestStreak, null),
        _divider(),
        _statBox(_fmtXp(totalXp), 'Tổng XP', AppColors.primary),
      ],
    );
  }

  Widget _divider() => Container(height: 40, width: 1, color: AppColors.border);

  Widget _statBox(String value, String label, Color? color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900,
                  color: color ?? AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── Menu section ───────────────────────────────────────────
  Widget _menuSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _menuItem(Icons.person_rounded, const Color(0xFF7C5CBF),
              context.l10n.editProfile, null,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(user: _user ?? {}))).then((updated) { if (updated == true) _load(); })),
          _menuDivider(),
          _menuItem(Icons.route_rounded, AppColors.primary,
              context.l10n.pathAndLanguage, null,
              () => _push(const StreakScreen())),
          _menuDivider(),
          _menuItem(Icons.star_rounded, AppColors.warning,
              context.l10n.badgesAchievements, '${context.l10n.badges}: $_badgeCount',
              () => _push(const BadgesScreen())),
          _menuDivider(),
          _menuItem(Icons.card_membership_rounded, const Color(0xFF2563EB),
              context.l10n.subscriptionBilling,
              _isPremium ? _plan.replaceAll('_', ' ').toLowerCase().capitalize() : context.l10n.free,
              () => _push(_isPremium ? const SubscriptionScreen() : const PlanSelectionScreen())),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, Color iconColor, String title, String? subtitle, VoidCallback onTap) {
    return TappableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
            if (subtitle != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _menuDivider() => const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.border);

  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  String _fmtXp(int xp) => xp >= 1000 ? '${(xp / 1000).toStringAsFixed(1)}k' : '$xp';
}

extension _StringExt on String {
  String capitalize() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
