import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/api_service.dart';
import 'result_page.dart';

// ─── Data model ─────────────────────────────────────────────────────────────

class _Question {
  final String category; // Grammar / Vocabulary / Listening / Reading
  final String level;    // A1, A2, B1, B2, C1, C2
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _Question({
    required this.category,
    required this.level,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

const _questions = [
  // A1-A2
  _Question(
    category: 'Grammar', level: 'A1',
    question: 'She ___ to school every day.',
    options: ['go', 'goes', 'going', 'gone'],
    correctIndex: 1,
    explanation: 'Present Simple với he/she/it thêm -s vào động từ.',
  ),
  _Question(
    category: 'Vocabulary', level: 'A1',
    question: 'What is the opposite of "hot"?',
    options: ['warm', 'cold', 'cool', 'heat'],
    correctIndex: 1,
    explanation: '"Cold" là từ trái nghĩa của "hot".',
  ),
  // B1
  _Question(
    category: 'Grammar', level: 'B1',
    question: 'If I ___ more time, I would travel more.',
    options: ['have', 'had', 'has', 'having'],
    correctIndex: 1,
    explanation: 'Câu điều kiện loại 2: If + S + V2/ed, S + would + V.',
  ),
  _Question(
    category: 'Vocabulary', level: 'B1',
    question: 'The meeting was ___ due to the storm.',
    options: ['cancelled', 'delayed', 'postponed', 'All of the above'],
    correctIndex: 3,
    explanation: '"Cancelled", "delayed", và "postponed" đều có thể dùng trong ngữ cảnh này.',
  ),
  _Question(
    category: 'Grammar', level: 'B1',
    question: 'She has been working here ___ 2018.',
    options: ['for', 'since', 'from', 'during'],
    correctIndex: 1,
    explanation: '"Since" dùng với mốc thời gian cụ thể (năm, ngày).',
  ),
  // B2
  _Question(
    category: 'Grammar', level: 'B2',
    question: '"By tomorrow, she ___ the report."',
    options: ['finish', 'is finishing', 'will have finished', 'has finished'],
    correctIndex: 2,
    explanation: 'Future Perfect — hoàn thành trước thời điểm tương lai.',
  ),
  _Question(
    category: 'Vocabulary', level: 'B2',
    question: 'The new policy will ___ thousands of employees.',
    options: ['effect', 'affect', 'impact on', 'result'],
    correctIndex: 1,
    explanation: '"Affect" (verb) = ảnh hưởng đến. "Effect" là danh từ.',
  ),
  _Question(
    category: 'Grammar', level: 'B2',
    question: 'The suspect denied ___ the money.',
    options: ['steal', 'to steal', 'stealing', 'stolen'],
    correctIndex: 2,
    explanation: '"Deny" followed by V-ing (gerund).',
  ),
  // C1
  _Question(
    category: 'Grammar', level: 'C1',
    question: 'Had the manager ___ sooner, the problem would have been avoided.',
    options: ['acted', 'act', 'been acted', 'acting'],
    correctIndex: 0,
    explanation: 'Third conditional inverted form: Had + S + V3, ... would have + V3.',
  ),
  // C2
  _Question(
    category: 'Vocabulary', level: 'C2',
    question: 'The politician\'s speech was full of ___ — sounding meaningful but saying nothing.',
    options: ['rhetoric', 'platitudes', 'verbiage', 'bombast'],
    correctIndex: 1,
    explanation: '"Platitudes" = những câu sáo rỗng, nghe có vẻ sâu sắc nhưng vô nghĩa.',
  ),
];

// ─── Widget ──────────────────────────────────────────────────────────────────

class Step4PlacementTest extends StatefulWidget {
  final String targetLanguageId;
  final String goal;      // backend enum value
  final String dailyTime; // backend enum value
  final String? ageGroup;
  final VoidCallback onBack;

  const Step4PlacementTest({
    super.key,
    required this.targetLanguageId,
    required this.goal,
    required this.dailyTime,
    this.ageGroup,
    required this.onBack,
  });

  @override
  State<Step4PlacementTest> createState() => _Step4PlacementTestState();
}

class _Step4PlacementTestState extends State<Step4PlacementTest> {
  int _current = 0;
  final Map<int, int> _answers = {}; // questionIndex → selectedOptionIndex
  bool _showExplanation = false;
  bool _isSubmitting = false;

  void _select(int optionIndex) {
    if (_answers.containsKey(_current)) return; // already answered
    setState(() {
      _answers[_current] = optionIndex;
      _showExplanation = true;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _showExplanation = false;
      });
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    // Calculate scores per skill
    final Map<String, int> correct = {'Grammar': 0, 'Vocabulary': 0, 'Listening': 0, 'Reading': 0};
    final Map<String, int> total = {'Grammar': 0, 'Vocabulary': 0, 'Listening': 0, 'Reading': 0};

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      total[q.category] = (total[q.category] ?? 0) + 1;
      if (_answers[i] == q.correctIndex) {
        correct[q.category] = (correct[q.category] ?? 0) + 1;
      }
    }

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) score++;
    }

    // Map CEFR score to backend selfLevel enum
    final selfLevel = _scoreToSelfLevel(score);
    final cefrLevel = _scoreToCefr(score);

    final response = await ApiService.submitOnboarding(
      targetLanguageId: widget.targetLanguageId,
      selfLevel: selfLevel,
      goal: widget.goal,
      dailyTime: widget.dailyTime,
      ageGroup: widget.ageGroup,
    );

    if (!mounted) return;

    // Skill percentages for result page
    final skills = {
      'Grammar': _pct(correct['Grammar']!, total['Grammar']!.clamp(1, 99)),
      'Vocabulary': _pct(correct['Vocabulary']!, total['Vocabulary']!.clamp(1, 99)),
      'Listening': 50, // no listening questions in placement test
      'Reading': _pct(correct['Reading'] ?? 0, (total['Reading'] ?? 0).clamp(1, 99)),
    };

    setState(() => _isSubmitting = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          level: cefrLevel,
          skills: skills,
          score: score,
          total: _questions.length,
          onboardingResponse: response,
        ),
      ),
    );
  }

  int _pct(int c, int t) => t == 0 ? 0 : ((c / t) * 100).round();

  String _scoreToCefr(int score) {
    if (score <= 2) return 'A1';
    if (score <= 4) return 'A2';
    if (score <= 5) return 'B1';
    if (score <= 7) return 'B2';
    if (score <= 8) return 'C1';
    return 'C2';
  }

  /// Map CEFR score to backend selfLevel enum
  String _scoreToSelfLevel(int score) {
    if (score <= 2) return 'COMPLETE_BEGINNER';
    if (score <= 4) return 'BEGINNER';
    if (score <= 7) return 'INTERMEDIATE';
    return 'ADVANCED';
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
    final answered = _answers[_current];

    return SafeArea(
      child: Column(
        children: [
          // Header with progress
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 24, 4),
            child: Row(
              children: [
                if (_current == 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary, size: 20),
                    onPressed: widget.onBack,
                  )
                else
                  const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bước 4 / 4',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: (_current + 1) / _questions.length,
                        backgroundColor: const Color(0xFF0D2540),
                        color: AppColors.primary,
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stat('${_questions.length}', 'câu hỏi'),
                _stat('5\'', 'phút'),
                _stat('A1–C2', 'CEFR'),
              ],
            ),
          ),

          // Category label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'CÂU ${_current + 1}/${_questions.length} · ${q.category.toUpperCase()}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Question
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              q.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Options
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: q.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final label = String.fromCharCode(65 + i); // A, B, C, D
                Color bg = AppColors.surface;
                Color borderColor = AppColors.border;
                Color textColor = AppColors.textPrimary;

                if (answered != null) {
                  if (i == q.correctIndex) {
                    bg = AppColors.success.withValues(alpha: 0.15);
                    borderColor = AppColors.success;
                    textColor = AppColors.success;
                  } else if (i == answered) {
                    bg = AppColors.error.withValues(alpha: 0.15);
                    borderColor = AppColors.error;
                    textColor = AppColors.error;
                  }
                }

                final isHighlighted = answered != null &&
                    (i == q.correctIndex || i == answered);

                return TappableScale(
                  onTap: answered == null ? () => _select(i) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                      boxShadow: isHighlighted ? AppShadows.subtle : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: answered != null && i == q.correctIndex
                                ? AppColors.success
                                : answered != null && i == answered
                                    ? AppColors.error
                                    : AppColors.inputBg,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: answered != null &&
                                        (i == q.correctIndex || i == answered)
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Explanation box
          if (_showExplanation && answered != null)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: AppColors.success, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      q.explanation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.success,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Next button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: GradientButton(
                label: _current < _questions.length - 1
                    ? 'Câu tiếp theo'
                    : 'Xem kết quả',
                enabled: answered != null,
                isLoading: _isSubmitting,
                onTap: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
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
    );
  }
}
