// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../../../models/ai_recommend_model.dart';
// import '../../../services/ai_recommend_service.dart';
//
// class RecommendPage extends StatefulWidget {
//   const RecommendPage({super.key});
//
//   @override
//   State<RecommendPage> createState() => _RecommendPageState();
// }
//
// class _RecommendPageState extends State<RecommendPage> {
//   final TextEditingController _avgScoreController =
//   TextEditingController(text: "70");
//   final TextEditingController _weakSkillsController =
//   TextEditingController(text: "Listening, Speaking");
//   final TextEditingController _completedLessonIdsController =
//   TextEditingController();
//   final TextEditingController _availableLessonsJsonController =
//   TextEditingController(
//     text: '''[
//   {
//     "id": "lesson-1",
//     "title": "Basic Listening 1",
//     "skill": "Listening",
//     "cefrLevel": "A2",
//     "estimatedMinutes": 15
//   },
//   {
//     "id": "lesson-2",
//     "title": "Speaking Practice 1",
//     "skill": "Speaking",
//     "cefrLevel": "B1",
//     "estimatedMinutes": 20
//   }
// ]''',
//   );
//
//   String _learningPace = "NORMAL";
//   bool isLoading = false;
//   Map<String, dynamic>? result;
//
//   @override
//   void dispose() {
//     _avgScoreController.dispose();
//     _weakSkillsController.dispose();
//     _completedLessonIdsController.dispose();
//     _availableLessonsJsonController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _recommend() async {
//     if (isLoading) return;
//
//     try {
//       final rawLessons = jsonDecode(_availableLessonsJsonController.text);
//       if (rawLessons is! List) {
//         throw Exception("availableLessons phải là JSON array");
//       }
//
//       final lessons = rawLessons.map((e) {
//         final map = Map<String, dynamic>.from(e as Map);
//         return LessonSummaryModel(
//           id: map["id"]?.toString() ?? "",
//           title: map["title"]?.toString() ?? "",
//           skill: map["skill"]?.toString() ?? "",
//           cefrLevel: map["cefrLevel"]?.toString() ?? "B1",
//           estimatedMinutes: (map["estimatedMinutes"] ?? 0) as int,
//         );
//       }).toList();
//
//       final weakSkills = _weakSkillsController.text
//           .split(",")
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();
//
//       final completedLessonIds = _completedLessonIdsController.text
//           .split(",")
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();
//
//       setState(() {
//         isLoading = true;
//         result = null;
//       });
//
//       final response = await AiRecommendService.recommend(
//         RecommendRequestModel(
//           avgScore: double.tryParse(_avgScoreController.text.trim()) ?? 0,
//           weakSkills: weakSkills,
//           learningPace: _learningPace,
//           completedLessonIds: completedLessonIds,
//           availableLessons: lessons,
//         ),
//       );
//
//       if (!mounted) return;
//       setState(() => result = response);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi recommend: $e")),
//       );
//     } finally {
//       if (!mounted) return;
//       setState(() => isLoading = false);
//     }
//   }
//
//   Widget _resultCard(ThemeData theme) {
//     if (result == null) return const SizedBox.shrink();
//
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: SelectableText(
//         const JsonEncoder.withIndent("  ").convert(result),
//         style: TextStyle(
//           fontSize: 13,
//           color: theme.textTheme.bodyMedium?.color,
//           height: 1.45,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     const paceOptions = ["SLOW", "NORMAL", "FAST"];
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         title: const Text(
//           "AI Recommend",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _avgScoreController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Average Score",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _weakSkillsController,
//               decoration: InputDecoration(
//                 labelText: "Weak Skills",
//                 hintText: "Listening, Speaking",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _learningPace,
//               decoration: InputDecoration(
//                 labelText: "Learning Pace",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               items: paceOptions
//                   .map((pace) => DropdownMenuItem(
//                 value: pace,
//                 child: Text(pace),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _learningPace = value);
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _completedLessonIdsController,
//               decoration: InputDecoration(
//                 labelText: "Completed Lesson IDs",
//                 hintText: "lesson-1, lesson-2",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _availableLessonsJsonController,
//               minLines: 8,
//               maxLines: 14,
//               decoration: InputDecoration(
//                 labelText: "Available Lessons JSON",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : _recommend,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF5F2EFF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   "Get Recommendation",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             _resultCard(theme),
//           ],
//         ),
//       ),
//     );
//   }
// }




//bản mới
import 'package:flutter/material.dart';
import '../../../models/ai_recommend_model.dart';
import '../../../models/course_model.dart';
import '../../../models/lesson_model.dart';
import '../../../models/stats_model.dart';
import '../../../services/ai_recommend_service.dart';
import '../../../services/course_service.dart';
import '../../../services/lesson_service.dart';
import '../../../services/progress_service.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  String _selectedWeakSkill = "Listening";
  String _learningPace = "NORMAL";

  bool isLoadingProfileData = true;
  bool isSubmitting = false;

  StatsResponse? stats;
  List<Course> courses = [];
  List<Lesson> allLessons = [];

  Map<String, dynamic>? result;

  @override
  void initState() {
    super.initState();
    _loadRealData();
  }

  Future<void> _loadRealData() async {
    setState(() {
      isLoadingProfileData = true;
    });

    try {
      final loadedStats = await ProgressApiService.getStats("WEEK");
      final loadedCourses = await CourseService.getPublishedCourses();

      final List<Lesson> mergedLessons = [];

      for (final course in loadedCourses) {
        try {
          final lessons = await LessonService.getLessonsByCourse(course.id);
          mergedLessons.addAll(lessons);
        } catch (e) {
          debugPrint("Cannot load lessons for course ${course.id}: $e");
        }
      }

      if (!mounted) return;

      setState(() {
        stats = loadedStats;
        courses = loadedCourses;
        allLessons = mergedLessons;
        isLoadingProfileData = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoadingProfileData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải dữ liệu recommend: $e")),
      );
    }
  }

  List<String> _buildCompletedLessonIds() {
    return allLessons
        .where((lesson) => lesson.progressStatus == "COMPLETED")
        .map((lesson) => lesson.id)
        .toList();
  }

  List<LessonSummaryModel> _buildAvailableLessons() {
    return allLessons.map((lesson) {
      return LessonSummaryModel(
        id: lesson.id,
        title: lesson.title,
        skill: _normalizeSkill(lesson.type),
        cefrLevel: _inferLessonLevel(lesson),
        estimatedMinutes: lesson.durationMinutes,
      );
    }).toList();
  }

  String _normalizeSkill(String type) {
    final upper = type.toUpperCase();

    if (upper.contains("LISTEN")) return "Listening";
    if (upper.contains("GRAMMAR")) return "Grammar";
    if (upper.contains("VOCAB")) return "Vocabulary";
    if (upper.contains("SPEAK")) return "Speaking";
    if (upper.contains("READ")) return "Reading";
    if (upper.contains("WRITE")) return "Writing";

    return "General";
  }

  String _inferLessonLevel(Lesson lesson) {
    final course = courses.where((c) => c.id == lesson.courseId).cast<Course?>().firstWhere(
          (c) => c != null,
      orElse: () => null,
    );

    if (course == null) return "B1";

    final level = course.level.toUpperCase();

    if (level.contains("BEGINNER")) return "A1";
    if (level.contains("ELEMENTARY")) return "A2";
    if (level.contains("INTERMEDIATE")) return "B1";
    if (level.contains("UPPER")) return "B2";
    if (level.contains("ADVANCED")) return "C1";

    return "B1";
  }

  Future<void> _getRecommendation() async {
    if (isSubmitting || stats == null) return;

    setState(() {
      isSubmitting = true;
      result = null;
    });

    try {
      final response = await AiRecommendService.recommend(
        RecommendRequestModel(
          avgScore: stats!.averageScore,
          weakSkills: [_selectedWeakSkill],
          learningPace: _learningPace,
          completedLessonIds: _buildCompletedLessonIds(),
          availableLessons: _buildAvailableLessons(),
        ),
      );

      if (!mounted) return;

      setState(() {
        result = response;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi recommend: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Widget _buildChoiceChip(
      String label,
      String currentValue,
      ValueChanged<String> onChanged,
      ) {
    final selected = label == currentValue;

    return GestureDetector(
      onTap: () => onChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5F2EFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF5F2EFF) : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  String _readBestText(Map<String, dynamic> data) {
    const priorityKeys = [
      "recommendation",
      "suggestion",
      "bestLesson",
      "reason",
      "message",
      "raw",
    ];

    for (final key in priorityKeys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return data.toString();
  }

  Widget _buildResultCard(ThemeData theme) {
    if (result == null) return const SizedBox.shrink();

    final text = _readBestText(result!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF5F2EFF)),
              SizedBox(width: 8),
              Text(
                "Your Recommendation",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPreview(ThemeData theme) {
    final completedCount = _buildCompletedLessonIds().length;
    final availableCount = _buildAvailableLessons().length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your real learning data",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Text("Average score: ${stats?.averageScore.toStringAsFixed(1) ?? 0}%"),
          Text("Completed lessons: $completedCount"),
          Text("Available lessons: $availableCount"),
          Text("Total study minutes: ${stats?.totalMinutes ?? 0}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const weakSkills = [
      "Listening",
      "Speaking",
      "Grammar",
      "Vocabulary",
      "Reading",
      "Writing",
    ];

    const learningPaces = [
      "SLOW",
      "NORMAL",
      "FAST",
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        title: const Text(
          "AI Recommend",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoadingProfileData
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadRealData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataPreview(theme),
              const SizedBox(height: 24),
              Text(
                "What do you want to improve?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: weakSkills
                    .map(
                      (skill) => _buildChoiceChip(
                    skill,
                    _selectedWeakSkill,
                        (value) {
                      setState(() => _selectedWeakSkill = value);
                    },
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 26),
              Text(
                "Your learning pace",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: learningPaces
                    .map(
                      (pace) => _buildChoiceChip(
                    pace,
                    _learningPace,
                        (value) {
                      setState(() => _learningPace = value);
                    },
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _getRecommendation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F2EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  )
                      : const Text(
                    "Get Recommendation",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildResultCard(theme),
            ],
          ),
        ),
      ),
    );
  }
}