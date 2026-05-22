import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/learning_service.dart';
import '../../l10n/l10n_ext.dart';
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
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 0;

  String? _filterLanguage;
  String? _filterLevel;

  List<Map<String, dynamic>> get _filtered {
    return _publicPaths.where((p) {
      final lang = p['languageName'] as String? ?? '';
      final level = p['targetLevel'] as String? ?? '';
      if (_filterLanguage != null && lang != _filterLanguage) return false;
      if (_filterLevel != null && level != _filterLevel) return false;
      return true;
    }).toList();
  }

  List<String> get _languages => _publicPaths
      .map((p) => p['languageName'] as String? ?? '')
      .where((s) => s.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  List<(String, String)> _levelFilters(BuildContext context) => [
    ('BEGINNER', context.l10n.filterBeginner),
    ('ELEMENTARY', context.l10n.filterElementary),
    ('INTERMEDIATE', context.l10n.filterIntermediate),
    ('UPPER_INTERMEDIATE', context.l10n.filterUpperIntermediate),
    ('ADVANCED', context.l10n.filterAdvanced),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _page = 0; });
    final myFuture  = LearningService.getMyLearningPaths();
    final pubFuture = LearningService.getPublicLearningPaths(page: 0);
    final my  = await myFuture;
    final pub = await pubFuture;
    if (!mounted) return;
    setState(() {
      _myPaths    = my;
      _publicPaths = pub.items;
      _hasMore    = pub.hasMore;
      _loading    = false;
    });
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    final next = await LearningService.getPublicLearningPaths(page: _page + 1);
    if (!mounted) return;
    setState(() {
      _page++;
      _publicPaths = [..._publicPaths, ...next.items];
      _hasMore = next.hasMore;
      _loadingMore = false;
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
                    backgroundColor: const Color(0xFF0D2540),
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
                                Text(
                                  context.l10n.learningPath,
                                  style: const TextStyle(
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
                            child: _sectionHeader(context.l10n.myPath),
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

                        // Filter bar
                        if (_publicPaths.isNotEmpty)
                          SliverToBoxAdapter(child: _filterBar()),

                        // Public paths
                        SliverToBoxAdapter(
                          child: _sectionHeader(
                            _myPaths.isEmpty
                                ? context.l10n.explorePaths
                                : context.l10n.otherPaths,
                          ),
                        ),

                        if (_filtered.isEmpty)
                          SliverToBoxAdapter(child: _emptyCard())
                        else
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (_, i) => _pathCard(_filtered[i], enrolled: false),
                                childCount: _filtered.length,
                              ),
                            ),
                          ),

                        // Load more button — ẩn khi đang filter (filter là client-side)
                        if ((_hasMore || _loadingMore) &&
                            _filterLanguage == null && _filterLevel == null)
                          SliverToBoxAdapter(child: _loadMoreButton()),

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

  Widget _filterBar() {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: _languages.map((lang) => _chip(
                  label: lang,
                  selected: _filterLanguage == lang,
                  onTap: () => setState(() =>
                      _filterLanguage = _filterLanguage == lang ? null : lang),
                )).toList(),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: _levelFilters(context).map((entry) {
              final (value, label) = entry;
              return _chip(
                label: label,
                selected: _filterLevel == value,
                onTap: () => setState(
                    () => _filterLevel = _filterLevel == value ? null : value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primaryLight : AppColors.textSecondary,
            ),
          ),
        ),
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

  Widget _loadMoreButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: _loadingMore
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2),
              ),
            )
          : TextButton(
              onPressed: _loadMore,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF0D2540),
                foregroundColor: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: Text(context.l10n.loadMore,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
        child: Column(
          children: [
            const Icon(Icons.explore_outlined,
                color: AppColors.textSecondary, size: 36),
            const SizedBox(height: 12),
            Text(
              context.l10n.noPathsYet,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.pathsWillAppear,
              style: const TextStyle(
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
                    child: Text(
                      context.l10n.official,
                      style: const TextStyle(
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
                _pathMeta(Icons.layers_rounded, context.l10n.steps(totalSteps)),
                const SizedBox(width: 14),
                _pathMeta(Icons.access_time_rounded, context.l10n.estimatedHours(estimatedHours.toString())),
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
