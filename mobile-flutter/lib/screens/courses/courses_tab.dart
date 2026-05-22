import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/api_service.dart';
import '../../l10n/l10n_ext.dart';
import '../course/course_lessons_screen.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  List<Map<String, dynamic>> _topics = [];
  List<Map<String, dynamic>> _courses = [];
  String? _selectedTopicId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final topics = await ApiService.getTopics();
    final courses = _selectedTopicId == null
        ? await ApiService.getCourses()
        : await ApiService.getCoursesByTopic(_selectedTopicId!);
    if (!mounted) return;
    setState(() {
      _topics = topics.where((t) => t['isActive'] == true).toList();
      _courses = courses;
      _loading = false;
    });
  }

  Future<void> _selectTopic(String? topicId) async {
    if (_selectedTopicId == topicId) return;
    setState(() { _selectedTopicId = topicId; _loading = true; });
    final courses = topicId == null
        ? await ApiService.getCourses()
        : await ApiService.getCoursesByTopic(topicId);
    if (!mounted) return;
    setState(() { _courses = courses; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 180,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: const Color(0xFF0D2540),
              onRefresh: _load,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                      child: Text(
                        context.l10n.courses,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  // Topic filter chips
                  if (_topics.isNotEmpty)
                    SliverToBoxAdapter(child: _topicFilter()),
                  // Course list
                  if (_loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    )
                  else if (_courses.isEmpty)
                    SliverFillRemaining(child: _emptyState())
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _courseCard(_courses[i]),
                          childCount: _courses.length,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topicFilter() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _chip(label: context.l10n.allTopics, selected: _selectedTopicId == null,
              onTap: () => _selectTopic(null)),
          ..._topics.map((t) {
            final id = t['id'] as String? ?? '';
            final name = t['name'] as String? ?? '';
            final icon = t['iconUrl'] as String? ?? '';
            return _chip(
              label: icon.isNotEmpty ? '$icon $name' : name,
              selected: _selectedTopicId == id,
              onTap: () => _selectTopic(id),
            );
          }),
        ],
      ),
    );
  }

  Widget _chip({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.18) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primaryLight : AppColors.textSecondary,
              )),
        ),
      ),
    );
  }

  Widget _courseCard(Map<String, dynamic> course) {
    final id = course['id'] as String? ?? '';
    final title = course['title'] as String? ?? '';
    final description = course['description'] as String? ?? '';
    final language = course['languageName'] as String? ?? '';
    final level = course['level'] as String? ?? '';
    final totalLessons = course['totalLessons'] as int? ?? 0;

    return TappableScale(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => CourseLessonsScreen(courseId: id, courseTitle: title),
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(description, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      if (language.isNotEmpty)
                        _meta(Icons.language_rounded, language),
                      if (level.isNotEmpty)
                        _meta(Icons.signal_cellular_alt_rounded,
                            level.replaceAll('_', ' ')),
                      _meta(Icons.layers_rounded, '$totalLessons bài'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String label) => Row(children: [
    Icon(icon, size: 11, color: AppColors.textSecondary),
    const SizedBox(width: 3),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
  ]);

  Widget _emptyHint() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.category_outlined, size: 48, color: AppColors.textSecondary),
        const SizedBox(height: 12),
        Text('Chọn chủ đề để xem khoá học',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            textAlign: TextAlign.center),
      ]),
    ),
  );

  Widget _emptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSecondary),
        const SizedBox(height: 12),
        Text('Chưa có khoá học cho chủ đề này',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            textAlign: TextAlign.center),
      ]),
    ),
  );
}
