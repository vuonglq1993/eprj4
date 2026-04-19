import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import 'lesson_player_screen.dart';
import 'wrong_answer_review_screen.dart';

class LessonResultScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonType;
  final List<ExerciseAttempt> attempts;

  const LessonResultScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonType,
    required this.attempts,
  });

  @override
  State<LessonResultScreen> createState() => _LessonResultScreenState();
}

class _LessonResultScreenState extends State<LessonResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late Animation<double> _heroScale;
  late Animation<double> _heroOpacity;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _heroScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
    ));
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _entranceCtrl.forward());
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  // ── Stats ──────────────────────────────────────────────────────────────────

  int get _correctCount =>
      widget.attempts.where((a) => a.isCorrect == true).length;

  int get _totalCount => widget.attempts.length;

  int get _scorePercent =>
      _totalCount > 0 ? ((_correctCount / _totalCount) * 100).round() : 0;

  int get _totalXP =>
      widget.attempts.fold(0, (s, a) => s + a.pointsEarned);

  List<ExerciseAttempt> get _wrongAttempts =>
      widget.attempts.where((a) => a.isCorrect == false).toList();

  String get _resultLabel {
    if (_scorePercent >= 90) return 'Xuất sắc! 🎉';
    if (_scorePercent >= 70) return 'Tốt lắm! 👍';
    if (_scorePercent >= 50) return 'Cố gắng hơn!';
    return 'Cần ôn tập thêm';
  }

  Color get _scoreColor {
    if (_scorePercent >= 70) return AppColors.success;
    if (_scorePercent >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Color _typeColor(String type) {
    switch (type.toUpperCase()) {
      case 'GRAMMAR':
        return AppColors.grammar;
      case 'VOCABULARY':
        return AppColors.vocabulary;
      case 'LISTENING':
        return AppColors.listening;
      default:
        return AppColors.primaryLight;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 300,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.bgTop),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // Hero section
                  AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, __) => FadeTransition(
                      opacity: _heroOpacity,
                      child: ScaleTransition(
                        scale: _heroScale,
                        child: _buildHero(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Content
                  AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, child) => FadeTransition(
                      opacity: _contentOpacity,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: child!,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildStatsRow(),
                        const SizedBox(height: 16),
                        if (_wrongAttempts.isNotEmpty) ...[
                          _buildWrongAnswersCard(),
                          const SizedBox(height: 16),
                        ],
                        _buildActions(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryIcon,
            shape: BoxShape.circle,
            boxShadow: AppShadows.primaryGlowSoft,
          ),
          child: Center(
            child: Text(
              '$_scorePercent',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _resultLabel,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.lessonTitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '$_correctCount / $_totalCount câu đúng',
          style: TextStyle(
            fontSize: 13,
            color: _scoreColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard(
          Icons.workspace_premium_rounded,
          '+$_totalXP',
          'XP',
          AppColors.warning,
        ),
        const SizedBox(width: 10),
        _statCard(
          Icons.check_circle_rounded,
          '$_correctCount',
          'Đúng',
          AppColors.success,
        ),
        const SizedBox(width: 10),
        _statCard(
          Icons.cancel_rounded,
          '${_totalCount - _correctCount}',
          'Sai',
          AppColors.error,
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrongAnswersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.error.withValues(alpha: 0.2)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 18),
              const SizedBox(width: 8),
              const Text(
                'CÂU LÀM SAI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                '${_wrongAttempts.length} câu',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._wrongAttempts.take(5).map((a) {
            final ex = a.exercise;
            final title = ex['title'] as String? ?? '';
            final type = ex['type'] as String? ?? '';
            final color = _typeColor(type);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title.isNotEmpty ? title : 'Câu hỏi',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _typeShort(type),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (_wrongAttempts.length > 5) ...[
            Text(
              '+ ${_wrongAttempts.length - 5} câu nữa',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _typeShort(String type) {
    const m = {
      'GRAMMAR': 'Grammar',
      'VOCABULARY': 'Vocab',
      'LISTENING': 'Listen',
      'SPEAKING': 'Speak',
      'READING': 'Read',
      'WRITING': 'Write',
    };
    return m[type.toUpperCase()] ?? type;
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (_wrongAttempts.isNotEmpty)
          GradientButton(
            label: 'Xem lại câu sai (${_wrongAttempts.length})',
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => WrongAnswerReviewScreen(
                  attempts: _wrongAttempts,
                ),
                transitionDuration: const Duration(milliseconds: 350),
                reverseTransitionDuration:
                    const Duration(milliseconds: 250),
                transitionsBuilder: (_, anim, __, child) {
                  final slide = Tween<Offset>(
                          begin: const Offset(0.05, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOutCubic));
                  return FadeTransition(
                    opacity: CurvedAnimation(
                        parent: anim, curve: Curves.easeOut),
                    child:
                        SlideTransition(position: slide, child: child),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TappableScale(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'Về danh sách bài học',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
