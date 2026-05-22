import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/game_service.dart';
import '../../l10n/l10n_ext.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  List<Map<String, dynamic>> _badges = [];
  bool _loading = true;

  static const _meta = {
    'STREAK_7':     ('🔥',  'Week Warrior',        'Học 7 ngày liên tiếp'),
    'STREAK_30':    ('🔥🔥', 'Monthly Master',      'Học 30 ngày liên tiếp'),
    'STREAK_100':   ('💯🔥', 'Century Streak',      'Học 100 ngày liên tiếp'),
    'FIRST_LESSON': ('⭐',  'First Step',           'Hoàn thành bài học đầu tiên'),
    'LESSONS_10':   ('📚',  'Dedicated Learner',    'Hoàn thành 10 bài học'),
    'LESSONS_50':   ('🎓',  'Knowledge Seeker',     'Hoàn thành 50 bài học'),
    'LESSONS_100':  ('🏆',  'Century Scholar',      'Hoàn thành 100 bài học'),
    'FIRST_COURSE': ('🎯',  'Course Completer',     'Hoàn thành khoá học đầu tiên'),
    'COURSES_5':    ('🌟',  'Multi-Course Master',  'Hoàn thành 5 khoá học'),
    'PERFECT_SCORE':('💎',  'Perfectionist',        'Đạt điểm tuyệt đối'),
    'HIGH_SCORER':  ('🥇',  'High Achiever',        'Điểm trung bình ≥ 90%'),
    'XP_1000':      ('⚡',  'Rising Star',          'Tích lũy 1,000 XP'),
    'XP_5000':      ('⚡⚡', 'XP Hunter',            'Tích lũy 5,000 XP'),
    'XP_10000':     ('👑',  'XP Legend',            'Tích lũy 10,000 XP'),
    'EARLY_BIRD':   ('🌅',  'Early Bird',           'Học trước 7h sáng'),
    'NIGHT_OWL':    ('🦉',  'Night Owl',            'Học sau 22h tối'),
    'POLYGLOT':     ('🌍',  'Polyglot',             'Học 3 ngôn ngữ trở lên'),
  };

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final p = await GameService.getProfile().timeout(const Duration(seconds: 10));
      if (mounted) {
        final list = (p?['badges'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList();
        setState(() { _badges = list; _loading = false; });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: Stack(
        children: [
        const Positioned(top: 0, left: 0, right: 0, height: 200,
            child: DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.bgTop))),
        SafeArea(
          child: Column(
            children: [
              _topBar(context),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: AppColors.primary,
                        child: _badges.isEmpty
                            ? _empty(context)
                            : GridView.builder(
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _badges.length,
                                itemBuilder: (_, i) => _card(_badges[i]),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(context.l10n.badges,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${_badges.length}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _card(Map<String, dynamic> badge) {
    final type = badge['badgeType'] as String? ?? '';
    final m = _meta[type];
    final icon = m?.$1 ?? '🏅';
    final name = m?.$2 ?? type;
    final desc = m?.$3 ?? '';

    return TappableScale(
      onTap: () => _showDetail(icon, name, desc),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 8),
            Text(name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 80),
        const Center(child: Text('🏅', style: TextStyle(fontSize: 64))),
        const SizedBox(height: 16),
        Center(
          child: Text('Chưa có huy hiệu nào',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text('Hoàn thành bài học để nhận huy hiệu đầu tiên',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  void _showDetail(String icon, String name, String desc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D2540),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(icon, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(desc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(context.l10n.achievedBadge,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success)),
            ),
          ],
        ),
      ),
    );
  }
}
