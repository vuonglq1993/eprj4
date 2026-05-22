import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '../../services/learning_service.dart';
import '../home/home_placeholder.dart';

class Step6Recommended extends StatefulWidget {
  final List<Map<String, dynamic>> recommendedPaths;
  const Step6Recommended({super.key, required this.recommendedPaths});

  @override
  State<Step6Recommended> createState() => _Step6RecommendedState();
}

class _Step6RecommendedState extends State<Step6Recommended> {
  final Map<String, bool> _enrolled = {};
  final Map<String, bool> _enrolling = {};

  @override
  void initState() {
    super.initState();
    // Backend auto-enrolls during submitOnboarding — mark all as enrolled
    for (final p in widget.recommendedPaths) {
      final id = p['id'] as String? ?? '';
      if (id.isNotEmpty) _enrolled[id] = true;
    }
  }

  Future<void> _toggle(String pathId) async {
    if (_enrolling[pathId] == true) return;
    // Already enrolled → unenroll (just toggle UI, no API needed)
    if (_enrolled[pathId] == true) {
      setState(() => _enrolled[pathId] = false);
      return;
    }
    setState(() => _enrolling[pathId] = true);
    // enrollLearningPath returns false on 409 (already enrolled) too — treat both as success
    await LearningService.enrollLearningPath(pathId);
    if (mounted) setState(() { _enrolling[pathId] = false; _enrolled[pathId] = true; });
  }

  void _start() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePlaceholder()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final anyEnrolled = _enrolled.values.any((v) => v);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text('🎉', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(context.l10n.recommendedForYou,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text('Chọn lộ trình bạn muốn học và nhấn Bắt đầu',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: widget.recommendedPaths.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final p = widget.recommendedPaths[i];
                  final id = p['id'] as String? ?? '';
                  final enrolled = _enrolled[id] == true;
                  final enrolling = _enrolling[id] == true;
                  return _PathCard(
                    data: p,
                    enrolled: enrolled,
                    enrolling: enrolling,
                    onTap: id.isNotEmpty ? () => _toggle(id) : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            GradientButton(
              label: anyEnrolled ? 'Bắt đầu học' : 'Bắt đầu học',
              onTap: _start,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TappableScale(
                onTap: _start,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(context.l10n.exploreLater,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool enrolled;
  final bool enrolling;
  final VoidCallback? onTap;

  const _PathCard({
    required this.data,
    required this.enrolled,
    required this.enrolling,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title       = data['title']        as String? ?? '';
    final description = data['description']  as String? ?? '';
    final totalSteps  = data['totalSteps']   as int?    ?? 0;
    final level       = data['targetLevel']  as String? ?? '';
    final langFlag    = data['languageFlag'] as String? ?? '';

    return TappableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enrolled
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: enrolled
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.border,
            width: enrolled ? 1.5 : 1,
          ),
          boxShadow: enrolled ? AppShadows.subtle : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (langFlag.isNotEmpty) ...[
                        Text(langFlag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: enrolled
                                    ? AppColors.primary
                                    : AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (level.isNotEmpty) ...[
                        _chip(level, AppColors.primary),
                        const SizedBox(width: 6),
                      ],
                      if (totalSteps > 0)
                        _chip('$totalSteps bước', AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Enroll toggle button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: enrolled
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: enrolled
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: enrolling
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary))
                  : Icon(
                      enrolled ? Icons.check_rounded : Icons.add_rounded,
                      size: 20,
                      color: enrolled ? Colors.white : AppColors.primary,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      );
}
