import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '_onboarding_widgets.dart';

class Step2Goal extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2Goal({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  // Values match backend LearningGoal enum exactly
  static const _goalKeys = [
    ('SKILL_IMPROVEMENT', Icons.workspace_premium_rounded),
    ('FAMILY_FRIENDS', Icons.chat_bubble_outline_rounded),
    ('SCHOOL', Icons.flight_takeoff_rounded),
    ('WORK', Icons.business_center_rounded),
    ('TRAVEL', Icons.explore_rounded),
    ('OTHERS', Icons.more_horiz_rounded),
  ];

  List<(String, String, IconData)> _goals(BuildContext context) => [
    (_goalKeys[0].$1, context.l10n.goalToeic, _goalKeys[0].$2),
    (_goalKeys[1].$1, context.l10n.goalCommunication, _goalKeys[1].$2),
    (_goalKeys[2].$1, context.l10n.goalStudyAbroad, _goalKeys[2].$2),
    (_goalKeys[3].$1, context.l10n.goalWork, _goalKeys[3].$2),
    (_goalKeys[4].$1, context.l10n.goalTravel, _goalKeys[4].$2),
    (_goalKeys[5].$1, context.l10n.goalOther, _goalKeys[5].$2),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(step: 2, total: 4, onBack: onBack),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.onboardingGoalTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.onboardingGoalSubtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _goals(context).length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final (value, label, icon) = _goals(context)[i];
                final isSelected = value == selected;
                return TappableScale(
                  onTap: () => onSelect(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
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
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.inputBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            icon,
                            size: 20,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryLight
                                : AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check,
                                size: 14, color: Colors.white),
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
