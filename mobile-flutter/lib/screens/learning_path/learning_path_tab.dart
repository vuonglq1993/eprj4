import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/learning_service.dart';
import 'path_detail_screen.dart';

class LearningPathTab extends StatefulWidget {
  const LearningPathTab({super.key});

  @override
  State<LearningPathTab> createState() => _LearningPathTabState();
}

class _LearningPathTabState extends State<LearningPathTab> {
  List<Map<String, dynamic>> _myPaths = [];
  List<Map<String, dynamic>> _publicPaths = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      LearningService.getMyLearningPaths(),
      LearningService.getPublicLearningPaths(),
    ]);
    if (!mounted) return;
    setState(() {
      _myPaths = results[0];
      _publicPaths = results[1];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 180,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.bgTop),
            ),
          ),
          SafeArea(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary))
                : RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    onRefresh: _load,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Header
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                            child: Row(
                              children: [
                                const Text(
                                  'Lộ trình học',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.route_rounded,
                                  color: AppColors.primaryLight,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // My paths
                        if (_myPaths.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: _sectionHeader('Lộ trình của tôi'),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (_, i) => _pathCard(_myPaths[i],
                                    enrolled: true),
                                childCount: _myPaths.length,
                              ),
                            ),
                          ),
                        ],

                        // Public paths
                        SliverToBoxAdapter(
                          child: _sectionHeader(
                            _myPaths.isEmpty
                                ? 'Khám phá lộ trình'
                                : 'Lộ trình khác',
                          ),
                        ),

                        if (_publicPaths.isEmpty)
                          SliverToBoxAdapter(
                            child: _emptyCard(),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (_, i) => _pathCard(_publicPaths[i],
                                    enrolled: false),
                                childCount: _publicPaths.length,
                              ),
                            ),
                          ),

                        const SliverToBoxAdapter(
                            child: SizedBox(height: 32)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          children: [
            Icon(Icons.explore_outlined,
                color: AppColors.textSecondary, size: 36),
            SizedBox(height: 12),
            Text(
              'Chưa có lộ trình nào',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Lộ trình sẽ xuất hiện khi được thêm vào hệ thống',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pathCard(Map<String, dynamic> path,
      {required bool enrolled}) {
    final id = path['id'] as String? ?? '';
    final title = path['title'] as String? ?? '';
    final description = path['description'] as String? ?? '';
    final language = path['languageName'] as String? ?? '';
    final targetLevel = path['targetLevel'] as String? ?? '';
    final estimatedHours = path['estimatedHours'] as int? ?? 0;
    final totalSteps = path['totalSteps'] as int? ?? 0;
    final progressPercent = path['progressPercent'] as int? ?? 0;
    final isOfficial = path['isOfficial'] as bool? ?? false;

    return TappableScale(
      onTap: () => Navigator.push(
        context,
        _route(PathDetailScreen(pathId: id, pathTitle: title)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: enrolled
                ? AppColors.primary.withValues(alpha: 0.35)
                : AppColors.border,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Language badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    language,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if (isOfficial)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'OFFICIAL',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                const Spacer(),
                if (enrolled)
                  Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 10),
            if (enrolled) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: progressPercent / 100),
                  builder: (_, v, __) => LinearProgressIndicator(
                    value: v,
                    backgroundColor: AppColors.inputBg,
                    color: AppColors.primary,
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                _pathMeta(Icons.layers_rounded, '$totalSteps bước'),
                const SizedBox(width: 14),
                _pathMeta(Icons.access_time_rounded, '${estimatedHours}h'),
                const SizedBox(width: 14),
                _pathMeta(
                    Icons.signal_cellular_alt_rounded, targetLevel),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pathMeta(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  PageRouteBuilder _route(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, anim, __, child) {
          final slide = Tween<Offset>(
                  begin: const Offset(0.05, 0), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: anim, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity:
                CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: SlideTransition(position: slide, child: child),
          );
        },
      );
}
