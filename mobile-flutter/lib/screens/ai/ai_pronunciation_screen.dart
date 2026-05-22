import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/theme.dart';
import '../../l10n/l10n_ext.dart';
import '../../services/ai_service.dart';
import '../../services/tts_service.dart';

class AiPronunciationScreen extends StatefulWidget {
  const AiPronunciationScreen({super.key});

  @override
  State<AiPronunciationScreen> createState() => _AiPronunciationScreenState();
}

class _AiPronunciationScreenState extends State<AiPronunciationScreen> {
  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();
  final _recorderCtrl = RecorderController();

  bool _isRecording = false;
  bool _isUploading = false;
  bool _isAnalyzing = false;
  String? _uploadedAudioUrl;
  PronunciationResult? _result;
  String? _error;

  static const _examples = [
    'She sells seashells by the seashore.',
    'The quick brown fox jumps over the lazy dog.',
    'How much wood would a woodchuck chuck?',
    'I would like a cup of coffee, please.',
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _focusNode.dispose();
    _recorderCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorderCtrl.stop();
      setState(() {
        _isRecording = false;
        _isUploading = true;
        _result = null;
        _error = null;
      });
      if (path != null) {
        final url = await AiService.uploadPronunciationAudio(File(path));
        if (mounted) {
          setState(() {
            _uploadedAudioUrl = url;
            _isUploading = false;
          });
          if (url == null) {
            setState(() => _error = 'Upload thất bại. Vui lòng thử lại.');
          }
        }
      } else {
        if (mounted) setState(() => _isUploading = false);
      }
    } else {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/pronunciation_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorderCtrl.record(path: filePath);
      setState(() {
        _isRecording = true;
        _uploadedAudioUrl = null;
        _result = null;
        _error = null;
      });
    }
  }

  Future<void> _analyze() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _uploadedAudioUrl == null) return;
    _focusNode.unfocus();

    setState(() {
      _isAnalyzing = true;
      _result = null;
      _error = null;
    });

    final result = await AiService.analyzePronunciation(
      targetText: text,
      audioUrl: _uploadedAudioUrl!,
    );

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        if (result != null) {
          _result = result;
        } else {
          _error = 'Không thể phân tích phát âm. Vui lòng thử lại.';
        }
      });
    }
  }

  void _reset() {
    setState(() {
      _uploadedAudioUrl = null;
      _result = null;
      _error = null;
      _isRecording = false;
      _isUploading = false;
      _isAnalyzing = false;
    });
  }

  Color _scoreColor(int score) {
    if (score >= 85) return const Color(0xFF4CAF50);
    if (score >= 65) return const Color(0xFFFFB300);
    return const Color(0xFFFF5252);
  }

  String _scoreLabel(int score) {
    if (score >= 90) return 'Xuất sắc! 🎉';
    if (score >= 75) return 'Tốt lắm! 👍';
    if (score >= 60) return 'Khá ổn 💪';
    return 'Cần luyện thêm 📚';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2540),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.mic_rounded,
                  color: Color(0xFFFF6B35), size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Phát Âm',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text('Luyện phát âm chuẩn',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInputSection(),
            const SizedBox(height: 16),
            _buildExamples(),
            const SizedBox(height: 16),
            _buildRecordSection(),
            if (_isAnalyzing) ...[
              const SizedBox(height: 20),
              _buildAnalyzingCard(),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              _buildErrorCard(),
            ],
            if (_result != null) ...[
              const SizedBox(height: 16),
              _buildResultCard(_result!),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields_rounded,
                  color: const Color(0xFFFF6B35), size: 16),
              const SizedBox(width: 6),
              Text('Câu cần luyện',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _inputCtrl,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Nhập từ hoặc câu muốn luyện phát âm...',
              hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 14),
              border: InputBorder.none,
              isDense: true,
            ),
            onChanged: (_) => setState(() {
              _uploadedAudioUrl = null;
              _result = null;
              _error = null;
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TTS listen button
              GestureDetector(
                onTap: () {
                  final text = _inputCtrl.text.trim();
                  if (text.isNotEmpty) TtsService.instance.speak(text);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E8EEA).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF3E8EEA).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.volume_up_rounded,
                          color: Color(0xFF3E8EEA), size: 16),
                      const SizedBox(width: 5),
                      Text('Nghe mẫu',
                          style: const TextStyle(
                              color: Color(0xFF3E8EEA),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thử câu mẫu:',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _examples
              .map((e) => GestureDetector(
                    onTap: () {
                      _inputCtrl.text = e;
                      _reset();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6)),
                      ),
                      child: Text(e,
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11)),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecordSection() {
    final text = _inputCtrl.text.trim();
    final canRecord = text.isNotEmpty;
    final hasAudio = _uploadedAudioUrl != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRecording
              ? const Color(0xFFFF5252).withValues(alpha: 0.6)
              : hasAudio
                  ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
                  : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          // Status text
          Text(
            _isUploading
                ? 'Đang xử lý...'
                : hasAudio
                    ? '✓ Đã ghi âm xong'
                    : _isRecording
                        ? 'Đang ghi âm...'
                        : 'Nhấn micro để ghi âm',
            style: TextStyle(
              color: _isRecording
                  ? const Color(0xFFFF5252)
                  : hasAudio
                      ? const Color(0xFF4CAF50)
                      : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // Waveform
          if (_isRecording)
            AudioWaveforms(
              recorderController: _recorderCtrl,
              size: const Size(double.infinity, 48),
              waveStyle: WaveStyle(
                waveColor: const Color(0xFFFF6B35),
                extendWaveform: true,
                showMiddleLine: false,
              ),
            )
          else
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  hasAudio ? Icons.multitrack_audio_rounded : Icons.graphic_eq_rounded,
                  color: hasAudio
                      ? const Color(0xFF4CAF50)
                      : AppColors.textSecondary.withValues(alpha: 0.4),
                  size: 28,
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Record button
              GestureDetector(
                onTap: (canRecord && !_isUploading && !_isAnalyzing)
                    ? _toggleRecording
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording
                        ? const Color(0xFFFF5252)
                        : canRecord
                            ? const Color(0xFFFF6B35)
                            : AppColors.border,
                    boxShadow: _isRecording
                        ? [
                            BoxShadow(
                              color:
                                  const Color(0xFFFF5252).withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 4,
                            )
                          ]
                        : [],
                  ),
                  child: _isUploading
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Icon(
                          _isRecording
                              ? Icons.stop_rounded
                              : Icons.mic_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                ),
              ),

              if (hasAudio && !_isAnalyzing) ...[
                const SizedBox(width: 20),
                // Analyze button
                GestureDetector(
                  onTap: _analyze,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryIcon,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.analytics_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Phân tích',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (!canRecord) ...[
            const SizedBox(height: 10),
            Text('Nhập câu muốn luyện trước',
                style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalyzingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: const Color(0xFFFF6B35),
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI đang phân tích...',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text('Nhận diện giọng nói & đánh giá phát âm',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5252).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFFF5252).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFFF5252), size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(_error!,
                  style: const TextStyle(
                      color: Color(0xFFFF5252), fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildResultCard(PronunciationResult result) {
    final scoreColor = _scoreColor(result.score);

    return Column(
      children: [
        // Score card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scoreColor.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kết quả phát âm',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  if (result.cefrLevel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(result.cefrLevel,
                          style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Score circle
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: result.score / 100,
                      strokeWidth: 8,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(scoreColor),
                    ),
                  ),
                  Column(
                    children: [
                      Text('${result.score}',
                          style: TextStyle(
                              color: scoreColor,
                              fontSize: 36,
                              fontWeight: FontWeight.w800)),
                      Text('/100',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(_scoreLabel(result.score),
                  style: TextStyle(
                      color: scoreColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),

        if (result.feedback.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: const Color(0xFF3E8EEA),
            title: 'Nhận xét',
            content: result.feedback,
          ),
        ],

        if (result.phonemeErrors.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFFFB300),
            title: 'Lỗi phát âm',
            content: result.phonemeErrors,
          ),
        ],

        if (result.improvement.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.tips_and_updates_rounded,
            iconColor: const Color(0xFF4CAF50),
            title: 'Cách cải thiện',
            content: result.improvement,
          ),
        ],

        const SizedBox(height: 16),
        // Try again button
        GestureDetector(
          onTap: _reset,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded,
                    color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 8),
                Text('Thử lại',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
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
              Icon(icon, color: iconColor, size: 15),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(color: Colors.white, fontSize: 14,
                  height: 1.5)),
        ],
      ),
    );
  }
}
