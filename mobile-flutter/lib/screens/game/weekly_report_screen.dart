import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/game_service.dart';

class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _weekly;
  Map<String, dynamic>? _profile;
  bool _loading = true;
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic);
    _load();
  }

  @override
  void dispose() { _barCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final r = await Future.wait([GameService.getWeeklyLogs(), GameService.getProfile()]);
    if (mounted) {
      setState(() { _weekly = r[0]; _profile = r[1]; _loading = false; });
      _barCtrl.forward(from: 0);
    }
  }

  // Build 7-day list ending today
  List<_DayData> get _days {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      final logs = (_weekly?[key] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final dur = logs.fold<int>(0, (s, l) => s + ((l['duration'] as num?)?.toInt() ?? 0));
      return _DayData(
        date: d,
        label: _dayLabel(d.weekday),
        logs: logs,
        durationSeconds: dur,
      );
    });
  }

  String _dayLabel(int wd) {
    const l = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return l[wd - 1];
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;
    final daysStudied = days.where((d) => d.logs.isNotEmpty).length;
    // Use actual weeklyXp from game profile, not study log scores
    final totalXp = _profile?['weeklyXp'] as int? ?? 0;
    final totalLessons = days.fold<int>(0, (s, d) => s + d.logs.length);
    final totalDurMin = days.fold<int>(0, (s, d) => s + d.durationSeconds) ~/ 60;
    // Bar chart uses lesson count per day (not score-as-XP)
    final maxLessons = days.isEmpty ? 1 : days.map((d) => d.logs.length).reduce((a, b) => a > b ? a : b);
    final safeMax = maxLessons == 0 ? 1 : maxLessons;

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 6));
    final weekLabel = '${weekStart.day}/${weekStart.month} – ${now.day}/${now.month}';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 200,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topBar(context, weekLabel),
                          const SizedBox(height: 16),
                          _summaryCard(daysStudied, totalXp, totalLessons, totalDurMin),
                          const SizedBox(height: 16),
                          _barChartCard(days, safeMax),
                          const SizedBox(height: 16),
                          _dailyLogList(days),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context, String weekLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Báo cáo tuần',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(weekLabel,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(int daysStudied, int totalXp, int totalLessons, int totalDurMin) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryIcon,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.primaryGlowSoft,
      ),
      child: Column(
        children: [
          const Text('Tuần này bạn đã',
              style: TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _summaryItem('$daysStudied/7', 'Ngày học', Colors.white),
              _vDivider(),
              _summaryItem('$totalXp', 'XP kiếm được', const Color(0xFFFFD580)),
              _vDivider(),
              _summaryItem('$totalLessons', 'Bài học xong', Colors.white),
              _vDivider(),
              _summaryItem('${totalDurMin}p', 'TB / ngày', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.white60)),
      ],
    );
  }

  Widget _vDivider() => Container(height: 32, width: 1, color: Colors.white24);

  Widget _barChartCard(List<_DayData> days, int safeMax) {
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
          const Text('BÀI HỌC THEO NGÀY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days.map((d) {
                final count = d.logs.length;
                final frac = count / safeMax;
                final isToday = d.date.day == DateTime.now().day &&
                    d.date.month == DateTime.now().month;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (count > 0)
                      Text('$count',
                          style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
                    const SizedBox(height: 2),
                    AnimatedBuilder(
                      animation: _barAnim,
                      builder: (_, __) => Container(
                        width: 32,
                        height: [100 * frac * _barAnim.value, 4.0].reduce((a, b) => a > b ? a : b),
                        decoration: BoxDecoration(
                          gradient: isToday ? AppGradients.primaryIcon : null,
                          color: isToday ? null : (count > 0
                              ? AppColors.primary.withValues(alpha: 0.5)
                              : AppColors.inputBg),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(d.label,
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

  Widget _dailyLogList(List<_DayData> days) {
    final daysWithLogs = days.where((d) => d.logs.isNotEmpty).toList().reversed.toList();
    if (daysWithLogs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text('Chưa có phiên học nào trong tuần này',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CHI TIẾT TỪNG NGÀY',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                color: AppColors.textSecondary, letterSpacing: 0.8)),
        const SizedBox(height: 12),
        ...daysWithLogs.map((d) => _dayCard(d)),
      ],
    );
  }

  Widget _dayCard(_DayData d) {
    final dow = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'][d.date.weekday - 1];
    final dateStr = '$dow, ${d.date.day}/${d.date.month}';
    final durMin = d.durationSeconds ~/ 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(dateStr,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const Spacer(),
              if (d.logs.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${d.logs.length} bài',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
              if (durMin > 0) ...[
                const SizedBox(width: 6),
                Text('${durMin}p',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ],
          ),
          const SizedBox(height: 10),
          ...d.logs.map((l) {
            final name = l['lessonName'] as String? ?? 'Bài học';
            final act = (l['activityType'] as String? ?? '').replaceAll('_', ' ');
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(width: 5, height: 5,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(name,
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Text(act,
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DayData {
  final DateTime date;
  final String label;
  final List<Map<String, dynamic>> logs;
  final int durationSeconds;
  _DayData({required this.date, required this.label, required this.logs, required this.durationSeconds});
}
