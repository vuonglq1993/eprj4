import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/game_service.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  Map<String, dynamic>? _streak;
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([GameService.getStreak(), GameService.getProfile()]);
    if (mounted) setState(() { _streak = results[0]; _profile = results[1]; _loading = false; });
  }

  // Returns count per date key (yyyy-MM-dd → count)
  Map<String, int> get _dailyCounts {
    final raw = _streak?['dailyCounts'] as Map?;
    if (raw == null) return {};
    return raw.map((k, v) => MapEntry(k.toString().substring(0, 10), (v as num).toInt()));
  }

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
                        children: [
                          _topBar(context),
                          const SizedBox(height: 4),
                          _streakHero(),
                          const SizedBox(height: 20),
                          _statsRow(),
                          const SizedBox(height: 24),
                          _heatmapCard(),
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
          const Text('Tiến trình học',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${_streak?['currentStreak'] ?? 0}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.warning),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streakHero() {
    final current = _streak?['currentStreak'] as int? ?? 0;
    final studiedToday = _streak?['studiedToday'] as bool? ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B35).withValues(alpha: 0.15),
            const Color(0xFFFF8C42).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text(
            '$current',
            style: const TextStyle(
              fontSize: 64, fontWeight: FontWeight.w900,
              color: AppColors.warning, height: 1,
            ),
          ),
          const Text(
            'ngày liên tiếp',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          if (studiedToday) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Text('✓ Đã học hôm nay',
                  style: TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statsRow() {
    final longest = _streak?['longestStreak'] as int? ?? 0;
    final freeze = _profile?['streakFreezeCount'] as int?;
    final totalDays = (_streak?['studyDates'] as List?)?.length ?? _dailyCounts.length;

    return Row(
      children: [
        _statCard('🏆', '$longest', 'Dài nhất', AppColors.warning),
        const SizedBox(width: 12),
        _statCard('📅', '$totalDays', 'Tổng ngày', AppColors.primary),
        if (freeze != null) ...[
          const SizedBox(width: 12),
          _statCard('🛡️', '$freeze', 'Freeze còn', AppColors.primaryLight),
        ],
      ],
    );
  }

  Widget _statCard(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _heatmapCard() {
    final now = DateTime.now();
    final counts = _dailyCounts;

    // Build 5-week grid (35 days) ending today
    final days = List.generate(35, (i) {
      final d = now.subtract(Duration(days: 34 - i));
      return d;
    });

    const dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HEATMAP THÁNG NÀY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 16),
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dayLabels.map((l) => SizedBox(
              width: 34,
              child: Text(l,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            )).toList(),
          ),
          const SizedBox(height: 6),
          // Grid - 5 rows of 7
          ...List.generate(5, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (col) {
                  final idx = row * 7 + col;
                  final d = days[idx];
                  final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                  final count = counts[key] ?? 0;
                  final isToday = d.year == now.year && d.month == now.month && d.day == now.day;
                  final isFuture = d.isAfter(now);

                  Color cellColor;
                  if (isFuture) {
                    cellColor = Colors.transparent;
                  } else if (count == 0) {
                    cellColor = AppColors.inputBg;
                  } else if (count == 1) {
                    cellColor = AppColors.primary.withValues(alpha: 0.25);
                  } else if (count <= 3) {
                    cellColor = AppColors.primary.withValues(alpha: 0.50);
                  } else if (count <= 6) {
                    cellColor = AppColors.primary.withValues(alpha: 0.70);
                  } else {
                    cellColor = AppColors.primary.withValues(alpha: 0.90);
                  }

                  return Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(color: AppColors.primary, width: 2)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: count > 0
                        ? Center(child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)))
                        : null,
                  );
                }),
              ),
            );
          }),
          const SizedBox(height: 12),
          // Legend
          Row(
            children: [
              const Text('Ít', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
              const SizedBox(width: 4),
              for (final alpha in [0.0, 0.25, 0.50, 0.70, 0.90]) ...[
                Container(width: 14, height: 14,
                    decoration: BoxDecoration(
                        color: alpha == 0.0 ? AppColors.inputBg : AppColors.primary.withValues(alpha: alpha),
                        borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 3),
              ],
              const Text('Nhiều', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
              const Spacer(),
              Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              const Text('Hôm nay', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }
}
