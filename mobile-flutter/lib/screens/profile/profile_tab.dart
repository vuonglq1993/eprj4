import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/game_service.dart';
import '../../services/token_service.dart';
import '../splash/splash_screen.dart';
import '../game/streak_screen.dart';
import '../game/level_screen.dart';
import '../game/badges_screen.dart';
import '../game/weekly_report_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _streak;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final results = await Future.wait([GameService.getProfile(), GameService.getStreak()]);
    if (mounted) setState(() { _profile = results[0]; _streak = results[1]; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 200,
              child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop))),
          SafeArea(
            child: RefreshIndicator(
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
                    if (_loading)
                      const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    else ...[
                      _userCard(),
                      const SizedBox(height: 20),
                      _statsRow(),
                      const SizedBox(height: 24),
                      _sectionLabel('GAMIFICATION'),
                      const SizedBox(height: 12),
                      _gameGrid(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          const Text('Hồ sơ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary, size: 22),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              await TokenService.clearTokens();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (r) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _userCard() {
    final name = _profile?['userName'] as String? ?? 'Người dùng';
    final avatar = _profile?['avatarUrl'] as String?;
    final level = _profile?['level'] as int? ?? 1;
    final title = _profile?['levelTitle'] as String? ?? '';
    final pct = _profile?['progressPercent'] as int? ?? 0;
    final xpToNext = _profile?['xpToNextLevel'] as int? ?? 0;
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryIcon,
              shape: BoxShape.circle,
            ),
            child: avatar != null
                ? ClipOval(child: Image.network(avatar, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(initials, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)))))
                : Center(child: Text(initials,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryIcon,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Lv.$level $title',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 6),
                    Text('$xpToNext XP nữa',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct / 100.0,
                    backgroundColor: AppColors.inputBg,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    final streak = _streak?['currentStreak'] as int? ?? 0;
    final totalXp = _profile?['totalXp'] as int? ?? 0;
    final weeklyXp = _profile?['weeklyXp'] as int? ?? 0;
    final badgeCount = (_profile?['badges'] as List?)?.length ?? 0;

    return Row(
      children: [
        _statChip('🔥', '$streak', 'Streak', AppColors.warning),
        const SizedBox(width: 8),
        _statChip('⚡', _fmtXp(totalXp), 'Total XP', AppColors.primary),
        const SizedBox(width: 8),
        _statChip('📅', _fmtXp(weeklyXp), 'Tuần', AppColors.success),
        const SizedBox(width: 8),
        _statChip('🏅', '$badgeCount', 'Badges', AppColors.primaryLight),
      ],
    );
  }

  Widget _statChip(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(label,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
          color: AppColors.textSecondary, letterSpacing: 0.8));

  Widget _gameGrid() {
    final cards = [
      _GameCard('🔥', 'Tiến trình học', 'Streak & Heatmap', AppColors.warning,
          () => _push(const StreakScreen())),
      _GameCard('⭐', 'Cấp độ & XP', 'Level ${_profile?['level'] ?? 1} · ${_profile?['levelTitle'] ?? ''}',
          AppColors.primary, () => _push(const LevelScreen())),
      _GameCard('🏅', 'Huy hiệu',
          '${(_profile?['badges'] as List?)?.length ?? 0} / 17 đã đạt',
          AppColors.primaryLight, () => _push(const BadgesScreen())),
      _GameCard('📊', 'Báo cáo tuần', 'XP & bài học', AppColors.success,
          () => _push(const WeeklyReportScreen())),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: cards.map(_buildGameCard).toList(),
    );
  }

  Widget _buildGameCard(_GameCard c) {
    return TappableScale(
      onTap: c.onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.color.withValues(alpha: 0.2)),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: c.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 22))),
            ),
            const Spacer(),
            Text(c.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(c.subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  void _push(Widget screen) {
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
    )).then((_) => _load());
  }

  String _fmtXp(int xp) => xp >= 1000 ? '${(xp / 1000).toStringAsFixed(1)}k' : '$xp';
}

class _GameCard {
  final String emoji, title, subtitle;
  final Color color;
  final VoidCallback onTap;
  _GameCard(this.emoji, this.title, this.subtitle, this.color, this.onTap);
}
