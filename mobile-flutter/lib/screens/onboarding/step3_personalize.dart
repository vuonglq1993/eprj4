import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '_onboarding_widgets.dart';

class Step3Personalize extends StatelessWidget {
  final String dailyTime;
  final String? ageGroup;
  final ValueChanged<String> onDailyTimeChanged;
  final ValueChanged<String> onAgeGroupSelected;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Personalize({
    super.key,
    required this.dailyTime,
    required this.ageGroup,
    required this.onDailyTimeChanged,
    required this.onAgeGroupSelected,
    required this.onNext,
    required this.onBack,
  });

  // (enum value, display minutes)
  static const _timeOptions = [
    ('FIVE_MIN', 5),
    ('FIFTEEN_MIN', 15),
    ('THIRTY_MIN', 30),
    ('SIXTY_MIN', 60),
  ];

  static const _ageGroups = [
    'Dưới 18',
    '18 – 24',
    '25 – 34',
    '35 – 44',
    '45+',
  ];

  String _ageLabel(BuildContext context, String age) {
    switch (age) {
      case 'Dưới 18': return context.l10n.ageUnder18;
      case '18 – 24': return context.l10n.age1824;
      case '25 – 34': return context.l10n.age2534;
      case '35 – 44': return context.l10n.age3544;
      case '45+': return context.l10n.age45plus;
      default: return age;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(step: 3, total: 3, onBack: onBack),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.onboardingPersonalizeTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Daily time ───────────────────────────────────────────
                  Text(
                    context.l10n.dailyMinutes,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _timeOptions.map((opt) {
                      final (enumVal, minutes) = opt;
                      final isSelected = enumVal == dailyTime;
                      final isLast = opt == _timeOptions.last;
                      return Expanded(
                        child: TappableScale(
                          onTap: () => onDailyTimeChanged(enumVal),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            margin: EdgeInsets.only(right: isLast ? 0 : 8),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppGradients.primaryButton
                                  : null,
                              color: isSelected ? null : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                              boxShadow:
                                  isSelected ? AppShadows.primaryGlow : null,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$minutes',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  context.l10n.minutes,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // ── Age group ────────────────────────────────────────────
                  Text(
                    context.l10n.ageRange,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _ageGroups.map((age) {
                      final isSelected = age == ageGroup;
                      return TappableScale(
                        onTap: () => onAgeGroupSelected(age),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: isSelected ? AppShadows.subtle : null,
                          ),
                          child: Text(
                            _ageLabel(context, age),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // AI note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: AppColors.primary, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'AI sẽ tạo lộ trình phù hợp dựa trên thông tin của bạn.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          OnboardingNextButton(
            label: 'Bắt đầu kiểm tra trình độ',
            enabled: ageGroup != null, // require age group before proceeding
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}
