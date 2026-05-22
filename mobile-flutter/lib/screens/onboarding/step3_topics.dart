import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/api_service.dart';
import '../../l10n/l10n_ext.dart';
import '_onboarding_widgets.dart';

class Step3Topics extends StatefulWidget {
  final List<String> selectedIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Topics({
    super.key,
    required this.selectedIds,
    required this.onToggle,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Topics> createState() => _Step3TopicsState();
}

class _Step3TopicsState extends State<Step3Topics> {
  List<Map<String, dynamic>> _topics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final topics = await ApiService.getTopics();
    if (!mounted) return;
    setState(() { _topics = topics; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingHeader(step: 3, total: 6, onBack: widget.onBack),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.onboardingTopicsTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    )),
                const SizedBox(height: 6),
                Text(context.l10n.onboardingTopicsSubtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: _topics.length,
                    itemBuilder: (_, i) {
                      final topic = _topics[i];
                      final id = topic['id'] as String? ?? '';
                      final name = topic['name'] as String? ?? '';
                      final icon = topic['iconUrl'] as String? ?? '';
                      final isSelected = widget.selectedIds.contains(id);
                      final atLimit = widget.selectedIds.length >= 3 && !isSelected;

                      return TappableScale(
                        onTap: atLimit ? null : () => widget.onToggle(id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : atLimit
                                    ? AppColors.surface.withValues(alpha: 0.5)
                                    : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (icon.isNotEmpty)
                                Text(icon, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.primaryLight
                                          : atLimit
                                              ? AppColors.textHint
                                              : AppColors.textPrimary,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          OnboardingNextButton(
            label: widget.selectedIds.isEmpty ? context.l10n.skip : context.l10n.next,
            enabled: true,
            onTap: widget.onNext,
          ),
        ],
      ),
    );
  }
}
