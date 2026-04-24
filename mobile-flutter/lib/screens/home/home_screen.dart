import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/ai_button_controller.dart';
import '../../l10n/l10n_ext.dart';
import 'dashboard_tab.dart';
import '../learning_path/learning_path_tab.dart';
import '../profile/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    AiButtonController.show();
    _tabs = [
      DashboardTab(onGoToLearningPath: () => setState(() => _tab = 1)),
      const LearningPathTab(),
      const ProfileTab(),
    ];
  }

  @override
  void dispose() {
    AiButtonController.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: IndexedStack(index: _tab, children: _tabs),
        bottomNavigationBar: _BottomNav(
          current: _tab,
          onTap: (i) => setState(() => _tab = i),
        ),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, context.l10n.home),
      (Icons.route_rounded, Icons.route_outlined, context.l10n.path),
      (Icons.person_rounded, Icons.person_outline_rounded, context.l10n.profile),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final (activeIcon, inactiveIcon, label) = items[i];
              final isSelected = i == current;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isSelected ? activeIcon : inactiveIcon,
                            color: isSelected
                                ? AppColors.primaryLight
                                : AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primaryLight
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
