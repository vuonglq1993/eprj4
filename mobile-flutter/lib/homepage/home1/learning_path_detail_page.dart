//bản chạy được
// import 'package:flutter/material.dart';
// import '../../models/learning_path_model.dart';
// import '../../services/learning_path_service.dart';
// import '../home3/LessonListPage.dart';
//
// class LearningPathDetailPage extends StatefulWidget {
//   final String pathId;
//
//   const LearningPathDetailPage({super.key, required this.pathId});
//
//   @override
//   State<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
// }
//
// class _LearningPathDetailPageState extends State<LearningPathDetailPage> {
//   bool isLoading = true;
//   bool isProcessing = false;
//   String? error;
//   LearningPathModel? path;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDetail();
//   }
//
//   Future<void> _loadDetail() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//
//     try {
//       final result = await LearningPathService.getDetail(widget.pathId);
//       if (!mounted) return;
//       setState(() {
//         path = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _handleEnroll() async {
//     setState(() => isProcessing = true);
//     try {
//       final ok = await LearningPathService.enroll(widget.pathId);
//       if (ok) {
//         await _loadDetail();
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Đăng ký lộ trình thành công")),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi: $e")),
//       );
//     } finally {
//       if (mounted) setState(() => isProcessing = false);
//     }
//   }
//
//   Future<void> _handleUnenroll() async {
//     setState(() => isProcessing = true);
//     try {
//       final ok = await LearningPathService.unenroll(widget.pathId);
//       if (ok) {
//         await _loadDetail();
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Đã hủy theo dõi lộ trình")),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi: $e")),
//       );
//     } finally {
//       if (mounted) setState(() => isProcessing = false);
//     }
//   }
//
//   void _openCourse(LearningPathStepModel step) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => LessonListPage(
//           courseId: step.courseId,
//           courseTitle: step.courseTitle,
//         ),
//       ),
//     ).then((_) => _loadDetail());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final enrolled = path?.enrollStatus != null;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         elevation: 0,
//         title: const Text(
//           "Learning Path Detail",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//           ? Center(child: Text(error!, textAlign: TextAlign.center))
//           : path == null
//           ? const Center(child: Text("No data"))
//           : RefreshIndicator(
//         onRefresh: _loadDetail,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 path!.title,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: theme.textTheme.titleLarge?.color,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 path!.description,
//                 style: const TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   _chip(path!.languageName),
//                   _chip(path!.targetLevel),
//                   _chip("${path!.estimatedHours} hours"),
//                   _chip("${path!.totalSteps} steps"),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               if (path!.progressPercent != null)
//                 LinearProgressIndicator(
//                   value: (path!.progressPercent! / 100).clamp(0, 1),
//                   minHeight: 8,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               if (path!.progressPercent != null) ...[
//                 const SizedBox(height: 8),
//                 Text("Progress: ${path!.progressPercent}%"),
//               ],
//               const SizedBox(height: 18),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: isProcessing
//                       ? null
//                       : enrolled
//                       ? _handleUnenroll
//                       : _handleEnroll,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: enrolled
//                         ? Colors.redAccent
//                         : const Color(0xFF5F2EFF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: isProcessing
//                       ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                       : Text(
//                     enrolled ? "Unenroll" : "Enroll",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 "Path Steps",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: theme.textTheme.titleLarge?.color,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ...path!.steps.map((step) {
//                 return GestureDetector(
//                   onTap: step.isUnlocked ? () => _openCourse(step) : null,
//                   child: Opacity(
//                     opacity: step.isUnlocked ? 1 : 0.55,
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: theme.cardColor,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: step.isUnlocked
//                               ? Colors.transparent
//                               : Colors.orange.withOpacity(0.4),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: step.isUnlocked
//                                   ? const Color(0xFF5F2EFF).withOpacity(0.1)
//                                   : Colors.grey.withOpacity(0.15),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "${step.stepOrder}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: step.isUnlocked
//                                       ? const Color(0xFF5F2EFF)
//                                       : Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   step.courseTitle,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                     color: theme.textTheme.titleMedium?.color,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "${step.courseLevel} • ${step.totalLessons} lessons",
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 if (step.note != null &&
//                                     step.note!.trim().isNotEmpty) ...[
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     step.note!,
//                                     style: const TextStyle(
//                                       color: Colors.blueGrey,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                                 const SizedBox(height: 6),
//                                 LinearProgressIndicator(
//                                   value: (step.courseProgressPercent / 100)
//                                       .clamp(0, 1),
//                                   minHeight: 6,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   step.isUnlocked
//                                       ? "Course progress: ${step.courseProgressPercent}%"
//                                       : "Locked until previous required step is completed",
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     color: step.isUnlocked
//                                         ? Colors.grey
//                                         : Colors.orange,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Icon(
//                             step.isUnlocked
//                                 ? Icons.arrow_forward_ios
//                                 : Icons.lock_outline,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _chip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF5F2EFF).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Color(0xFF5F2EFF),
//           fontWeight: FontWeight.w600,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }




//bản sửa % chuẩn
import 'package:flutter/material.dart';
import '../../models/learning_path_model.dart';
import '../../models/lesson_model.dart';
import '../../services/learning_path_service.dart';
import '../../services/lesson_service.dart';
import '../home3/LessonListPage.dart';

class LearningPathDetailPage extends StatefulWidget {
  final String pathId;

  const LearningPathDetailPage({super.key, required this.pathId});

  @override
  State<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
}

class _LearningPathDetailPageState extends State<LearningPathDetailPage> {
  bool isLoading = true;
  bool isProcessing = false;
  String? error;
  LearningPathModel? path;

  /// progress thật của từng course trong path
  final Map<String, int> _stepProgressMap = {};

  /// progress thật của cả path
  int _pathProgressPercent = 0;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await LearningPathService.getDetail(widget.pathId);

      final Map<String, int> computedStepProgress = {};

      for (final step in result.steps) {
        try {
          final List<Lesson> lessons =
          await LessonService.getLessonsByCourse(step.courseId);

          final int totalLessons = lessons.length;

          if (totalLessons == 0) {
            computedStepProgress[step.courseId] = 0;
            continue;
          }

          final int completedLessons = lessons
              .where((lesson) => lesson.progressStatus == "COMPLETED")
              .length;

          final int percent =
          ((completedLessons / totalLessons) * 100).round();

          computedStepProgress[step.courseId] = percent.clamp(0, 100);
        } catch (e) {
          debugPrint(
            "Error computing progress for step ${step.courseId}: $e",
          );

          /// fallback nếu lỗi
          computedStepProgress[step.courseId] =
              step.courseProgressPercent.clamp(0, 100);
        }
      }

      int computedPathProgress = 0;
      if (result.steps.isNotEmpty) {
        int totalPercent = 0;
        for (final step in result.steps) {
          totalPercent +=
              computedStepProgress[step.courseId] ??
                  step.courseProgressPercent.clamp(0, 100);
        }
        computedPathProgress = (totalPercent / result.steps.length).round();
      }

      if (!mounted) return;

      setState(() {
        path = result;
        _stepProgressMap
          ..clear()
          ..addAll(computedStepProgress);
        _pathProgressPercent = computedPathProgress.clamp(0, 100);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  int _getStepProgress(LearningPathStepModel step) {
    return _stepProgressMap[step.courseId] ??
        step.courseProgressPercent.clamp(0, 100);
  }

  Future<void> _handleEnroll() async {
    setState(() => isProcessing = true);
    try {
      final ok = await LearningPathService.enroll(widget.pathId);
      if (ok) {
        await _loadDetail();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký lộ trình thành công")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  Future<void> _handleUnenroll() async {
    setState(() => isProcessing = true);
    try {
      final ok = await LearningPathService.unenroll(widget.pathId);
      if (ok) {
        await _loadDetail();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã hủy theo dõi lộ trình")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _openCourse(LearningPathStepModel step) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonListPage(
          courseId: step.courseId,
          courseTitle: step.courseTitle,
        ),
      ),
    ).then((_) => _loadDetail());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enrolled = path?.enrollStatus != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        title: const Text(
          "Learning Path Detail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!, textAlign: TextAlign.center))
          : path == null
          ? const Center(child: Text("No data"))
          : RefreshIndicator(
        onRefresh: _loadDetail,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                path!.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                path!.description,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _chip(path!.languageName),
                  _chip(path!.targetLevel),
                  _chip("${path!.estimatedHours} hours"),
                  _chip("${path!.totalSteps} steps"),
                ],
              ),
              const SizedBox(height: 16),

              LinearProgressIndicator(
                value: (_pathProgressPercent / 100).clamp(0.0, 1.0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 8),
              Text("Progress: $_pathProgressPercent%"),

              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : enrolled
                      ? _handleUnenroll
                      : _handleEnroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: enrolled
                        ? Colors.redAccent
                        : const Color(0xFF5F2EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    enrolled ? "Unenroll" : "Enroll",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Path Steps",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12),

              ...path!.steps.map((step) {
                final int stepProgress = _getStepProgress(step);

                return GestureDetector(
                  onTap: step.isUnlocked ? () => _openCourse(step) : null,
                  child: Opacity(
                    opacity: step.isUnlocked ? 1 : 0.55,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: step.isUnlocked
                              ? Colors.transparent
                              : Colors.orange.withOpacity(0.4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: step.isUnlocked
                                  ? const Color(0xFF5F2EFF)
                                  .withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${step.stepOrder}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: step.isUnlocked
                                      ? const Color(0xFF5F2EFF)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.courseTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: theme.textTheme.titleMedium?.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${step.courseLevel} • ${step.totalLessons} lessons",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                if (step.note != null &&
                                    step.note!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    step.note!,
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: (stepProgress / 100)
                                      .clamp(0.0, 1.0),
                                  minHeight: 6,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  step.isUnlocked
                                      ? "Course progress: $stepProgress%"
                                      : "Locked until previous required step is completed",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: step.isUnlocked
                                        ? Colors.grey
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            step.isUnlocked
                                ? Icons.arrow_forward_ios
                                : Icons.lock_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5F2EFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF5F2EFF),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}