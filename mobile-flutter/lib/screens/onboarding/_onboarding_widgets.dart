import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';

/// Progress bar header dùng chung cho các bước onboarding
class OnboardingHeader extends StatelessWidget {
  final int step;
  final int total;
  final VoidCallback? onBack;

  const OnboardingHeader({
    super.key,
    required this.step,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 24, 4),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary, size: 20),
              onPressed: onBack,
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.onboardingStep(step, total),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(total, (i) {
                    final isActive = i < step;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          gradient:
                              isActive ? AppGradients.progressActive : null,
                          color: isActive ? null : AppColors.surface,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Nút "Tiếp theo / Hoàn thành" ở cuối mỗi bước — sử dụng GradientButton
class OnboardingNextButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool isLoading;

  const OnboardingNextButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        child: GradientButton(
          label: label,
          enabled: enabled,
          isLoading: isLoading,
          onTap: onTap,
        ),
      ),
    );
  }
}
