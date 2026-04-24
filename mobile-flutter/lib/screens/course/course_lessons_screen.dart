import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../core/ai_button_controller.dart';
import '../../services/learning_service.dart';
import '../lesson/lesson_player_screen.dart';
import '../../l10n/l10n_ext.dart';

class CourseLessonsScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseLessonsScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseLessonsScreen> createState() => _CourseLessonsScreenState();
}

class _CourseLessonsScreenState extends State<CourseLessonsScreen> {
  Map<String, dynamic>? _course;
  List<Map<String, dynamic>> _lessons = [];
  Map<String, Map<String, dynamic>> _progressMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    AiButtonController.show();
    _load();
  }

  @override
  void dispose() {
    AiButtonController.hide();
    super.dispose();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      LearningService.getCourseDetail(widget.courseId),
      LearningService.getLessons(widget.courseId),
      LearningService.getCourseProgress(widget.courseId),
    ]);

    if (!mounted) return;

    final course = results[0] as Map<String, dynamic>?;
    final lessons =
        (results[1] as List).cast<Map<String, dynamic>>();
    final progress =
        (results[2] as List).cast<Map<String, dynamic>>();

    // Build progress map: lessonId → progress data
    final pm = <String, Map<String, dynamic>>{};
    for (final p in progress) {
      final lid = p['lessonId'] as String? ?? '';
      if (lid.isNotEmpty) pm[lid] = p;
    }

    setState(() {
      _course = course;
      _lessons = lessons;
      _progressMap = pm;
      _loading = false;
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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

  String _typeLabel(BuildContext context, String type) {
    final m = {
      'GRAMMAR': context.l10n.grammar,
      'VOCABULARY': context.l10n.vocabulary,
      'LISTENING': context.l10n.listening,
      'SPEAKING': context.l10n.speaking,
      'READING': context.l10n.reading,
      'WRITING': context.l10n.writing,
      'MIXED': 'Tổng hợp',
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
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.bgTop),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary))
                      : RefreshIndicator(
                          color: AppColors.primary,
                          backgroundColor: AppColors.surface,
                          onRefresh: _load,
                          child: _buildLessonList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final level = _course?['level'] as String? ?? '';
    final totalLessons = _course?['totalLessons'] as int? ?? _lessons.length;
    final completedCount = _progressMap.values
        .where((p) => p['status'] == 'COMPLETED')
        .length;
    final progress =
        totalLessons > 0 ? (completedCount / totalLessons) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  widget.courseTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (level.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
            ],
          ),
          if (!_loading)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 0, 4),
              child: Row(
                children: [
                  Text(
                    context.l10n.courseLessons(completedCount, totalLessons),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        tween: Tween(begin: 0, end: progress),
                        builder: (_, v, __) => LinearProgressIndicator(
                          value: v,
                          backgroundColor: AppColors.inputBg,
                          color: AppColors.primary,
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLessonList() {
    if (_lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.book_outlined,
                color: AppColors.textSecondary, size: 48),
            const SizedBox(height: 16),
            Text(
              context.l10n.noLessonsYet,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.lessonsComingSoon,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _lessonCard(_lessons[i]),
    );
  }

  Widget _lessonCard(Map<String, dynamic> lesson) {
    final lessonId = lesson['id'] as String? ?? '';
    final title = lesson['title'] as String? ?? '';
    final type = (lesson['type'] as String? ?? 'MIXED');
    final duration = lesson['durationMinutes'] as int? ?? 0;
    final isFree = lesson['isFree'] as bool? ?? false;
    final isAccessible = lesson['isAccessible'] as bool? ?? true;

    final progress = _progressMap[lessonId];
    final status = progress?['status'] as String? ?? 'NOT_STARTED';
    final score = (progress?['bestScore'] as int? ?? progress?['score'] as int? ?? 0);

    final isCompleted = status == 'COMPLETED';
    final isInProgress = status == 'IN_PROGRESS';
    final color = _typeColor(type);

    return TappableScale(
      onTap: isAccessible
          ? () => _openLesson(lesson)
          : () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.lessonRequiresPlan)),
              ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isInProgress
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.border,
          ),
          boxShadow: isInProgress ? AppShadows.subtle : null,
        ),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon(type), color: color, size: 22),
            ),
            const SizedBox(width: 14),

            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isAccessible
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _typeLabel(context, type),
                        style:
                            TextStyle(fontSize: 11, color: color),
                      ),
                      if (duration > 0) ...[
                        const Text(' · ',
                            style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 11)),
                        Text(
                          '${duration}p',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary),
                        ),
                      ],
                      if (isCompleted && score > 0) ...[
                        const Text(' · ',
                            style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 11)),
                        Text(
                          '$score%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Status icon
            if (!isAccessible)
              const Icon(Icons.lock_rounded,
                  color: AppColors.textHint, size: 18)
            else if (isCompleted)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 16),
              )
            else if (isInProgress)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.primaryGlow,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 16),
              )
            else
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: AppColors.textSecondary, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  void _openLesson(Map<String, dynamic> lesson) {
    final lessonId = lesson['id'] as String? ?? '';
    final type = (lesson['type'] as String? ?? 'MIXED').toUpperCase();

    final route = PageRouteBuilder(
      pageBuilder: (_, __, ___) => LessonPlayerScreen(
        courseId: widget.courseId,
        lessonId: lessonId,
        lessonTitle: lesson['title'] as String? ?? '',
        lessonType: type,
      ),
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, anim, __, child) {
        final slide = Tween<Offset>(
                begin: const Offset(0.05, 0), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: anim, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: SlideTransition(position: slide, child: child),
        );
      },
    );

    Navigator.push(context, route).then((_) => _load());
  }
}
