import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/learning_service.dart';

class AiReviewScreen extends StatefulWidget {
  const AiReviewScreen({super.key});

  @override
  State<AiReviewScreen> createState() => _AiReviewScreenState();
}

class _AiReviewScreenState extends State<AiReviewScreen> {
  List<Map<String, dynamic>> _mistakes = [];
  String? _aiReview;
  bool _loadingMistakes = true;
  bool _loadingAi = false;
  String? _aiError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await LearningService.getMistakes(size: 20);
    if (mounted) setState(() { _mistakes = list; _loadingMistakes = false; });
  }

  Future<void> _requestAiReview() async {
    setState(() { _loadingAi = true; _aiError = null; });
    final review = await LearningService.getAiReview();
    if (mounted) {
      setState(() {
        _loadingAi = false;
        if (review != null) {
          _aiReview = review;
        } else {
          _aiError = 'Không thể lấy nhận xét từ AI. Thử lại sau.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 180,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topBar(context),
                Expanded(
                  child: _loadingMistakes
                      ? const Center(child: CircularProgressIndicator())
                      : _mistakes.isEmpty
                          ? _emptyState()
                          : _content(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ôn tập câu sai',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Text('AI phân tích điểm yếu của bạn',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.success),
          SizedBox(height: 16),
          Text('Chưa có câu sai nào!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          SizedBox(height: 8),
          Text('Hãy làm thêm bài tập để tích lũy lịch sử.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Review section
          _aiReviewCard(),
          const SizedBox(height: 24),
          // Mistakes list
          Text('${_mistakes.length} câu sai gần nhất',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.3)),
          const SizedBox(height: 12),
          ..._mistakes.asMap().entries.map((e) => _mistakeCard(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _aiReviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.12),
                   AppColors.primaryLight.withValues(alpha: 0.06)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Review', style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text('Phân tích câu sai bằng AI', style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ]),
          const SizedBox(height: 16),
          if (_aiReview != null) ...[
            Text(_aiReview!,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary,
                    height: 1.6)),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _loadingAi ? null : _requestAiReview,
              child: Text('Phân tích lại',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.primary.withValues(alpha: _loadingAi ? 0.4 : 1.0))),
            ),
          ] else if (_aiError != null) ...[
            Text(_aiError!, style: const TextStyle(fontSize: 13, color: AppColors.error)),
            const SizedBox(height: 12),
            GradientButton(label: 'Thử lại', onTap: _requestAiReview, height: 44),
          ] else if (_loadingAi) ...[
            const Row(children: [
              SizedBox(width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 12),
              Text('Đang phân tích...', style: TextStyle(fontSize: 14,
                  color: AppColors.textSecondary)),
            ]),
          ] else ...[
            GradientButton(
              label: 'Nhận xét AI ngay',
              onTap: _requestAiReview,
              height: 46,
            ),
          ],
        ],
      ),
    );
  }

  Widget _mistakeCard(int index, Map<String, dynamic> m) {
    final title = m['exerciseTitle'] as String? ?? 'Câu hỏi';
    final lessonTitle = m['lessonTitle'] as String? ?? '';
    final type = m['exerciseType'] as String? ?? '';
    final qDataRaw = m['questionData'];
    String question = title;
    if (qDataRaw is String && qDataRaw.isNotEmpty) {
      try {
        final qMap = jsonDecode(qDataRaw) as Map<String, dynamic>;
        question = qMap['question'] as String? ?? title;
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text('${index + 1}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                    color: AppColors.error)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question, style: const TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                if (lessonTitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(lessonTitle, style: const TextStyle(fontSize: 12,
                      color: AppColors.textSecondary)),
                ],
                if (type.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(type.replaceAll('_', ' '),
                        style: const TextStyle(fontSize: 11,
                            color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
