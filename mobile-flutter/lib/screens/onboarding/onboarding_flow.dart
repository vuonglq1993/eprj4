import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/api_service.dart';
import '../home/home_placeholder.dart';
import 'step1_language.dart';
import 'step2_goal.dart';
import 'step3_level.dart';
import 'step3_personalize.dart';
import 'step5_heard_from.dart';
import 'step6_recommended.dart';

/// Flow: Language → Goal → Level → Personalize → HeardFrom → [submit] → Recommended
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;

  List<Map<String, dynamic>> _languages = [];
  bool _loadingLanguages = true;
  bool _languageLoadError = false;

  // Collected answers
  final List<String> selectedLanguageIds = [];
  String? goal;
  String? selfLevel;
  String dailyTime = 'FIFTEEN_MIN';
  String? ageGroup;
  String? heardFrom;

  // Result after submit
  List<Map<String, dynamic>> _recommendedPaths = [];
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    setState(() { _loadingLanguages = true; _languageLoadError = false; });
    final langs = await ApiService.getLanguages();
    if (!mounted) return;
    setState(() {
      _languages = langs;
      _loadingLanguages = false;
      _languageLoadError = langs.isEmpty;
    });
  }

  void next() => setState(() => _step++);
  void back() { if (_step > 0) setState(() => _step--); }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final ids = selectedLanguageIds.isNotEmpty
        ? selectedLanguageIds
        : (_languages.isNotEmpty ? [_languages.first['id'] as String] : <String>[]);

    final paths = <Map<String, dynamic>>[];
    for (int i = 0; i < ids.length; i++) {
      final result = await ApiService.submitOnboarding(
        targetLanguageId: ids[i],
        selfLevel: selfLevel ?? 'BEGINNER',
        goal: goal ?? 'OTHERS',
        dailyTime: dailyTime,
        ageGroup: ageGroup,
        heardFrom: i == 0 ? heardFrom : null, // chỉ gửi heardFrom lần đầu
      );
      final p = result?['recommendedPath'] as Map<String, dynamic>?;
      if (p != null) paths.add(p);
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (paths.isNotEmpty) {
      setState(() {
        _recommendedPaths = paths;
        _step = 5;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePlaceholder()),
        (r) => false,
      );
    }
  }

  Widget _currentStep() {
    if (_loadingLanguages) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
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
              const Text('Không thể tải danh sách ngôn ngữ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('Kiểm tra kết nối mạng và thử lại',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
          onToggle: (id) => setState(() {
            selectedLanguageIds.contains(id)
                ? selectedLanguageIds.remove(id)
                : selectedLanguageIds.add(id);
          }),
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
        return Step3Level(
          key: const ValueKey(2),
          selected: selfLevel,
          onSelect: (v) => setState(() => selfLevel = v),
          onNext: next,
          onBack: back,
        );
      case 3:
        return Step3Personalize(
          key: const ValueKey(3),
          dailyTime: dailyTime,
          ageGroup: ageGroup,
          onDailyTimeChanged: (v) => setState(() => dailyTime = v),
          onAgeGroupSelected: (v) => setState(() => ageGroup = v),
          onNext: next,
          onBack: back,
        );
      case 4:
        return Step5HeardFrom(
          key: const ValueKey(4),
          selected: heardFrom,
          onSelect: (v) => setState(() => heardFrom = v),
          onNext: _submit,
          onBack: back,
          isLoading: _submitting,
        );
      case 5:
        return Step6Recommended(
          key: const ValueKey(5),
          recommendedPaths: _recommendedPaths,
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
