// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../services/progress_service.dart';
// import '../../services/study_log_service.dart';
// import '../../services/course_service.dart';
// import '../../models/course_model.dart';
// import '../../models/stats_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'LessonListPage.dart';
//
// class ProgressPage extends StatefulWidget {
//   final VoidCallback onBack;
//
//   const ProgressPage({super.key, required this.onBack});
//
//   @override
//   State<ProgressPage> createState() => _ProgressPageState();
// }
//
// class _ProgressPageState extends State<ProgressPage> {
//   List<Course> courses = [];
//   Map<String, dynamic>? streakData;
//   StatsResponse? stats;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadAllData();
//   }
//
//   Future<void> loadAllData() async {
//     if (!mounted) return;
//     setState(() => isLoading = true);
//
//     try {
//       final results = await Future.wait([
//         CourseService.getPublishedCourses(),
//         StudyLogService.getStreakData(),
//         ProgressApiService.getStats('WEEK'),
//       ]);
//
//       if (mounted) {
//         setState(() {
//           courses = results[0] as List<Course>;
//           streakData = results[1] as Map<String, dynamic>?;
//           stats = results[2] as StatsResponse?;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error loading progress data: $e");
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   // bool _isDateStudied(DateTime date) {
//   //   if (streakData == null || streakData!['studyDates'] == null) return false;
//   //   List<dynamic> studiedDates = streakData!['studyDates'];
//   //   String target = DateFormat('yyyy-MM-dd').format(date);
//   //
//   //   return studiedDates.any((d) {
//   //     try {
//   //       DateTime parsed = DateTime.parse(d.toString()).toLocal();
//   //       return DateFormat('yyyy-MM-dd').format(parsed) == target;
//   //     } catch (_) {
//   //       return false;
//   //     }
//   //   });
//   // }
//
//
//   bool _isDateStudied(DateTime date) {
//     if (streakData == null || streakData!['studyDates'] == null) return false;
//
//     List<dynamic> studiedDates = streakData!['studyDates'];
//
//     return studiedDates.any((d) {
//       try {
//         DateTime parsed = DateTime.parse(d.toString());
//
//         return parsed.year == date.year &&
//             parsed.month == date.month &&
//             parsed.day == date.day;
//       } catch (_) {
//         return false;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text(
//               "Learning Progress",
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//               onPressed: widget.onBack,
//             ),
//           ),
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//                   onRefresh: loadAllData,
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildStreakCard(theme),
//                         const SizedBox(height: 25),
//                         _buildStatsOverview(theme),
//                         const SizedBox(height: 25),
//                         Text("Weekly Activity",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.textTheme.titleLarge?.color)),
//                         const SizedBox(height: 20),
//                         _buildWeeklyChart(theme),
//                         const SizedBox(height: 30),
//                         Text("My Courses",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.textTheme.titleLarge?.color)),
//                         const SizedBox(height: 15),
//                         ...courses.map((course) => _buildCourseItem(course, theme)),
//                       ],
//                     ),
//                   ),
//                 ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStreakCard(ThemeData theme) {
//     int currentStreak = streakData?['currentStreak'] ?? 0;
//     bool studiedToday = streakData?['studiedToday'] ?? false;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: studiedToday
//               ? [const Color(0xFF6A11CB), const Color(0xFF2575FC)]
//               : [Colors.grey[700]!, Colors.grey[800]!],
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.local_fire_department,
//               color: studiedToday ? Colors.orangeAccent : Colors.grey[400],
//               size: 50),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("$currentStreak Days Streak!",
//                     style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                 Text(
//                   studiedToday ? "Great job! You've studied today." : "Keep it up! Study today to maintain your streak.",
//                   style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatsOverview(ThemeData theme) {
//     if (stats == null) return const SizedBox.shrink();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildStatItem("Minutes", stats!.totalMinutes.toString(), Icons.timer, Colors.blue, theme),
//         _buildStatItem("Lessons", stats!.totalLessons.toString(), Icons.book, Colors.green, theme),
//         _buildStatItem("Avg Score", "${stats!.averageScore.toStringAsFixed(1)}%", Icons.star, Colors.orange, theme),
//       ],
//     );
//   }
//
//   Widget _buildStatItem(String label, String value, IconData icon, Color color, ThemeData theme) {
//     return Container(
//       width: (MediaQuery.of(context).size.width - 60) / 3,
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.textTheme.titleLarge?.color)),
//           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeeklyChart(ThemeData theme) {
//     DateTime now = DateTime.now();
//     List<DateTime> last7Days = List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: last7Days.map((date) {
//         bool isStudied = _isDateStudied(date);
//         bool isToday = DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now);
//         String dayName = DateFormat('E').format(date);
//
//         return Column(
//           children: [
//             Container(
//               width: 32,
//               height: isStudied ? 80 : 25,
//               decoration: BoxDecoration(
//                 color: isStudied ? Colors.orange : theme.disabledColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: isToday ? Border.all(color: const Color(0xFF5F2EFF), width: 2) : null,
//               ),
//               child: isStudied ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               dayName,
//               style: TextStyle(
//                 color: isToday ? const Color(0xFF5F2EFF) : Colors.grey,
//                 fontSize: 12,
//                 fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildCourseItem(Course course, ThemeData theme) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LessonListPage(
//               courseId: course.id,
//               courseTitle: course.title,
//             ),
//           ),
//         ).then((_) => loadAllData());
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
//           ],
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.menu_book, color: Color(0xFF5F2EFF), size: 40),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(course.title,
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.textTheme.titleMedium?.color)),
//                   Text(course.level, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 45,
//                   height: 45,
//                   child: CircularProgressIndicator(
//                     value: (course.progressPercent) / 100,
//                     backgroundColor: theme.disabledColor.withOpacity(0.1),
//                     color: Colors.orange,
//                     strokeWidth: 5,
//                   ),
//                 ),
//                 Text(
//                   "${course.progressPercent}%",
//                   style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





