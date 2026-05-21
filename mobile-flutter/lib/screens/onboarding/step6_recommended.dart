import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '../home/home_placeholder.dart';
import '../learning_path/path_detail_screen.dart';

class Step6Recommended extends StatelessWidget {
  final Map<String, dynamic> recommendedPath;

  const Step6Recommended({super.key, required this.recommendedPath});

  @override
  Widget build(BuildContext context) {
    final title = recommendedPath['title'] as String? ?? '';
    final description = recommendedPath['description'] as String? ?? '';
    final pathId = recommendedPath['id'] as String? ?? '';
    final totalSteps = recommendedPath['totalSteps'] as int? ?? 0;
    final level = recommendedPath['targetLevel'] as String? ?? '';
    final langFlag = recommendedPath['languageFlag'] as String? ?? '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text('🎉', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              context.l10n.recommendedForYou,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.recommendedForYouSub,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
                boxShadow: AppShadows.subtle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (langFlag.isNotEmpty)
                        Text(langFlag, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (level.isNotEmpty) ...[
                        _chip(level, AppColors.primary),
                        const SizedBox(width: 8),
                      ],
                      if (totalSteps > 0)
                        _chip('$totalSteps bước', AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: context.l10n.viewLearningPath,
                onTap: pathId.isNotEmpty
                    ? () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PathDetailScreen(pathId: pathId, pathTitle: title),
                          ),
                          (r) => false,
                        );
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TappableScale(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePlaceholder()),
                  (r) => false,
                ),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(context.l10n.exploreLater,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      );
}
