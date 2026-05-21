import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '_onboarding_widgets.dart';

class Step5HeardFrom extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLoading;

  const Step5HeardFrom({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
    this.isLoading = false,
  });

  // (backendKey, displayLabel, icon)
  List<(String, String, IconData)> _options(BuildContext context) => [
    ('GOOGLE',     context.l10n.heardFromGoogle,   Icons.search_rounded),
    ('SOCIAL',     context.l10n.heardFromSocial,   Icons.thumb_up_rounded),
    ('FRIEND',     context.l10n.heardFromFriend,   Icons.people_rounded),
    ('APP_STORE',  context.l10n.heardFromAppStore, Icons.store_rounded),
    ('AD',         context.l10n.heardFromAd,       Icons.campaign_rounded),
    ('OTHER',      context.l10n.heardFromOther,    Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(step: 5, total: 5, onBack: onBack),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.onboardingHeardFromTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.onboardingHeardFromSubtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: _options(context).map((opt) {
                final (key, label, icon) = opt;
                final isSelected = key == selected;
                return TappableScale(
                  onTap: () => onSelect(key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 26,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary),
                        const SizedBox(height: 6),
                        Text(label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : AppColors.textPrimary,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          OnboardingNextButton(
            label: context.l10n.startLearning,
            enabled: selected != null,
            isLoading: isLoading,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}
