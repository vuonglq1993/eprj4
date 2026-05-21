import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '_onboarding_widgets.dart';

class Step3Level extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Level({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  List<(String, String, String, IconData)> _levels(BuildContext context) => [
    ('COMPLETE_BEGINNER', context.l10n.selfLevelCompleteBeginner, context.l10n.selfLevelCompleteBeginnerSub, Icons.sentiment_very_dissatisfied_rounded),
    ('BEGINNER',          context.l10n.selfLevelBeginner,          context.l10n.selfLevelBeginnerSub,          Icons.sentiment_neutral_rounded),
    ('INTERMEDIATE',      context.l10n.selfLevelIntermediate,      context.l10n.selfLevelIntermediateSub,      Icons.sentiment_satisfied_rounded),
    ('ADVANCED',          context.l10n.selfLevelAdvanced,          context.l10n.selfLevelAdvancedSub,          Icons.sentiment_very_satisfied_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(step: 4, total: 6, onBack: onBack),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.onboardingLevelTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.onboardingLevelSubtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _levels(context).length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final (value, label, subtitle, icon) = _levels(context)[i];
                final isSelected = value == selected;
                return TappableScale(
                  onTap: () => onSelect(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected ? AppShadows.subtle : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.inputBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, size: 22,
                              color: isSelected ? Colors.white : AppColors.textSecondary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primaryLight
                                        : AppColors.textPrimary,
                                  )),
                              const SizedBox(height: 2),
                              Text(subtitle,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                                color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          OnboardingNextButton(
            label: context.l10n.next,
            enabled: selected != null,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}
