import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:path_provider/path_provider.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/learning_service.dart';
import 'lesson_result_screen.dart';

// ─── Model: kết quả từng exercise trong session ────────────────────────────

class ExerciseAttempt {
  final Map<String, dynamic> exercise;
  dynamic userAnswer;
  bool? isCorrect;
  int pointsEarned;
  dynamic correctAnswer;
  String explanation;

  ExerciseAttempt({required this.exercise})
      : pointsEarned = 0,
        explanation = '';
}

// ─── Main Screen ───────────────────────────────────────────────────────────

class LessonPlayerScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String lessonTitle;
  final String lessonType;

  const LessonPlayerScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonType,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  List<Map<String, dynamic>> _exercises = [];
  bool _loading = true;
  int _current = 0;
  final List<ExerciseAttempt> _attempts = [];

  // Exercise state
  bool _answered = false;
  bool _submitting = false;
  int? _selectedOption;
  String _fillAnswer = '';
  DateTime? _exerciseStartTime;
  final DateTime _lessonStartTime = DateTime.now();

  // Pairs (DRAG_DROP matching) state
  List<String> _shuffledRights = [];
  Map<int, int> _leftToRight = {};   // leftIdx → shuffledRightIdx
  int? _activeLeft;
  int _pairsInitForIdx = -1;
  final _pairsContainerKey = GlobalKey();
  final List<GlobalKey> _leftKeys = [];
  final List<GlobalKey> _rightKeys = [];

  final _fillCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // Audio playback (LISTENING_CHOICE)
  final ja.AudioPlayer _audioPlayer = ja.AudioPlayer();
  bool _isPlaying = false;

  // Speaking recording
  final RecorderController _recorderCtrl = RecorderController();
  bool _isRecording = false;
  String? _uploadedAudioUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    _scrollCtrl.dispose();
    _audioPlayer.dispose();
    _recorderCtrl.dispose();
    super.dispose();
  }


  Future<void> _loadExercises() async {
    final list = await LearningService.getExercises(
        widget.courseId, widget.lessonId);
    if (!mounted) return;
    setState(() {
      _exercises = list;
      _loading = false;
      if (list.isNotEmpty) {
        _attempts
            .addAll(list.map((e) => ExerciseAttempt(exercise: e)));
        _exerciseStartTime = DateTime.now();
      }
    });
  }

  // ── Pairs helpers ──────────────────────────────────────────────────────────

  bool _isIdenticalOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _ensurePairsInitialized() {
    if (_pairsInitForIdx == _current) return;
    _pairsInitForIdx = _current;
    final pairs = (_qData['pairs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    _leftKeys.clear();
    _rightKeys.clear();
    if (pairs.isNotEmpty) {
      final rights = pairs.map((p) => p['right'] as String? ?? '').toList();
      // Shuffle và đảm bảo thứ tự khác bản gốc (tránh trùng khi ít phần tử)
      _shuffledRights = List.from(rights);
      if (_shuffledRights.length > 1) {
        int attempts = 0;
        do {
          _shuffledRights.shuffle();
          attempts++;
        } while (attempts < 10 &&
            _isIdenticalOrder(_shuffledRights, rights));
      }
      for (int i = 0; i < pairs.length; i++) {
        _leftKeys.add(GlobalKey());
        _rightKeys.add(GlobalKey());
      }
    } else {
      _shuffledRights = [];
    }
    _leftToRight = {};
    _activeLeft = null;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Map<String, dynamic> get _qData {
    final raw = _exercises[_current]['questionData'];
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String && raw.isNotEmpty) {
      try {
        final parsed = jsonDecode(raw);
        if (parsed is Map<String, dynamic>) return parsed;
      } catch (_) {}
    }
    return {};
  }

  String get _exType =>
      (_exercises[_current]['type'] as String? ?? 'MULTIPLE_CHOICE')
          .toUpperCase();

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submitAnswer() async {
    if (_submitting) return;

    final attempt = _attempts[_current];
    dynamic answer;

    // Pairs phải check trước switch vì pairs có thể ở bất kỳ type nào
    if (_qData.containsKey('pairs')) {
      final pairs = (_qData['pairs'] as List).cast<Map<String, dynamic>>();
      if (_leftToRight.length < pairs.length) return;
      answer = List.generate(pairs.length, (i) {
        final si = _leftToRight[i] ?? 0;
        return si < _shuffledRights.length ? _shuffledRights[si] : '';
      }).join('|');
      attempt.userAnswer = answer;
    } else {
      switch (_exType) {
        case 'MULTIPLE_CHOICE':
        case 'LISTENING_CHOICE':
          if (_selectedOption == null) return;
          answer = _selectedOption.toString();
          attempt.userAnswer = _selectedOption;
        case 'FILL_IN_BLANK':
          if (_fillAnswer.trim().isEmpty) return;
          answer = _fillAnswer.trim();
          attempt.userAnswer = _fillAnswer.trim();
        case 'TRANSLATION':
          if (_fillAnswer.trim().isEmpty) return;
          answer = _fillAnswer.trim();
          attempt.userAnswer = _fillAnswer.trim();
        case 'SPEAKING':
          answer = _uploadedAudioUrl ?? 'speaking_submitted';
          attempt.userAnswer = _uploadedAudioUrl;
        default:
          if (_selectedOption != null) {
            answer = _selectedOption.toString();
            attempt.userAnswer = _selectedOption;
          } else {
            answer = '0';
          }
      }
    }

    setState(() => _submitting = true);

    final now = DateTime.now();
    final startMs = _exerciseStartTime?.millisecondsSinceEpoch ??
        now.millisecondsSinceEpoch;

    final result = await LearningService.submitExercise(
      courseId: widget.courseId,
      lessonId: widget.lessonId,
      exerciseId: attempt.exercise['id'] as String,
      answer: answer,
      clientStartMs: startMs,
      clientSubmitMs: now.millisecondsSinceEpoch,
      audioUrl: _exType == 'SPEAKING' ? _uploadedAudioUrl : null,
    );

    if (!mounted) return;

    if (result != null) {
      attempt.isCorrect = result['correct'] as bool? ?? false;
      attempt.pointsEarned = result['pointsEarned'] as int? ?? 0;
      attempt.correctAnswer = result['correctAnswer'];
      attempt.explanation = result['explanation'] as String? ?? '';
    } else {
      // Offline: grade locally for MCQ
      if (_exType == 'MULTIPLE_CHOICE' || _exType == 'LISTENING_CHOICE') {
        final correctIdx = _resolveCorrectIndex(_qData);
        attempt.isCorrect = correctIdx >= 0 && _selectedOption == correctIdx;
        attempt.correctAnswer = {'selectedIndex': correctIdx};
        attempt.explanation =
            _qData['explanation'] as String? ?? '';
        attempt.pointsEarned =
            attempt.isCorrect! ? (_exercises[_current]['points'] as int? ?? 10) : 0;
      } else {
        attempt.isCorrect = _exType == 'SPEAKING';
        attempt.correctAnswer = answer;
        attempt.explanation =
            _qData['explanation'] as String? ?? '';
        attempt.pointsEarned = attempt.isCorrect! ? (_exercises[_current]['points'] as int? ?? 10) : 0;
      }
    }

    setState(() {
      _submitting = false;
      _answered = true;
    });
  }

  void _next() {
    _audioPlayer.stop();
    if (_current < _exercises.length - 1) {
      setState(() {
        _current++;
        _answered = false;
        _selectedOption = null;
        _fillAnswer = '';
        _fillCtrl.clear();
        _exerciseStartTime = DateTime.now();
        // reset pairs
        _pairsInitForIdx = -1;
        _leftToRight = {};
        _activeLeft = null;
        _shuffledRights = [];
        // reset speaking / listening
        _uploadedAudioUrl = null;
        _isRecording = false;
        _isUploading = false;
        _isPlaying = false;
      });
      _scrollCtrl.animateTo(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
    } else {
      _finishLesson();
    }
  }

  void _finishLesson() {
    // Log study session
    LearningService.logStudy(
      lessonId: widget.lessonId,
      durationSeconds:
          DateTime.now().difference(_lessonStartTime).inSeconds,
      activityType: 'EXERCISE_SUBMIT',
      score: _totalScore,
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LessonResultScreen(
          lessonTitle: widget.lessonTitle,
          lessonType: widget.lessonType,
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

  int get _totalScore {
    if (_attempts.isEmpty) return 0;
    final correct = _attempts.where((a) => a.isCorrect == true).length;
    return ((correct / _attempts.length) * 100).round();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_exercises.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const Expanded(
                child: Center(
                  child: Text(
                    'Bài học này chưa có bài tập',
                    style: TextStyle(
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
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildExerciseBody(),
                    const SizedBox(height: 24),
                    if (_answered) _buildFeedback(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    final progress = (_current + 1) / _exercises.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textPrimary, size: 22),
                onPressed: () => _showQuitDialog(),
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
                          color: AppColors.primary,
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
        ],
      ),
    );
  }

  // ── Exercise body ──────────────────────────────────────────────────────────

  Widget _buildExerciseBody() {
    // Pairs data có thể có ở DRAG_DROP hoặc type khác
    if (_qData.containsKey('pairs')) return _buildPairs();
    switch (_exType) {
      case 'MULTIPLE_CHOICE':
      case 'LISTENING_CHOICE':
        return _buildMCQ();
      case 'FILL_IN_BLANK':
        return _buildFillInBlank();
      case 'SPEAKING':
        return _buildSpeaking();
      case 'TRANSLATION':
        return _buildTranslation();
      case 'DRAG_DROP':
        return _buildMCQ(); // word-order fallback
      default:
        return _buildMCQ();
    }
  }

  // ── Multiple Choice ────────────────────────────────────────────────────────

  /// Tìm correctIndex từ "correctIndex" (int) hoặc "correct" (string text)
  int _resolveCorrectIndex(Map<String, dynamic> qData) {
    final ci = qData['correctIndex'];
    if (ci is int) return ci;
    // fallback: tìm theo text
    final correctText = qData['correct'] as String? ?? '';
    final options = (qData['options'] as List?)?.cast<String>() ?? [];
    if (correctText.isNotEmpty) {
      final idx = options.indexWhere(
          (o) => o.trim().toLowerCase() == correctText.trim().toLowerCase());
      if (idx >= 0) return idx;
    }
    // fallback: backend trả correctAnswer sau submit
    if (_answered) {
      final ca = _attempts[_current].correctAnswer;
      final caText = ca is String ? ca : ca?.toString() ?? '';
      final idx = options.indexWhere(
          (o) => o.trim().toLowerCase() == caText.trim().toLowerCase());
      if (idx >= 0) return idx;
    }
    return -1;
  }

  Future<void> _playListeningAudio() async {
    final audioUrl = _exercises[_current]['audioUrl'] as String?;
    if (audioUrl == null || audioUrl.isEmpty) return;

    if (_isPlaying) {
      await _audioPlayer.stop();
      if (mounted) setState(() => _isPlaying = false);
      return;
    }

    try {
      setState(() => _isPlaying = true);
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      _audioPlayer.playerStateStream.listen((state) {
        if (!mounted) return;
        if (!state.playing) setState(() => _isPlaying = false);
      });
    } catch (e) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Widget _buildMCQ() {
    final question = _qData['question'] as String? ?? '';
    final options = (_qData['options'] as List?)?.cast<String>() ?? [];
    final correctIndex = _resolveCorrectIndex(_qData);
    final audioUrl = _exercises[_current]['audioUrl'] as String?;
    final isListening = _exType == 'LISTENING_CHOICE';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exTypeBadge(),
        const SizedBox(height: 16),
        if (question.isNotEmpty) ...[
          Text(
            question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (isListening && audioUrl != null && audioUrl.isNotEmpty) ...[
          Center(
            child: Column(
              children: [
                TappableScale(
                  onTap: _playListeningAudio,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: _isPlaying ? null : AppGradients.primaryIcon,
                      color: _isPlaying ? AppColors.primary : null,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.primaryGlowSoft,
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.stop_rounded
                          : Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isPlaying ? 'Đang phát...' : 'Nhấn để nghe',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ] else
          const SizedBox(height: 8),
        ...List.generate(options.length, (i) {
          final label = String.fromCharCode(65 + i);
          Color bg = AppColors.surface;
          Color borderColor = AppColors.border;
          Color textColor = AppColors.textPrimary;
          Color circleColor = AppColors.inputBg;
          Color circleFg = AppColors.textSecondary;

          if (_answered) {
            // Show correct answer
            if (i == correctIndex) {
              bg = AppColors.success.withValues(alpha: 0.12);
              borderColor = AppColors.success;
              textColor = AppColors.success;
              circleColor = AppColors.success;
              circleFg = Colors.white;
            } else if (i == _selectedOption && i != correctIndex) {
              bg = AppColors.error.withValues(alpha: 0.12);
              borderColor = AppColors.error;
              textColor = AppColors.error;
              circleColor = AppColors.error;
              circleFg = Colors.white;
            }
          } else if (_selectedOption == i) {
            bg = AppColors.primary.withValues(alpha: 0.12);
            borderColor = AppColors.primary;
            textColor = AppColors.primaryLight;
            circleColor = AppColors.primary;
            circleFg = Colors.white;
          }

          return TappableScale(
            onTap: _answered ? null : () {
              setState(() => _selectedOption = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: circleFg,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      options[i],
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
        }),
      ],
    );
  }

  // ── Fill in the Blank ──────────────────────────────────────────────────────

  Widget _buildFillInBlank() {
    // support cả "sentence" lẫn "question" field
    final sentence = (_qData['sentence'] as String?)?.isNotEmpty == true
        ? _qData['sentence'] as String
        : _qData['question'] as String? ?? '';
    final options = (_qData['options'] as List?)?.cast<String>() ?? [];
    final hint = _qData['hint'] as String? ?? '';

    // Show sentence with underline for blank
    final parts = sentence.split('___');
    final hasBlanks = parts.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exTypeBadge(),
        const SizedBox(height: 16),
        // Sentence display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: hasBlanks
              ? Wrap(
                  children: [
                    for (int i = 0; i < parts.length; i++) ...[
                      Text(
                        parts[i],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (i < parts.length - 1)
                        Container(
                          constraints:
                              const BoxConstraints(minWidth: 80),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _answered
                                ? (_attempts[_current].isCorrect == true
                                    ? AppColors.success
                                        .withValues(alpha: 0.2)
                                    : AppColors.error
                                        .withValues(alpha: 0.2))
                                : AppColors.primary
                                    .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _answered
                                  ? (_attempts[_current].isCorrect ==
                                          true
                                      ? AppColors.success
                                      : AppColors.error)
                                  : AppColors.primary
                                      .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            _fillAnswer.isNotEmpty
                                ? _fillAnswer
                                : '___',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _answered
                                  ? (_attempts[_current].isCorrect ==
                                          true
                                      ? AppColors.success
                                      : AppColors.error)
                                  : AppColors.primaryLight,
                            ),
                          ),
                        ),
                    ],
                  ],
                )
              : Text(
                  sentence,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
        ),
        if (hint.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '💡 $hint',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 20),

        // Options OR text input
        if (options.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((opt) {
              final isSelected = _fillAnswer == opt;
              Color bg = AppColors.surface;
              Color borderColor = AppColors.border;
              Color textColor = AppColors.textPrimary;

              if (_answered) {
                final correctAns = _attempts[_current].correctAnswer;
                // backend trả correctAnswer là String trực tiếp
                final correctText = correctAns is String
                    ? correctAns
                    : (correctAns is Map ? correctAns['answer'] as String? ?? '' : '');
                if (opt == correctText) {
                  bg = AppColors.success.withValues(alpha: 0.12);
                  borderColor = AppColors.success;
                  textColor = AppColors.success;
                } else if (isSelected && opt != correctText) {
                  bg = AppColors.error.withValues(alpha: 0.12);
                  borderColor = AppColors.error;
                  textColor = AppColors.error;
                }
              } else if (isSelected) {
                bg = AppColors.primary.withValues(alpha: 0.15);
                borderColor = AppColors.primary;
                textColor = AppColors.primaryLight;
              }

              return TappableScale(
                onTap: _answered
                    ? null
                    : () => setState(() => _fillAnswer = opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: borderColor,
                        width: isSelected ? 1.5 : 1),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        else
          TextFormField(
            controller: _fillCtrl,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 16),
            enabled: !_answered,
            onChanged: (v) => setState(() => _fillAnswer = v),
            decoration: InputDecoration(
              hintText: 'Nhập câu trả lời...',
              hintStyle: const TextStyle(
                  color: AppColors.textHint, fontSize: 15),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  // ── Speaking ───────────────────────────────────────────────────────────────

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      final path = await _recorderCtrl.stop();
      setState(() {
        _isRecording = false;
        _isUploading = true;
      });

      if (path != null) {
        final url = await LearningService.uploadSpeakingRecord(
          audioFile: File(path),
          exerciseId: _exercises[_current]['id'] as String,
          title: _exercises[_current]['title'] as String? ?? 'Speaking Record',
        );
        if (mounted) {
          setState(() {
            _uploadedAudioUrl = url;
            _isUploading = false;
          });
          if (url == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upload thất bại, thử lại')),
            );
          }
        }
      } else {
        if (mounted) setState(() => _isUploading = false);
      }
    } else {
      // Start recording
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/speaking_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorderCtrl.record(path: filePath);
      setState(() {
        _isRecording = true;
        _uploadedAudioUrl = null;
      });
    }
  }

  Widget _buildSpeaking() {
    // Backend stores SPEAKING questionData as {"targetText": "..."} per ExerciseService.grade()
    final targetText = (_qData['targetText'] as String?)?.trim().isNotEmpty == true
        ? _qData['targetText'] as String
        : (_qData['text'] as String?)?.trim().isNotEmpty == true
            ? _qData['text'] as String
            : (_qData['question'] as String?)?.trim().isNotEmpty == true
                ? _qData['question'] as String
                : (_qData['sentence'] as String?) ?? '';
    final translation = _qData['translation'] as String? ?? '';
    final exerciseTitle = _exercises[_current]['title'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exTypeBadge(),
        const SizedBox(height: 16),
        const Text(
          'Đọc to câu sau:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (exerciseTitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            exerciseTitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: targetText.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      targetText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    if (translation.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        translation,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                )
              : const Text(
                  'Không tìm thấy nội dung bài tập.\nVui lòng liên hệ giáo viên.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
        ),
        const SizedBox(height: 28),

        // Waveform (visible while recording)
        if (_isRecording)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AudioWaveforms(
              recorderController: _recorderCtrl,
              size: Size(MediaQuery.of(context).size.width - 48, 56),
              waveStyle: const WaveStyle(
                waveColor: AppColors.primary,
                showDurationLabel: true,
                spacing: 8.0,
                showBottom: true,
                extendWaveform: true,
                showMiddleLine: false,
              ),
            ),
          ),
        if (_isRecording) const SizedBox(height: 16),

        // Mic button / upload spinner
        Center(
          child: _isUploading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 10),
                    Text(
                      'Đang tải lên...',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TappableScale(
                      onTap: _answered ? null : _toggleRecording,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? const Color(0xFFE53935)
                              : _uploadedAudioUrl != null
                                  ? AppColors.success
                                  : null,
                          gradient: _isRecording || _uploadedAudioUrl != null
                              ? null
                              : AppGradients.primaryIcon,
                          shape: BoxShape.circle,
                          boxShadow: _isRecording
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFE53935)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                              : AppShadows.primaryGlowSoft,
                        ),
                        child: Icon(
                          _isRecording
                              ? Icons.stop_rounded
                              : _uploadedAudioUrl != null
                                  ? Icons.check_rounded
                                  : Icons.mic_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isRecording
                          ? 'Nhấn để dừng'
                          : _uploadedAudioUrl != null
                              ? 'Đã ghi âm ✓'
                              : 'Nhấn để ghi âm',
                      style: TextStyle(
                        fontSize: 13,
                        color: _uploadedAudioUrl != null
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: _uploadedAudioUrl != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (_uploadedAudioUrl != null && !_answered) ...[
                      const SizedBox(height: 12),
                      TextButton.icon(
                        icon: const Icon(Icons.refresh_rounded,
                            size: 16, color: AppColors.primaryLight),
                        label: const Text(
                          'Ghi âm lại',
                          style: TextStyle(
                              color: AppColors.primaryLight, fontSize: 13),
                        ),
                        onPressed: _toggleRecording,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  // ── Translation ────────────────────────────────────────────────────────────

  Widget _buildTranslation() {
    final sourceText = _qData['sourceText'] as String? ?? '';
    final hint = _qData['hint'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exTypeBadge(),
        const SizedBox(height: 16),
        const Text(
          'Dịch câu sau:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            sourceText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
        if (hint.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '💡 $hint',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 20),
        TextFormField(
          controller: _fillCtrl,
          style:
              const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          enabled: !_answered,
          maxLines: 3,
          onChanged: (v) => setState(() => _fillAnswer = v),
          decoration: InputDecoration(
            hintText: 'Nhập bản dịch...',
            hintStyle:
                const TextStyle(color: AppColors.textHint, fontSize: 15),
            filled: true,
            fillColor: AppColors.inputBg,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Pairs (Matching) ───────────────────────────────────────────────────────

  static const _pairColors = [
    Color(0xFF00B4D8),
    Color(0xFF00C896),
    Color(0xFFFF9F43),
    Color(0xFF5E81F4),
    Color(0xFFFF6B6B),
  ];

  Widget _buildPairs() {
    _ensurePairsInitialized();
    final pairs = (_qData['pairs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (pairs.isEmpty) return const SizedBox();

    final question = _qData['question'] as String? ?? 'Nối các cặp phù hợp:';
    final leftItems = pairs.map((p) => p['left'] as String? ?? '').toList();

    // reverse map: shuffledRightIdx → leftIdx
    final rightToLeft = <int, int>{};
    _leftToRight.forEach((li, si) => rightToLeft[si] = li);

    Color pairColor(int leftIdx) => _pairColors[leftIdx % _pairColors.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Nối từ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          question,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        if (_activeLeft != null && !_answered) ...[
          const SizedBox(height: 8),
          Text(
            'Chọn vế phải để nối với "${leftItems[_activeLeft!]}"',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Stack(
          key: _pairsContainerKey,
          children: [
            // Line painter (behind items, ignores pointer)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PairsLinePainter(
                    leftKeys: List.from(_leftKeys),
                    rightKeys: List.from(_rightKeys),
                    leftToRight: Map.from(_leftToRight),
                    colors: _pairColors,
                    containerKey: _pairsContainerKey,
                  ),
                ),
              ),
            ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              child: Column(
                children: List.generate(leftItems.length, (i) {
                  final isActive = _activeLeft == i;
                  final matchedSi = _leftToRight[i];
                  final isMatched = matchedSi != null;
                  final color = isMatched ? pairColor(i) : null;

                  return TappableScale(
                    key: i < _leftKeys.length ? _leftKeys[i] : null,
                    onTap: _answered
                        ? null
                        : () => setState(() {
                              if (isActive) {
                                _activeLeft = null;
                              } else if (isMatched) {
                                _leftToRight.remove(i);
                                _activeLeft = i;
                              } else {
                                _activeLeft = i;
                              }
                            }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : isMatched
                                ? color!.withValues(alpha: 0.12)
                                : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primary
                              : isMatched
                                  ? color!
                                  : AppColors.border,
                          width: isActive || isMatched ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        leftItems[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? AppColors.primaryLight
                              : isMatched
                                  ? color
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 12),
            // Right column (shuffled)
            Expanded(
              child: Column(
                children: List.generate(_shuffledRights.length, (si) {
                  final matchedLi = rightToLeft[si];
                  final isMatched = matchedLi != null;
                  final color = isMatched ? pairColor(matchedLi) : null;

                  return TappableScale(
                    key: si < _rightKeys.length ? _rightKeys[si] : null,
                    onTap: _answered
                        ? null
                        : () => setState(() {
                              if (_activeLeft != null) {
                                if (isMatched) {
                                  _leftToRight.remove(matchedLi);
                                }
                                _leftToRight[_activeLeft!] = si;
                                _activeLeft = null;
                              } else if (isMatched) {
                                _leftToRight.remove(matchedLi);
                              }
                            }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: isMatched
                            ? color!.withValues(alpha: 0.12)
                            : _activeLeft != null
                                ? AppColors.primary.withValues(alpha: 0.05)
                                : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isMatched
                              ? color!
                              : _activeLeft != null
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.border,
                          width: isMatched ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        _shuffledRights[si],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isMatched
                              ? color
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),      // end Row
          ],
        ),      // end Stack
      ],
    );
  }

  // ── Feedback ───────────────────────────────────────────────────────────────

  Widget _buildFeedback() {
    final attempt = _attempts[_current];
    final isCorrect = attempt.isCorrect ?? false;
    final explanation = attempt.explanation;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isCorrect ? AppColors.success : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Chính xác! 🎉' : 'Chưa đúng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
                if (explanation.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    explanation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                if (attempt.pointsEarned == 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+0 XP',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error.withValues(alpha: 0.7),
                    ),
                  ),
                ],
                if (attempt.pointsEarned > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+${attempt.pointsEarned} XP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    bool canSubmit = false;
    // Pairs check trước switch — pairs có thể ở bất kỳ exercise type nào
    if (_qData.containsKey('pairs')) {
      final pairs = (_qData['pairs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      canSubmit = _leftToRight.length >= pairs.length;
    } else {
      switch (_exType) {
        case 'MULTIPLE_CHOICE':
        case 'LISTENING_CHOICE':
          canSubmit = _selectedOption != null;
        case 'FILL_IN_BLANK':
        case 'TRANSLATION':
          canSubmit = _fillAnswer.trim().isNotEmpty;
        case 'SPEAKING':
          canSubmit = _uploadedAudioUrl != null;
        default:
          canSubmit = _selectedOption != null;
      }
    }

    if (_exType == 'SPEAKING') {
      if (_answered) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: GradientButton(
              label: _current < _exercises.length - 1
                  ? 'Câu tiếp theo'
                  : 'Xem kết quả',
              onTap: _next,
            ),
          ),
        );
      }
      // Show submit only after recording uploaded
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: GradientButton(
            label: 'Nộp bài',
            enabled: _uploadedAudioUrl != null && !_isUploading,
            isLoading: _submitting,
            onTap: _submitAnswer,
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: _answered
            ? GradientButton(
                label: _current < _exercises.length - 1
                    ? 'Câu tiếp theo'
                    : 'Xem kết quả',
                onTap: _next,
              )
            : GradientButton(
                label: 'Kiểm tra',
                enabled: canSubmit,
                isLoading: _submitting,
                onTap: _submitAnswer,
              ),
      ),
    );
  }

  // ── Exercise type badge ────────────────────────────────────────────────────

  Widget _exTypeBadge() {
    final typeLabels = {
      'MULTIPLE_CHOICE': 'Trắc nghiệm',
      'FILL_IN_BLANK': 'Điền từ',
      'LISTENING_CHOICE': 'Nghe',
      'SPEAKING': 'Nói',
      'TRANSLATION': 'Dịch',
      'MATCHING': 'Nối từ',
      'DRAG_DROP': 'Sắp xếp',
    };
    final label = typeLabels[_exType] ?? _exType;
    final title = _exercises[_current]['title'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
              letterSpacing: 0.5,
            ),
          ),
        ),
        if (title.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  // ── Quit dialog ────────────────────────────────────────────────────────────

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Thoát bài học?',
          style:
              TextStyle(color: AppColors.textPrimary, fontSize: 17),
        ),
        content: const Text(
          'Tiến trình hiện tại sẽ không được lưu.',
          style:
              TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ở lại',
                style: TextStyle(color: AppColors.primaryLight)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Thoát',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ─── Connecting line painter for pairs exercise ────────────────────────────

class _PairsLinePainter extends CustomPainter {
  final List<GlobalKey> leftKeys;
  final List<GlobalKey> rightKeys;
  final Map<int, int> leftToRight;
  final List<Color> colors;
  final GlobalKey containerKey;

  _PairsLinePainter({
    required this.leftKeys,
    required this.rightKeys,
    required this.leftToRight,
    required this.colors,
    required this.containerKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final containerBox =
        containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerBox == null) return;

    for (final entry in leftToRight.entries) {
      final li = entry.key;
      final si = entry.value;
      if (li >= leftKeys.length || si >= rightKeys.length) continue;

      final leftBox =
          leftKeys[li].currentContext?.findRenderObject() as RenderBox?;
      final rightBox =
          rightKeys[si].currentContext?.findRenderObject() as RenderBox?;
      if (leftBox == null || rightBox == null) continue;

      // Center-right of left item
      final lp = leftBox.localToGlobal(
          Offset(leftBox.size.width, leftBox.size.height / 2),
          ancestor: containerBox);
      // Center-left of right item
      final rp = rightBox.localToGlobal(
          Offset(0, rightBox.size.height / 2),
          ancestor: containerBox);

      final color = colors[li % colors.length];
      final paint = Paint()
        ..color = color.withValues(alpha: 0.85)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(lp.dx, lp.dy);
      final mx = (lp.dx + rp.dx) / 2;
      path.cubicTo(mx, lp.dy, mx, rp.dy, rp.dx, rp.dy);
      canvas.drawPath(path, paint);

      // Dots at endpoints
      canvas.drawCircle(lp, 4, Paint()..color = color);
      canvas.drawCircle(rp, 4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_PairsLinePainter old) => true;
}
