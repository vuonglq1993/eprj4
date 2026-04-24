import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/game_service.dart';
import '../../l10n/l10n_ext.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _weekly;
  bool _loading = true;
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic);
    _load();
  }

  @override
  void dispose() { _barCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final results = await Future.wait([GameService.getProfile(), GameService.getWeeklyLogs()]);
    if (mounted) {
      setState(() { _profile = results[0]; _weekly = results[1]; _loading = false; });
      _barCtrl.forward(from: 0);
    }
  }

  // Sum total XP from weekly logs per day
  List<_DayXp> get _dailyXp {
    if (_weekly == null) return [];
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      final logs = _weekly![key] as List?;
      final xp = logs?.fold<int>(0, (s, l) => s + ((l['score'] as num?)?.toInt() ?? 0)) ?? 0;
      return _DayXp(day: _dayLabel(d.weekday), xp: xp);
    });
  }

  String _dayLabel(int weekday) {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return labels[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 280,
              child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop))),
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
                        children: [
                          _topBar(context),
                          _levelHero(),
                          const SizedBox(height: 20),
                          _xpBarCard(),
                          const SizedBox(height: 16),
                          _weeklyXpCard(),
                          const SizedBox(height: 16),
                          _barChartCard(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(context.l10n.levelAndXp,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _levelHero() {
    final level = _profile?['level'] as int? ?? 1;
    final title = _profile?['levelTitle'] as String? ?? '';
    final totalXp = _profile?['totalXp'] as int? ?? 0;
    final xpToNext = _profile?['xpToNextLevel'] as int? ?? 100;
    final pct = _profile?['progressPercent'] as int? ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryIcon,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.primaryGlowSoft,
      ),
      child: Column(
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(
              child: Text('$level',
                  style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Text(context.l10n.levelTitle(level, title),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(context.l10n.totalXpAmount(_fmtXp(totalXp)),
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.75))),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: _barAnim,
              builder: (_, __) => LinearProgressIndicator(
                value: (pct / 100.0) * _barAnim.value,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level $level',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
              Text(context.l10n.xpToNextLevel(xpToNext, level + 1),
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _xpBarCard() {
    final weeklyXp = _profile?['weeklyXp'] as int? ?? 0;
    final totalXp = _profile?['totalXp'] as int? ?? 0;

    return Row(
      children: [
        _miniStatCard('⚡', _fmtXp(weeklyXp), context.l10n.xpThisWeek, AppColors.warning),
        const SizedBox(width: 12),
        _miniStatCard('👑', _fmtXp(totalXp), context.l10n.totalXpLabel, AppColors.primary),
      ],
    );
  }

  Widget _miniStatCard(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text(label,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _weeklyXpCard() {
    final xpSources = [
      _XpSource(context.l10n.completeLessons, Icons.school_rounded, AppColors.primary, 20),
      _XpSource(context.l10n.correctExercises, Icons.check_circle_rounded, AppColors.success, 5),
      _XpSource(context.l10n.streakDays, Icons.local_fire_department_rounded, AppColors.warning, 10),
      _XpSource(context.l10n.perfectScore, Icons.star_rounded, const Color(0xFFFFD700), 15),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.howToEarnXp,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 14),
          ...xpSources.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: s.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(s.icon, color: s.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(s.label,
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: s.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('+${s.xp} XP',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: s.color)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _barChartCard() {
    final daily = _dailyXp;
    final maxXp = daily.isEmpty ? 1 : daily.map((d) => d.xp).reduce((a, b) => a > b ? a : b);
    final safeMax = maxXp == 0 ? 1 : maxXp;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.xpByDay,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: daily.map((d) {
                final frac = d.xp / safeMax;
                final isToday = d.day == _dayLabel(DateTime.now().weekday);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (d.xp > 0)
                      Text('${d.xp}',
                          style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
                    const SizedBox(height: 2),
                    AnimatedBuilder(
                      animation: _barAnim,
                      builder: (_, __) => Container(
                        width: 32,
                        height: 100 * frac * _barAnim.value,
                        decoration: BoxDecoration(
                          gradient: isToday ? AppGradients.primaryIcon : null,
                          color: isToday ? null : AppColors.primary.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(d.day,
                        style: TextStyle(
                          fontSize: 11,
                          color: isToday ? AppColors.primary : AppColors.textHint,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtXp(int xp) => xp >= 1000 ? '${(xp / 1000).toStringAsFixed(1)}k' : '$xp';
}

class _DayXp { final String day; final int xp; _DayXp({required this.day, required this.xp}); }
class _XpSource { final String label; final IconData icon; final Color color; final int xp;
  _XpSource(this.label, this.icon, this.color, this.xp); }
