import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../l10n/l10n_ext.dart';
import '_onboarding_widgets.dart';

class Step1Language extends StatelessWidget {
  /// Language objects from API: [{id, code, name, nativeName, flag, ...}]
  final List<Map<String, dynamic>> languages;
  final List<String> selectedIds;
  final ValueChanged<String> onToggle; // passes language ID
  final VoidCallback onNext;

  const Step1Language({
    super.key,
    required this.languages,
    required this.selectedIds,
    required this.onToggle,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(step: 1, total: 6, onBack: null),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.onboardingLanguageTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.onboardingLanguageSubtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: languages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final lang = languages[i];
                      final id = lang['id'] as String;
                      final name = lang['name'] as String? ?? '';
                      final nativeName = lang['nativeName'] as String? ?? name;
                      final flag = lang['flag'] as String? ?? '';
                      final isSelected = selectedIds.contains(id);

                      return TappableScale(
                        onTap: () => onToggle(id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
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
                              // Flag: if URL use network image, else treat as emoji/text
                              _flagWidget(flag),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.primaryLight
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (nativeName != name)
                                    Text(
                                      nativeName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
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
            enabled: selectedIds.isNotEmpty,
            onTap: onNext,
          ),
        ],
      ),
    );
  }

  Widget _flagWidget(String flag) {
    if (flag.startsWith('http')) {
      return SizedBox(
        width: 32,
        height: 32,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            flag,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.language, size: 24, color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return Text(flag, style: const TextStyle(fontSize: 24));
  }
}
