import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/api_service.dart';
import 'step1_language.dart';
import 'step2_goal.dart';
import 'step3_personalize.dart';
import 'step4_placement_test.dart';

/// Quản lý state chung cho 4 bước onboarding.
/// Tải danh sách ngôn ngữ từ API một lần duy nhất.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;

  // Languages loaded from API: [{id, code, name, nativeName, flag, isActive, ...}]
  List<Map<String, dynamic>> _languages = [];
  bool _loadingLanguages = true;
  bool _languageLoadError = false;

  // Collected answers
  final List<String> selectedLanguageIds = [];
  String? goal;          // backend enum: TRAVEL | SCHOOL | WORK | FAMILY_FRIENDS | SKILL_IMPROVEMENT | OTHERS
  String dailyTime = 'FIFTEEN_MIN'; // backend enum: FIVE_MIN | FIFTEEN_MIN | THIRTY_MIN | SIXTY_MIN
  String? ageGroup;      // e.g. 'Dưới 18', '18 – 24', '25 – 34', '35 – 44', '45+'

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    setState(() {
      _loadingLanguages = true;
      _languageLoadError = false;
    });
    final langs = await ApiService.getLanguages();
    if (!mounted) return;
    setState(() {
      // Server already filters isActive=true, no need to filter client-side
      _languages = langs;
      _loadingLanguages = false;
      // If langs is empty AND we got a valid (non-error) response, it means DB has no data
      // getLanguages() returns [] on both network error and empty DB —
      // we treat both the same: show retry
      _languageLoadError = langs.isEmpty;
    });
  }

  void next() => setState(() => _step++);
  void back() {
    if (_step > 0) setState(() => _step--);
  }

  Widget _currentStep() {
    if (_loadingLanguages) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_languageLoadError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              const Text(
                'Không tải được danh sách ngôn ngữ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kiểm tra kết nối mạng và backend, sau đó thử lại.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _loadLanguages,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    switch (_step) {
      case 0:
        return Step1Language(
          key: const ValueKey(0),
          languages: _languages,
          selectedIds: selectedLanguageIds,
          onToggle: (id) {
            setState(() {
              if (selectedLanguageIds.contains(id)) {
                selectedLanguageIds.remove(id);
              } else {
                selectedLanguageIds.add(id);
              }
            });
          },
          onNext: next,
        );
      case 1:
        return Step2Goal(
          key: const ValueKey(1),
          selected: goal,
          onSelect: (v) => setState(() => goal = v),
          onNext: next,
          onBack: back,
        );
      case 2:
        return Step3Personalize(
          key: const ValueKey(2),
          dailyTime: dailyTime,
          ageGroup: ageGroup,
          onDailyTimeChanged: (v) => setState(() => dailyTime = v),
          onAgeGroupSelected: (v) => setState(() => ageGroup = v),
          onNext: next,
          onBack: back,
        );
      case 3:
        // First selected language ID, fallback empty if none
        final targetId = selectedLanguageIds.isNotEmpty
            ? selectedLanguageIds.first
            : (_languages.isNotEmpty ? _languages.first['id'] as String : '');
        return Step4PlacementTest(
          key: const ValueKey(3),
          targetLanguageId: targetId,
          goal: goal ?? 'OTHERS',
          dailyTime: dailyTime,
          ageGroup: ageGroup,
          onBack: back,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _currentStep(),
      ),
    );
  }
}
