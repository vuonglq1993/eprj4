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
  Map<String, dynamic>? _profile;
  bool _loading = true;

  // All possible badges defined client-side
  static const _allBadges = [
    _BadgeDef('STREAK_7',     '🔥',  'Week Warrior',       'Học 7 ngày liên tiếp'),
    _BadgeDef('STREAK_30',    '🔥🔥', 'Monthly Master',     'Học 30 ngày liên tiếp'),
    _BadgeDef('STREAK_100',   '💯🔥', 'Century Streak',     'Học 100 ngày liên tiếp'),
    _BadgeDef('FIRST_LESSON', '⭐',  'First Step',         'Hoàn thành bài học đầu tiên'),
    _BadgeDef('LESSONS_10',   '📚',  'Dedicated Learner',  'Hoàn thành 10 bài học'),
    _BadgeDef('LESSONS_50',   '🎓',  'Knowledge Seeker',   'Hoàn thành 50 bài học'),
    _BadgeDef('LESSONS_100',  '🏆',  'Century Scholar',    'Hoàn thành 100 bài học'),
    _BadgeDef('FIRST_COURSE', '🎯',  'Course Completer',   'Hoàn thành khoá học đầu tiên'),
    _BadgeDef('COURSES_5',    '🌟',  'Multi-Course Master','Hoàn thành 5 khoá học'),
    _BadgeDef('PERFECT_SCORE','💎',  'Perfectionist',      'Đạt điểm tuyệt đối'),
    _BadgeDef('HIGH_SCORER',  '🥇',  'High Achiever',      'Điểm trung bình ≥ 90%'),
    _BadgeDef('XP_1000',      '⚡',  'Rising Star',        'Tích lũy 1,000 XP'),
    _BadgeDef('XP_5000',      '⚡⚡', 'XP Hunter',          'Tích lũy 5,000 XP'),
    _BadgeDef('XP_10000',     '👑',  'XP Legend',          'Tích lũy 10,000 XP'),
    _BadgeDef('EARLY_BIRD',   '🌅',  'Early Bird',         'Học trước 7h sáng'),
    _BadgeDef('NIGHT_OWL',    '🦉',  'Night Owl',          'Học sau 22h tối'),
    _BadgeDef('POLYGLOT',     '🌍',  'Polyglot',           'Học 3 ngôn ngữ trở lên'),
  ];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final p = await GameService.getProfile();
    if (mounted) setState(() { _profile = p; _loading = false; });
  }

  Set<String> get _earnedTypes {
    final badges = _profile?['badges'] as List?;
    if (badges == null) return {};
    return badges.map((b) => (b['badgeType'] as String? ?? '')).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final earned = _earnedTypes;
    final earnedBadges = _allBadges.where((b) => earned.contains(b.type)).toList();
    final lockedBadges = _allBadges.where((b) => !earned.contains(b.type)).toList();
    final pct = (_allBadges.isEmpty ? 0 : (earned.length / _allBadges.length * 100)).round();

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
                          _topBar(context, earned.length, pct),
                          const SizedBox(height: 20),
                          if (earnedBadges.isNotEmpty) ...[
                            _sectionHeader(context.l10n.achieved, '${earnedBadges.length}'),
                            const SizedBox(height: 12),
                            _badgeGrid(earnedBadges, earned, true),
                            const SizedBox(height: 24),
                          ],
                          _sectionHeader(context.l10n.locked, '${lockedBadges.length}'),
                          const SizedBox(height: 12),
                          _badgeGrid(lockedBadges, earned, false),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context, int earnedCount, int pct) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Text(context.l10n.badges,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const Spacer(),
              Text('$earnedCount / ${_allBadges.length}',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Text('🏅', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.collection,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text('$pct%',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct / 100.0,
                        backgroundColor: AppColors.inputBg,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String label, String count) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                color: AppColors.textSecondary, letterSpacing: 0.8)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(count,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _badgeGrid(List<_BadgeDef> badges, Set<String> earned, bool isEarned) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (_, i) => _badgeCard(badges[i], isEarned),
    );
  }

  Widget _badgeCard(_BadgeDef b, bool isEarned) {
    return TappableScale(
      onTap: () => _showBadgeDetail(b, isEarned),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEarned
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEarned
                ? AppColors.primary.withValues(alpha: 0.25)
                : AppColors.border,
          ),
          boxShadow: isEarned ? AppShadows.subtle : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: isEarned
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                  : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              child: Text(b.icon, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 6),
            Text(
              b.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isEarned ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
            if (!isEarned) ...[
              const SizedBox(height: 4),
              const Icon(Icons.lock_rounded, size: 12, color: AppColors.textHint),
            ],
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(_BadgeDef b, bool isEarned) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(b.icon, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(b.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(b.desc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isEarned
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.inputBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEarned ? context.l10n.achievedBadge : context.l10n.lockedBadge,
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: isEarned ? AppColors.success : AppColors.textHint,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BadgeDef {
  final String type, icon, name, desc;
  const _BadgeDef(this.type, this.icon, this.name, this.desc);
}
