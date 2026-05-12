import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../services/ai_service.dart';
import '../../services/learning_service.dart';
import '../../l10n/l10n_ext.dart';

class AiRecommendScreen extends StatefulWidget {
  const AiRecommendScreen({super.key});

  @override
  State<AiRecommendScreen> createState() => _AiRecommendScreenState();
}

class _AiRecommendScreenState extends State<AiRecommendScreen> {
  bool _loading = true;
  AiRecommendResult? _result;
  String? _error;

  // Context fetched from dashboard
  Map<String, dynamic>? _dashboard;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });

    _dashboard = await LearningService.getDashboard();

    if (!mounted) return;

    final res = await AiService.getRecommendations(
      dashboard: _dashboard,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (res != null) {
        _result = res;
      } else {
        _error = context.l10n.cannotCreateSuggestion;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0, height: 200,
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: AppGradients.bgTop)),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _loading
                        ? _buildLoading()
                        : _error != null
                            ? _buildError()
                            : _buildContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.lightbulb_rounded,
                color: AppColors.warning, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.aiRecommendation,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Text(context.l10n.lessonSuggestions,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (!_loading)
            GestureDetector(
              onTap: _load,
              child: Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.refresh_rounded,
                    size: 16, color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 30, height: 30,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: AppColors.warning),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(context.l10n.aiAnalyzingPath,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(context.l10n.reviewingPath,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: AppColors.textSecondary, size: 48),
            const SizedBox(height: 16),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _load,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(context.l10n.retry,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Content ───────────────────────────────────────────────────────────────

  Widget _buildContent() {
    final r = _result!;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        // User snapshot card
        if (_dashboard != null) _buildSnapshotCard(),
        const SizedBox(height: 16),

        // Study tip
        if (r.studyTip.isNotEmpty) ...[
          _buildStudyTipCard(r.studyTip),
          const SizedBox(height: 16),
        ],

        // Focus skills
        if (r.focusSkills.isNotEmpty) ...[
          _buildFocusSkillsCard(r.focusSkills),
          const SizedBox(height: 16),
        ],

        // Recommended lessons
        if (r.lessons.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.bookmark_rounded,
                  size: 14, color: AppColors.warning),
              const SizedBox(width: 6),
              Text(
                '${context.l10n.suggestedLessons} (${r.lessons.length})',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...r.lessons.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RecommendCard(
                  item: e.value, rank: e.key + 1),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSnapshotCard() {
    final d = _dashboard!;
    final avgScore = (d['averageScore'] as num?)?.toDouble() ?? 0;
    final streak = (d['currentStreak'] as num?)?.toInt() ?? 0;
    final completed = (d['totalLessonsCompleted'] as num?)?.toInt() ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x1E64DCFF), Color(0x0A0077B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.learningOverview,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatItem(
                  icon: Icons.star_rounded,
                  value: '${avgScore.toStringAsFixed(0)}%',
                  label: context.l10n.avgScoreLabel,
                  color: AppColors.warning),
              const SizedBox(width: 12),
              _StatItem(
                  icon: Icons.local_fire_department_rounded,
                  value: '$streak',
                  label: context.l10n.streakDaysLabel,
                  color: AppColors.error),
              const SizedBox(width: 12),
              _StatItem(
                  icon: Icons.check_circle_rounded,
                  value: '$completed',
                  label: context.l10n.completedLessons,
                  color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudyTipCard(String tip) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_rounded,
                size: 16, color: AppColors.warning),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.aiAdvice,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning)),
                const SizedBox(height: 4),
                Text(tip,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusSkillsCard(List<String> skills) {
    final skillMeta = {
      'Listening': (Icons.headphones_rounded, AppColors.listening),
      'Speaking': (Icons.mic_rounded, AppColors.success),
      'Reading': (Icons.chrome_reader_mode_rounded, AppColors.reading),
      'Writing': (Icons.draw_rounded, AppColors.warning),
      'Vocabulary': (Icons.menu_book_rounded, AppColors.vocabulary),
      'Grammar': (Icons.spellcheck_rounded, AppColors.grammar),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes_rounded,
                  size: 13, color: AppColors.error),
              const SizedBox(width: 6),
              Text(context.l10n.skillsToFocus,
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((s) {
              final meta = skillMeta[s] ??
                  (Icons.school_rounded, AppColors.primaryLight);
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: meta.$2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: meta.$2.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(meta.$1, size: 13, color: meta.$2),
                    const SizedBox(width: 5),
                    Text(s,
                        style: TextStyle(
                            fontSize: 12,
                            color: meta.$2,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Recommend card ────────────────────────────────────────────────────────

class _RecommendCard extends StatelessWidget {
  final AiRecommendLesson item;
  final int rank;

  const _RecommendCard({required this.item, required this.rank});

  @override
  Widget build(BuildContext context) {
    final priorityColor = rank == 1
        ? AppColors.warning
        : rank == 2
            ? AppColors.textSecondary
            : AppColors.textHint;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: rank == 1
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.border,
        ),
        boxShadow: rank == 1
            ? [
                BoxShadow(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank badge
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border:
                  Border.all(color: priorityColor.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text('#$rank',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: priorityColor)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.isNotEmpty ? item.title : context.l10n.lessonSuggestion,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                // Reason
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 12,
                          color: AppColors.textHint),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(item.reason,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (rank == 1)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 3),
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(context.l10n.hot,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning)),
            ),
        ],
      ),
    );
  }
}

// ── Stat item ──────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 9.5, color: AppColors.textHint),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
