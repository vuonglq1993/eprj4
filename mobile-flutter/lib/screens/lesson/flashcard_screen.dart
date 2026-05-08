import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '../../services/learning_service.dart';
import 'lesson_player_screen.dart';
import 'lesson_result_screen.dart';

class FlashcardScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String lessonTitle;

  const FlashcardScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _exercises = [];
  bool _loading = true;
  int _current = 0;

  // Flip animation
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  bool _isFlipped = false;

  // SRS rating for each card: 0=Quên, 1=Khó, 2=Ổn, 3=Dễ
  final List<int?> _ratings = [];
  final List<ExerciseAttempt> _attempts = [];

  final _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeOutCubic),
    );
    _loadCards();
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final list = await LearningService.getExercises(
        widget.courseId, widget.lessonId);
    if (!mounted) return;
    setState(() {
      _exercises = list;
      _ratings.addAll(List.filled(list.length, null));
      _attempts.addAll(list.map((e) => ExerciseAttempt(exercise: e)));
      _loading = false;
    });
  }

  Map<String, dynamic> get _qData {
    if (_exercises.isEmpty) return {};
    final raw = _exercises[_current]['questionData'];
    if (raw is Map<String, dynamic>) return raw;
    return {};
  }

  void _flip() {
    if (_isFlipped) {
      _flipCtrl.reverse();
    } else {
      _flipCtrl.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  Future<void> _rate(int rating) async {
    _ratings[_current] = rating;
    final attempt = _attempts[_current];
    attempt.isCorrect = rating >= 2; // Ổn or Dễ = correct
    attempt.pointsEarned = rating >= 2
        ? (_exercises[_current]['points'] as int? ?? 10)
        : 0;
    attempt.userAnswer = {'srsRating': rating};

    // Submit to backend
    final now = DateTime.now();
    LearningService.submitExercise(
      courseId: widget.courseId,
      lessonId: widget.lessonId,
      exerciseId: attempt.exercise['id'] as String,
      answer: {'srsRating': rating},
      clientStartMs: _startTime.millisecondsSinceEpoch,
      clientSubmitMs: now.millisecondsSinceEpoch,
    );

    if (_current < _exercises.length - 1) {
      // Reset flip then go to next
      await _flipCtrl.reverse();
      setState(() {
        _current++;
        _isFlipped = false;
      });
    } else {
      _finish();
    }
  }

  void _finish() {
    LearningService.logStudy(
      lessonId: widget.lessonId,
      durationSeconds:
          DateTime.now().difference(_startTime).inSeconds,
      activityType: 'LESSON_VIEW',
      score: _scorePercent,
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LessonResultScreen(
          lessonTitle: widget.lessonTitle,
          lessonType: 'VOCABULARY',
          attempts: _attempts,
        ),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity:
              CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  int get _scorePercent {
    if (_attempts.isEmpty) return 0;
    final good = _attempts.where((a) => a.isCorrect == true).length;
    return ((good / _attempts.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_exercises.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              _topBar(),
              const Expanded(
                child: Center(
                  child: Text(
                    context.l10n.noFlashcards,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Card
                        Expanded(child: _buildFlipCard()),
                        const SizedBox(height: 20),
                        // Tap hint or SRS buttons
                        if (!_isFlipped)
                          _tapHint()
                        else
                          _srsButtons(),
                        const SizedBox(height: 24),
                      ],
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

  Widget _topBar() {
    final progress = _exercises.isNotEmpty
        ? (_current + 1) / _exercises.length
        : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textPrimary, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lessonTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    tween: Tween(begin: 0, end: progress),
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v,
                      backgroundColor: AppColors.surface,
                      color: AppColors.vocabulary,
                      minHeight: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_current + 1}/${_exercises.length}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipCard() {
    final word = _qData['word'] as String? ?? '';
    final phonetic = _qData['phonetic'] as String? ?? '';
    final partOfSpeech = _qData['partOfSpeech'] as String? ?? '';
    final translation = _qData['translation'] as String? ?? '';
    final definition = _qData['definition'] as String? ?? '';
    final example = _qData['example'] as String? ?? '';
    final topic = _exercises[_current]['title'] as String? ?? '';

    return AnimatedBuilder(
      animation: _flipAnim,
      builder: (_, __) {
        final isShowingBack = _flipAnim.value >= 0.5;
        final angle = _flipAnim.value * pi;

        return GestureDetector(
          onTap: _flip,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isShowingBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _cardBack(
                      translation: translation,
                      definition: definition,
                      example: example,
                      partOfSpeech: partOfSpeech,
                    ),
                  )
                : _cardFront(
                    word: word,
                    phonetic: phonetic,
                    partOfSpeech: partOfSpeech,
                    topic: topic,
                  ),
          ),
        );
      },
    );
  }

  Widget _cardFront({
    required String word,
    required String phonetic,
    required String partOfSpeech,
    required String topic,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAE4FF), Color(0xFFF3F0FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (topic.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.vocabulary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                topic.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.vocabulary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppGradients.primaryButton.createShader(bounds),
            child: Text(
              word,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (phonetic.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              phonetic,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (partOfSpeech.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                partOfSpeech,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          const Text(
            'Nhấn để lật thẻ',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardBack({
    required String translation,
    required String definition,
    required String example,
    required String partOfSpeech,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.vocabulary.withValues(alpha: 0.4)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (partOfSpeech.isNotEmpty)
            Text(
              partOfSpeech,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            translation,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (definition.isNotEmpty && definition != translation) ...[
            const SizedBox(height: 12),
            Text(
              definition,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
          if (example.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded,
                      color: AppColors.vocabulary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      example,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tapHint() {
    return const Text(
      '👆 Nhấn vào thẻ để xem nghĩa',
      style: TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _srsButtons() {
    const buttons = [
      (0, '😰 Quên', AppColors.error),
      (1, '😅 Khó', AppColors.warning),
      (2, '🙂 Ổn', AppColors.success),
      (3, '😄 Dễ', AppColors.vocabulary),
    ];

    return Column(
      children: [
        const Text(
          'Bạn nhớ từ này không?',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: buttons.map((btn) {
            final (rating, label, color) = btn;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: rating < 3 ? 8 : 0),
                child: TappableScale(
                  onTap: () => _rate(rating),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: color.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