//bản mới không hiện full cuse
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/progress_service.dart';
import '../../services/study_log_service.dart';
import '../../services/course_service.dart';
import '../../models/course_model.dart';
import '../../models/stats_model.dart';
import '../homepagesetting/theme_notifier.dart';
import 'LessonListPage.dart';

class ProgressPage extends StatefulWidget {
  final VoidCallback onBack;

  const ProgressPage({super.key, required this.onBack});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Course> courses = [];
  Map<String, dynamic>? streakData;
  StatsResponse? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        CourseService.getPublishedCourses(),
        StudyLogService.getStreakData(),
        ProgressApiService.getStats('WEEK'),
      ]);

      if (mounted) {
        setState(() {
          courses = results[0] as List<Course>;
          streakData = results[1] as Map<String, dynamic>?;
          stats = results[2] as StatsResponse?;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading progress data: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool _isDateStudied(DateTime date) {
    if (streakData == null || streakData!['studyDates'] == null) return false;

    List<dynamic> studiedDates = streakData!['studyDates'];

    return studiedDates.any((d) {
      try {
        DateTime parsed = DateTime.parse(d.toString());

        return parsed.year == date.year &&
            parsed.month == date.month &&
            parsed.day == date.day;
      } catch (_) {
        return false;
      }
    });
  }

  List<Course> _getLearningCourses() {
    final filtered = courses.where((course) {
      final progress = course.progressPercent;
      return progress > 0;
    }).toList();

    filtered.sort((a, b) {
      final aCompleted = a.progressPercent >= 100;
      final bCompleted = b.progressPercent >= 100;

      if (aCompleted != bCompleted) {
        return aCompleted ? 1 : -1; // đang học lên trước, hoàn thành xuống sau
      }

      return b.progressPercent.compareTo(a.progressPercent);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final learningCourses = _getLearningCourses();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Learning Progress",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: widget.onBack,
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
            onRefresh: loadAllData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStreakCard(theme),
                  const SizedBox(height: 25),
                  _buildStatsOverview(theme),
                  const SizedBox(height: 25),
                  Text(
                    "Weekly Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildWeeklyChart(theme),
                  const SizedBox(height: 30),
                  Text(
                    "My Courses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (learningCourses.isEmpty)
                    _buildEmptyCoursesState(theme)
                  else
                    ...learningCourses.map((course) => _buildCourseItem(course, theme)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakCard(ThemeData theme) {
    int currentStreak = streakData?['currentStreak'] ?? 0;
    bool studiedToday = streakData?['studiedToday'] ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: studiedToday
              ? [const Color(0xFF6A11CB), const Color(0xFF2575FC)]
              : [Colors.grey[700]!, Colors.grey[800]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department,
            color: studiedToday ? Colors.orangeAccent : Colors.grey[400],
            size: 50,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$currentStreak Days Streak!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  studiedToday
                      ? "Great job! You've studied today."
                      : "Keep it up! Study today to maintain your streak.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(ThemeData theme) {
    if (stats == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem("Minutes", stats!.totalMinutes.toString(), Icons.timer, Colors.blue, theme),
        _buildStatItem("Lessons", stats!.totalLessons.toString(), Icons.book, Colors.green, theme),
        _buildStatItem(
          "Avg Score",
          "${stats!.averageScore.toStringAsFixed(1)}%",
          Icons.star,
          Colors.orange,
          theme,
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String label,
      String value,
      IconData icon,
      Color color,
      ThemeData theme,
      ) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 3,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(ThemeData theme) {
    DateTime now = DateTime.now();
    List<DateTime> last7Days = List.generate(
      7,
          (index) => now.subtract(Duration(days: 6 - index)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: last7Days.map((date) {
        bool isStudied = _isDateStudied(date);
        bool isToday =
            DateFormat('yyyy-MM-dd').format(date) ==
                DateFormat('yyyy-MM-dd').format(now);
        String dayName = DateFormat('E').format(date);

        return Column(
          children: [
            Container(
              width: 32,
              height: isStudied ? 80 : 25,
              decoration: BoxDecoration(
                color: isStudied ? Colors.orange : theme.disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: const Color(0xFF5F2EFF), width: 2)
                    : null,
              ),
              child: isStudied
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              dayName,
              style: TextStyle(
                color: isToday ? const Color(0xFF5F2EFF) : Colors.grey,
                fontSize: 12,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyCoursesState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 42,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 12),
          Text(
            "Bạn chưa học khóa học nào",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Hãy bắt đầu học một khóa để theo dõi tiến độ tại đây nhé.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Course course, ThemeData theme) {
    final bool isCompleted = course.progressPercent >= 100;
    final String statusText = isCompleted ? "Completed" : "In Progress";
    final Color progressColor = isCompleted ? Colors.green : Colors.orange;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonListPage(
              courseId: course.id,
              courseTitle: course.title,
            ),
          ),
        ).then((_) => loadAllData());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.menu_book,
              color: isCompleted ? Colors.green : const Color(0xFF5F2EFF),
              size: 40,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${course.level} • $statusText",
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    value: (course.progressPercent.clamp(0, 100)) / 100,
                    backgroundColor: theme.disabledColor.withOpacity(0.1),
                    color: progressColor,
                    strokeWidth: 5,
                  ),
                ),
                Text(
                  "${course.progressPercent}%",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}