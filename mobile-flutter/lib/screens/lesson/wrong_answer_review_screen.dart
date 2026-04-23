import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import 'lesson_player_screen.dart';

class WrongAnswerReviewScreen extends StatefulWidget {
  final List<ExerciseAttempt> attempts;

  const WrongAnswerReviewScreen({
    super.key,
    required this.attempts,
  });

  @override
  State<WrongAnswerReviewScreen> createState() =>
      _WrongAnswerReviewScreenState();
}

class _WrongAnswerReviewScreenState extends State<WrongAnswerReviewScreen>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut),
    );
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  ExerciseAttempt get _attempt => widget.attempts[_current];

  void _next() {
    if (_current < widget.attempts.length - 1) {
      _slideCtrl.reset();
      setState(() => _current++);
      _slideCtrl.forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _prev() {
    if (_current > 0) {
      _slideCtrl.reset();
      setState(() => _current--);
      _slideCtrl.forward();
    }
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

  String _typeLabel(String type) {
    const m = {
      'GRAMMAR': 'Ngữ pháp',
      'VOCABULARY': 'Từ vựng',
      'LISTENING': 'Nghe',
      'SPEAKING': 'Nói',
      'READING': 'Đọc',
      'WRITING': 'Viết',
    };
    return m[type.toUpperCase()] ?? type;
  }

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
                _topBar(),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        child: _buildContent(),
                      ),
                    ),
                  ),
                ),
                _bottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Review câu sai',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${_current + 1} / ${widget.attempts.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Dot indicator
          Row(
            children: List.generate(widget.attempts.length, (i) {
              final isActive = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(left: 5),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.error
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final ex = _attempt.exercise;
    final type = ex['type'] as String? ?? '';
    final title = ex['title'] as String? ?? 'Câu hỏi';
    final color = _typeColor(type);
    final qData = ex['questionData'];
    Map<String, dynamic> qMap;
    if (qData is Map<String, dynamic>) {
      qMap = qData;
    } else if (qData is String && qData.isNotEmpty) {
      try { qMap = jsonDecode(qData) as Map<String, dynamic>; } catch (_) { qMap = {}; }
    } else {
      qMap = {};
    }

    final question = qMap['question'] as String? ??
        qMap['sentence'] as String? ??
        qMap['text'] as String? ??
        title;
    final options =
        (qMap['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final correctAnswer = _attempt.correctAnswer;
    final userAnswer = _attempt.userAnswer;
    final explanation = _attempt.explanation;
    final example = qMap['example'] as String? ?? '';

    // Derive correct/user answer text
    String correctText = _resolveAnswerText(correctAnswer, options, qMap);
    String userText = _resolveAnswerText(userAnswer, options, qMap);

    final isMatching = type.toUpperCase() == 'MATCHING' || type.toUpperCase() == 'DRAG_DROP';
    final pairs = (qMap['pairs'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Error badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
            boxShadow: AppShadows.subtle,
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel_rounded,
                  color: AppColors.error, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Câu ${_current + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      if (type.isNotEmpty)
                        TextSpan(
                          text: ' · ${_typeLabel(type)}',
                          style: TextStyle(color: color),
                        ),
                      const TextSpan(
                        text: '  —  Bạn làm sai',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Question
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Text(
            question,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ),

        const SizedBox(height: 16),

        if (isMatching && pairs.isNotEmpty) ...[
          const _SectionLabel(label: 'Đáp án đúng:'),
          const SizedBox(height: 8),
          _buildMatchingCorrect(pairs),
        ] else ...[
          // Your answer (wrong)
          if (userText.isNotEmpty) ...[
            const _SectionLabel(label: 'Bạn chọn:'),
            const SizedBox(height: 8),
            _answerRow(text: userText, isCorrect: false),
            const SizedBox(height: 14),
          ],
          // Correct answer
          const _SectionLabel(label: 'Đáp án đúng:'),
          const SizedBox(height: 8),
          _answerRow(
            text: correctText.isNotEmpty ? correctText : '—',
            isCorrect: true,
          ),
        ],

        const SizedBox(height: 20),

        // Explanation
        if (explanation.isNotEmpty) ...[
          const _SectionLabel(label: 'Giải thích:'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              explanation,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Example sentence
        if (example.isNotEmpty) ...[
          const _SectionLabel(label: 'Ví dụ:'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote_rounded,
                    color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    example,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMatchingCorrect(List<Map<String, dynamic>> pairs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: pairs.map((p) {
          final left = p['left'] as String? ?? '';
          final right = p['right'] as String? ?? '';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(left,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 14, color: AppColors.success),
                ),
                Expanded(
                  child: Text(right,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _resolveAnswerText(
      dynamic answer, List<String> options, Map<String, dynamic> qMap) {
    if (answer == null) return '';

    // Map with 'selectedIndex' key (offline grading)
    if (answer is Map) {
      final idx = (answer['selectedIndex'] ?? answer['index']) as int?;
      if (idx != null && idx >= 0 && idx < options.length) {
        return options[idx];
      }
      final ans = answer['answer'] as String?;
      if (ans != null) return ans;
      return '';
    }

    // Int index into options list
    if (answer is int && options.isNotEmpty) {
      if (answer >= 0 && answer < options.length) return options[answer];
      return answer.toString();
    }

    // String: could be an option text or direct answer
    if (answer is String) return answer;

    return answer.toString();
  }

  Widget _answerRow({required String text, required bool isCorrect}) {
    final color = isCorrect ? AppColors.success : AppColors.error;
    final icon = isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final bgColor = color.withValues(alpha: 0.1);
    final borderColor = color.withValues(alpha: 0.3);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    final isFirst = _current == 0;
    final isLast = _current == widget.attempts.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous
          TappableScale(
            onTap: isFirst ? null : _prev,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isFirst
                    ? AppColors.inputBg.withValues(alpha: 0.5)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isFirst
                      ? AppColors.border.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: isFirst
                    ? AppColors.textHint
                    : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Next / Finish
          Expanded(
            child: GradientButton(
              label: isLast ? 'Hoàn thành' : 'Tiếp theo',
              onTap: _next,
              height: 52,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}
