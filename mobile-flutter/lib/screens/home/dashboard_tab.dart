import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/learning_service.dart';
import '../../l10n/l10n_ext.dart';
import '../course/course_lessons_screen.dart';
import '../lesson/lesson_player_screen.dart';

class DashboardTab extends StatefulWidget {
  final VoidCallback? onGoToLearningPath;
  const DashboardTab({super.key, this.onGoToLearningPath});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Map<String, dynamic>? _dashboard;
  bool _loading = true;
  // tracks which courseId is currently loading the next lesson
  String? _loadingNextFor;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Gọi song song dashboard + danh sách lộ trình đã enroll
    final results = await Future.wait([
      LearningService.getDashboard(),
      LearningService.getMyLearningPaths(),
    ]);

    if (!mounted) return;

    final dashboard = results[0] as Map<String, dynamic>?;
    final myPaths = results[1] as List<Map<String, dynamic>>;

    // Courses đã có trong dashboard (đã từng submit exercise)
    final dashCourses = (dashboard?['activeCourses'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final existingIds =
        dashCourses.map((c) => c['courseId'] as String? ?? '').toSet();

    // Fetch detail các path đã enroll (tối đa 5, parallel)
    final enrolledPaths = myPaths
        .where((p) {
          final s = p['enrollStatus'] as String? ?? '';
          return s == 'IN_PROGRESS' || s == 'ENROLLED' || s == 'COMPLETED';
        })
        .take(5)
        .toList();

    List<Map<String, dynamic>> pathDetails = [];
    if (enrolledPaths.isNotEmpty) {
      pathDetails = await Future.wait(
        enrolledPaths.map((p) async {
          final id = p['id'] as String? ?? '';
          if (id.isEmpty) return <String, dynamic>{};
          return await LearningService.getLearningPathDetail(id) ??
              <String, dynamic>{};
        }),
      );
    }

    // Build list courses từ steps của các path, bỏ qua courses đã có
    final pathCourses = <Map<String, dynamic>>[];
    for (int i = 0; i < pathDetails.length; i++) {
      final detail = pathDetails[i];
      if (detail.isEmpty) continue;
      final languageName = detail['languageName'] as String? ?? '';
      final steps =
          (detail['steps'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (final step in steps) {
        final courseId = step['courseId']?.toString() ?? '';
        if (courseId.isEmpty || existingIds.contains(courseId)) continue;
        existingIds.add(courseId); // tránh trùng từ path khác
        pathCourses.add({
          'courseId': courseId,
          'courseTitle': step['courseTitle'] as String? ?? '',
          'languageName': languageName,
          'totalLessons': step['totalLessons'] as int? ?? 0,
          'completedLessons': 0,
          'progressPercent': step['courseProgressPercent'] as int? ?? 0,
          'nextLessonId': null,
          'nextLessonTitle': null,
        });
      }
    }

    // Merge: dashboard courses trước, sau đó path courses
    final merged = [...dashCourses, ...pathCourses];

    // Gắn merged vào dashboard map để _buildActiveCoursesSection dùng
    final merged_dashboard = dashboard != null
        ? {...dashboard, 'activeCourses': merged}
        : <String, dynamic>{'activeCourses': merged};

    setState(() {
      _dashboard = merged_dashboard;
      _loading = false;
    });
  }

  /// Lấy lesson type rồi mở thẳng bài học tiếp theo.
  Future<void> _openNextLesson(
      String courseId, String courseTitle, String lessonId) async {
    if (_loadingNextFor == courseId) return;
    setState(() => _loadingNextFor = courseId);

    try {
      final lessons = await LearningService.getLessons(courseId);
      if (!mounted) return;
      final lesson = lessons.firstWhere(
        (l) => (l['id'] as String? ?? '') == lessonId,
        orElse: () => <String, dynamic>{},
      );
      if (!mounted) return;

      final type = (lesson['type'] as String? ?? 'MIXED').toUpperCase();
      final title = lesson['title'] as String? ?? courseTitle;

      final route = PageRouteBuilder(
        pageBuilder: (_, __, ___) => LessonPlayerScreen(
          courseId: courseId,
          lessonId: lessonId,
          lessonTitle: title,
          lessonType: type,
        ),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, anim, __, child) {
          final slide = Tween<Offset>(
                  begin: const Offset(0.05, 0), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: SlideTransition(position: slide, child: child),
          );
        },
      );

      await Navigator.push(context, route);
      if (mounted) _load(); // refresh dashboard sau khi về
    } finally {
      if (mounted) setState(() => _loadingNextFor = null);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _greeting(BuildContext context) {
    final h = DateTime.now().hour;
    if (h < 12) return context.l10n.morningGreeting;
    if (h < 18) return context.l10n.afternoonGreeting;
    return context.l10n.eveningGreeting;
  }

  Color _typeColor(String type) {
    switch (type.toUpperCase()) {
      case 'GRAMMAR':
        return AppColors.grammar;
      case 'VOCABULARY':
        return AppColors.vocabulary;
      case 'LISTENING':
        return AppColors.listening;
      case 'SPEAKING':
        return AppColors.success;
      case 'READING':
        return AppColors.reading;
      case 'WRITING':
        return AppColors.warning;
      default:
        return AppColors.primaryLight;
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'GRAMMAR':
        return Icons.edit_note_rounded;
      case 'VOCABULARY':
        return Icons.menu_book_rounded;
      case 'LISTENING':
        return Icons.headphones_rounded;
      case 'SPEAKING':
        return Icons.mic_rounded;
      case 'READING':
        return Icons.chrome_reader_mode_rounded;
      case 'WRITING':
        return Icons.draw_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _typeLabel(String type) {
    final m = {
      'GRAMMAR': context.l10n.grammar,
      'VOCABULARY': context.l10n.vocabulary,
      'LISTENING': context.l10n.listening,
      'SPEAKING': context.l10n.speaking,
      'READING': context.l10n.reading,
      'WRITING': context.l10n.writing,
    };
    return m[type.toUpperCase()] ?? type;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Top gradient overlay
          Positioned(
            top: 0, left: 0, right: 0, height: 240,
            child: Container(
              decoration:
                  const BoxDecoration(gradient: AppGradients.bgTop),
            ),
          ),

          SafeArea(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary))
                : RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    onRefresh: _load,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                            child: _buildHeader()),
                        SliverToBoxAdapter(
                            child: _buildStatsRow()),
                        SliverToBoxAdapter(
                            child: _buildWeeklySection()),
                        SliverToBoxAdapter(
                            child: _buildActiveCoursesSection()),
                        SliverToBoxAdapter(
                            child: _buildSkillsSection()),
                        SliverToBoxAdapter(
                            child: _buildAiSuggestion()),
                        const SliverToBoxAdapter(
                            child: SizedBox(height: 32)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(context),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.appName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Streak badge
          _streakBadge(),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryIcon,
              shape: BoxShape.circle,
              boxShadow: AppShadows.primaryGlow,
            ),
            child: const Center(
              child: Text(
                'U',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streakBadge() {
    final streak =
        _dashboard?['currentStreak'] as int? ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.warning, size: 16),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    final totalLessons =
        _dashboard?['totalLessonsCompleted'] as int? ?? 0;
    final totalMinutes =
        _dashboard?['totalStudyMinutes'] as int? ?? 0;
    final avgScore = _dashboard?['averageScore'] as num? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _statCard(
            Icons.check_circle_outline_rounded,
            '$totalLessons',
            context.l10n.lessonsCompleted,
            AppColors.success,
          ),
          const SizedBox(width: 10),
          _statCard(
            Icons.timer_outlined,
            '$totalMinutes',
            context.l10n.minutesLearned,
            AppColors.vocabulary,
          ),
          const SizedBox(width: 10),
          _statCard(
            Icons.star_border_rounded,
            '${avgScore.toStringAsFixed(0)}%',
            context.l10n.avgScore,
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Weekly Summary ─────────────────────────────────────────────────────────

  Widget _buildWeeklySection() {
    final thisWeek =
        _dashboard?['thisWeek'] as Map<String, dynamic>?;
    if (thisWeek == null) return const SizedBox.shrink();

    final weekMinutes = thisWeek['studyMinutes'] as int? ?? 0;
    final weekLessons = thisWeek['lessonsCompleted'] as int? ?? 0;
    final daily =
        (thisWeek['daily'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

    // Tìm max để scale bar
    final maxMinutes = daily.fold<int>(
        1,
        (prev, d) =>
            ((d['studyMinutes'] as int? ?? 0) > prev)
                ? (d['studyMinutes'] as int)
                : prev);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.l10n.thisWeek,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$weekMinutes phút · $weekLessons bài',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: daily.map((d) {
                final minutes = d['studyMinutes'] as int? ?? 0;
                final dayLabel = d['dayLabel'] as String? ?? '';
                final hasActivity = minutes > 0;
                final barHeight =
                    hasActivity ? (minutes / maxMinutes * 60).clamp(8.0, 60.0) : 4.0;

                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasActivity)
                        Text(
                          '$minutes',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.primary
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: barHeight,
                        decoration: BoxDecoration(
                          gradient: hasActivity
                              ? AppGradients.primaryButton
                              : null,
                          color: hasActivity
                              ? null
                              : AppColors.inputBg
                                  .withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: hasActivity
                              ? AppShadows.primaryGlow
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dayLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: hasActivity
                              ? AppColors.primaryLight
                              : AppColors.textHint,
                          fontWeight: hasActivity
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Active Courses ─────────────────────────────────────────────────────────

  Widget _buildActiveCoursesSection() {
    final courses =
        (_dashboard?['activeCourses'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.currentlyLearning,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (courses.isEmpty)
            _emptyCoursesCard()
          else
            ...courses.map(_activeCourseCard),
        ],
      ),
    );
  }

  Widget _emptyCoursesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          const Icon(Icons.school_outlined,
              color: AppColors.textSecondary, size: 36),
          const SizedBox(height: 12),
          Text(
            context.l10n.noCourses,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.exploreLearningPath,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          if (widget.onGoToLearningPath != null) ...[
            const SizedBox(height: 16),
            TappableScale(
              onTap: widget.onGoToLearningPath!,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppShadows.primaryGlow,
                ),
                child: Text(
                  context.l10n.explorePath,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _activeCourseCard(Map<String, dynamic> course) {
    final courseId = course['courseId'] as String? ?? '';
    final title = course['courseTitle'] as String? ?? '';
    final language = course['languageName'] as String? ?? '';
    final progress = course['progressPercent'] as int? ?? 0;
    final completed = course['completedLessons'] as int? ?? 0;
    final total = course['totalLessons'] as int? ?? 0;
    final nextLessonId = course['nextLessonId'] as String?;
    final nextLessonTitle =
        course['nextLessonTitle'] as String? ?? context.l10n.continueLearning;

    return TappableScale(
      onTap: () => Navigator.push(
        context,
        _route(CourseLessonsScreen(courseId: courseId, courseTitle: title)),
      ).then((_) => _load()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x1E64DCFF), Color(0x0A0077B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3)),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    language,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '$progress%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$completed / $total bài học',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0, end: progress / 100),
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  backgroundColor:
                      AppColors.inputBg.withValues(alpha: 0.5),
                  color: AppColors.primary,
                  minHeight: 5,
                ),
              ),
            ),
            if (nextLessonId != null) ...[
              const SizedBox(height: 14),
              // Inner TappableScale — wins gesture arena vs outer card tap
              TappableScale(
                onTap: () => _openNextLesson(courseId, title, nextLessonId),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.nextLesson,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              nextLessonTitle,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _loadingNextFor == courseId
                          ? const SizedBox(
                              width: 34,
                              height: 34,
                              child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5),
                            )
                          : Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppGradients.primaryButton,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.primaryGlow,
                              ),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 18),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Skills Breakdown ───────────────────────────────────────────────────────

  Widget _buildSkillsSection() {
    final skills =
        _dashboard?['skills'] as Map<String, dynamic>?;
    if (skills == null) return const SizedBox.shrink();

    final skillList = [
      ('listening', context.l10n.listening, AppColors.listening),
      ('speaking', context.l10n.speaking, AppColors.success),
      ('reading', context.l10n.reading, AppColors.reading),
      ('writing', context.l10n.writing, AppColors.warning),
      ('vocabulary', context.l10n.vocabulary, AppColors.vocabulary),
      ('grammar', context.l10n.grammar, AppColors.grammar),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.skill,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: skillList.map((entry) {
                final (key, label, color) = entry;
                final skillData =
                    skills[key] as Map<String, dynamic>?;
                final score =
                    (skillData?['averageScore'] as num?)?.toInt() ??
                        0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            tween: Tween(begin: 0, end: score / 100),
                            builder: (_, v, __) =>
                                LinearProgressIndicator(
                              value: v,
                              backgroundColor: AppColors.inputBg,
                              color: color,
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 34,
                        child: Text(
                          '$score%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── AI Suggestion ──────────────────────────────────────────────────────────

  Widget _buildAiSuggestion() {
    final skills =
        _dashboard?['skills'] as Map<String, dynamic>?;
    if (skills == null) return const SizedBox.shrink();

    // Find weakest skill
    final skillKeys = [
      'listening', 'speaking', 'reading', 'writing', 'vocabulary', 'grammar'
    ];
    String weakestKey = 'grammar';
    int lowestScore = 100;
    for (final k in skillKeys) {
      final s = skills[k] as Map<String, dynamic>?;
      final score = (s?['averageScore'] as num?)?.toInt() ?? 0;
      if (score < lowestScore) {
        lowestScore = score;
        weakestKey = k;
      }
    }

    final labelMap = {
      'listening': context.l10n.listening,
      'speaking': context.l10n.speaking,
      'reading': context.l10n.reading,
      'writing': context.l10n.writing,
      'vocabulary': context.l10n.vocabulary,
      'grammar': context.l10n.grammar,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppGradients.primaryIcon,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.aiSuggestion,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.focusImprove(labelMap[weakestKey] ?? weakestKey),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _route(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, anim, __, child) {
          final slide = Tween<Offset>(
                  begin: const Offset(0.05, 0), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: anim, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity:
                CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: SlideTransition(position: slide, child: child),
          );
        },
      );
}
