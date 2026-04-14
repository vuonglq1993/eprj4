import 'package:flutter/material.dart';
import '../../models/course_model.dart';
import '../homepagesetting/theme_notifier.dart';

class AchievementPage extends StatelessWidget {
  final List<Course> completedCourses;

  const AchievementPage({
    super.key,
    required this.completedCourses,
  });

  String _getFlagEmoji(String title) {
    if (title.contains("German")) return "🇩🇪";
    if (title.contains("Spanish")) return "🇪🇸";
    if (title.contains("English")) return "🇬🇧";
    if (title.contains("French")) return "🇫🇷";
    if (title.contains("Japanese")) return "🇯🇵";
    return "🏆";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "All Achievements",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: completedCourses.isEmpty
              ? Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.05),
                ),
              ),
              child: const Text(
                "No achievements yet. Finish a course to earn one!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: completedCourses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final course = completedCourses[index];
              return _buildAchievementCard(
                course.title,
                "Level ${course.level}",
                _getFlagEmoji(course.title),
                theme,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAchievementCard(
      String title,
      String level,
      String flagEmoji,
      ThemeData theme,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(flagEmoji, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: theme.textTheme.titleSmall?.color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            level,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}