import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/learning_service.dart';
import '../../l10n/l10n_ext.dart';
import '../course/course_lessons_screen.dart';

class PathDetailScreen extends StatefulWidget {
  final String pathId;
  final String pathTitle;

  const PathDetailScreen({
    super.key,
    required this.pathId,
    required this.pathTitle,
  });

  @override
  State<PathDetailScreen> createState() => _PathDetailScreenState();
}

class _PathDetailScreenState extends State<PathDetailScreen> {
  Map<String, dynamic>? _path;
  bool _loading = true;
  bool _enrolling = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data =
        await LearningService.getLearningPathDetail(widget.pathId);
    if (!mounted) return;
    setState(() {
      _path = data;
      _loading = false;
    });
  }

  Future<void> _enroll() async {
    setState(() => _enrolling = true);
    final ok = await LearningService.enrollLearningPath(widget.pathId);
    if (!mounted) return;
    setState(() => _enrolling = false);
    if (ok) {
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enrolledPath)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enrollFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _path == null
              ? _errorBody()
              : _buildBody(),
    );
  }

  Widget _errorBody() {
    return SafeArea(
      child: Column(
        children: [
          _backButton(),
          Expanded(
            child: Center(
              child: Text(
                context.l10n.cannotLoadPath,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final path = _path!;
    final title = path['title'] as String? ?? '';
    final description = path['description'] as String? ?? '';
    final language = path['languageName'] as String? ?? '';
    final goal = path['goal'] as String? ?? '';
    final estimatedHours = path['estimatedHours'] as int? ?? 0;
    final totalSteps = path['totalSteps'] as int? ?? 0;
    final progress = path['progressPercent'] as int? ?? 0;
    final enrollStatus = path['enrollStatus'] as String?;
    final isEnrolled = enrollStatus == 'ENROLLED' ||
        enrollStatus == 'IN_PROGRESS' ||
        enrollStatus == 'COMPLETED';
    final steps =
        (path['steps'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Stack(
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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    _backButton(),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Path info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1C1845), Color(0xFF141430)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.3)),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _badge(language),
                                if (isEnrolled) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '$progress%',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (description.isNotEmpty) ...[
                              Text(
                                description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (goal.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(Icons.flag_rounded,
                                      size: 14,
                                      color: AppColors.primaryLight),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      goal,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primaryLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (isEnrolled)
                              TweenAnimationBuilder<double>(
                                duration:
                                    const Duration(milliseconds: 800),
                                curve: Curves.easeOutCubic,
                                tween: Tween(
                                    begin: 0, end: progress / 100),
                                builder: (_, v, __) =>
                                    ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: v,
                                    backgroundColor: AppColors.inputBg
                                        .withValues(alpha: 0.5),
                                    color: AppColors.primary,
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _meta(Icons.layers_rounded,
                                    context.l10n.steps(totalSteps)),
                                const SizedBox(width: 16),
                                _meta(Icons.access_time_rounded,
                                    context.l10n.estimatedHours(estimatedHours.toString())),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Steps timeline
                      Text(
                        context.l10n.pathSteps,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...List.generate(steps.length, (i) {
                        return _stepItem(steps[i], i, steps.length);
                      }),

                      const SizedBox(height: 24),

                      // Enroll button
                      if (!isEnrolled)
                        GradientButton(
                          label: context.l10n.enrollPath,
                          isLoading: _enrolling,
                          onTap: _enroll,
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepItem(
      Map<String, dynamic> step, int index, int total) {
    final courseId = step['courseId'] as String? ?? '';
    final courseTitle = step['courseTitle'] as String? ?? '';
    final courseLevel = step['courseLevel'] as String? ?? '';
    final stepOrder = step['stepOrder'] as int? ?? (index + 1);
    final totalLessons = step['totalLessons'] as int? ?? 0;
    final courseProgress =
        step['courseProgressPercent'] as int? ?? 0;
    final isUnlocked = step['isUnlocked'] as bool? ?? false;
    final isRequired = step['isRequired'] as bool? ?? true;
    final note = step['note'] as String? ?? '';

    final isCompleted = courseProgress == 100;
    final isLast = index == total - 1;

    Color statusColor;
    IconData statusIcon;
    if (isCompleted) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_rounded;
    } else if (isUnlocked) {
      statusColor = AppColors.primary;
      statusIcon = Icons.play_arrow_rounded;
    } else {
      statusColor = AppColors.textHint;
      statusIcon = Icons.lock_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success
                      : isUnlocked
                          ? AppColors.primary
                          : AppColors.inputBg,
                  shape: BoxShape.circle,
                  boxShadow: isUnlocked && !isCompleted
                      ? AppShadows.primaryGlow
                      : null,
                ),
                child: Icon(statusIcon,
                    size: 16, color: Colors.white),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.5),
                          AppColors.border,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Step card
          Expanded(
            child: TappableScale(
              onTap: isUnlocked || isCompleted
                  ? () => Navigator.push(
                        context,
                        _route(CourseLessonsScreen(
                          courseId: courseId,
                          courseTitle: courseTitle,
                        )),
                      )
                  : null,
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withValues(alpha: 0.08)
                      : isUnlocked
                          ? AppColors.surface
                          : AppColors.inputBg.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.3)
                        : isUnlocked
                            ? AppColors.border
                            : AppColors.border
                                .withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.l10n.stepTitle(stepOrder),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                        if (!isRequired) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.textHint
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              context.l10n.optional,
                              style: const TextStyle(
                                fontSize: 8,
                                color: AppColors.textHint,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (isCompleted)
                          const Icon(Icons.workspace_premium_rounded,
                              size: 14, color: AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      courseTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked || isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          courseLevel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.l10n.lessons(totalLessons),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (courseProgress > 0) ...[
                          const SizedBox(width: 10),
                          Text(
                            '$courseProgress%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (courseProgress > 0 && !isCompleted) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: courseProgress / 100,
                          backgroundColor: AppColors.inputBg,
                          color: AppColors.primary,
                          minHeight: 3,
                        ),
                      ),
                    ],
                    if (note.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        note,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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

  Widget _backButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary, size: 20),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
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
