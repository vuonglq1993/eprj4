import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../home/home_placeholder.dart';

class ResultPage extends StatefulWidget {
  final String level;
  final Map<String, int> skills;
  final int score;
  final int total;
  final Map<String, dynamic>? onboardingResponse;

  const ResultPage({
    super.key,
    required this.level,
    required this.skills,
    required this.score,
    required this.total,
    this.onboardingResponse,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
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

    _heroScale = Tween<double>(begin: 0.65, end: 1.0).animate(
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  String get _levelLabel {
    const labels = {
      'A1': 'Beginner',
      'A2': 'Elementary',
      'B1': 'Intermediate',
      'B2': 'Upper-Intermediate',
      'C1': 'Advanced',
      'C2': 'Proficient',
    };
    return labels[widget.level] ?? '';
  }

  String get _motivationMessage {
    final msg =
        widget.onboardingResponse?['motivationMessage'] as String?;
    if (msg != null && msg.isNotEmpty) return msg;
    final lowestSkill = widget.skills.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
    return 'Tập trung cải thiện $lowestSkill — AI sẽ ưu tiên bài $lowestSkill trong lộ trình.';
  }

  Map<String, dynamic>? get _recommendedPath =>
      widget.onboardingResponse?['recommendedPath'] as Map<String, dynamic>?;

  Color _barColor(String skill) {
    switch (skill) {
      case 'Grammar':
        return AppColors.grammar;
      case 'Vocabulary':
        return AppColors.vocabulary;
      case 'Listening':
        return AppColors.listening;
      case 'Reading':
        return AppColors.reading;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
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
                  const SizedBox(height: 40),

                  // ── Star / level hero ──────────────────────────────────
                  AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, __) => FadeTransition(
                      opacity: _heroOpacity,
                      child: ScaleTransition(
                        scale: _heroScale,
                        child: Column(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                gradient: AppGradients.primaryIcon,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.primaryGlowSoft,
                              ),
                              child: const Icon(Icons.star_rounded,
                                  size: 50, color: Colors.white),
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'Trình độ của bạn',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppGradients.primaryButton
                                      .createShader(bounds),
                              child: Text(
                                widget.level,
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _levelLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${widget.score} / ${widget.total} câu đúng',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Content ────────────────────────────────────────────
                  AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, child) => FadeTransition(
                      opacity: _contentOpacity,
                      child: SlideTransition(
                          position: _contentSlide, child: child!),
                    ),
                    child: Column(
                      children: [
                        // Skill breakdown
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppShadows.card,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ĐIỂM THEO KỸ NĂNG',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...widget.skills.entries
                                  .map((e) => _skillRow(e.key, e.value)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Motivation
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.warning
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_awesome_rounded,
                                  color: AppColors.warning, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'AI gợi ý',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _motivationMessage,
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

                        if (_recommendedPath != null) ...[
                          const SizedBox(height: 16),
                          _recommendedPathCard(_recommendedPath!),
                        ],

                        const SizedBox(height: 32),

                        GradientButton(
                          label: 'Bắt đầu học ngay',
                          onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePlaceholder()),
                            (r) => false,
                          ),
                        ),

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

  Widget _skillRow(String skill, int percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
              Text('$percent%',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _barColor(skill))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: percent / 100),
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.inputBg,
                color: _barColor(skill),
                minHeight: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendedPathCard(Map<String, dynamic> path) {
    final title = path['title'] as String? ?? '';
    final description = path['description'] as String? ?? '';
    final totalSteps = path['totalSteps'] as int? ?? 0;
    final estimatedHours = path['estimatedHours'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.route_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text(
                'LỘ TRÌNH ĐỀ XUẤT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(description,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              _pathStat(Icons.list_alt_rounded, '$totalSteps bước'),
              const SizedBox(width: 16),
              _pathStat(Icons.access_time_rounded, '${estimatedHours}h'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pathStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
