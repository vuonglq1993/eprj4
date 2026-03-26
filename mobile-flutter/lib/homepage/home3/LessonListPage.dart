import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../services/course_service.dart';
import '../homepage/homepagesetting/theme_notifier.dart';
import 'quiz_page.dart';
// import 'lesson_detail_page.dart'; // Import trang chi tiết nếu bạn đã có

class LessonListPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const LessonListPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  late Future<List<dynamic>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách bài học
    _lessonsFuture = CourseService.getLessons(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              widget.courseTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FutureBuilder<List<dynamic>>(
            future: _lessonsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Đã có lỗi xảy ra: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Khóa học này chưa có bài học nào."));
              }

              final lessons = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: lessons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final lessonData = lessons[index];
                  final lesson = Lesson.fromJson(lessonData);
                  final isCompleted = lesson.progressStatus == "COMPLETED";

                  return GestureDetector(
                    onTap: () {
                      // Hùng có thể chọn: Nhấn vào là đi làm Quiz luôn
                      // Hoặc đi vào trang nội dung bài học (LessonDetail) trước
                      _navigateToQuiz(lesson);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(
                          color: isCompleted ? Colors.green.withOpacity(0.5) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Số thứ tự bài học
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.green : const Color(0xFF5F2EFF).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Color(0xFF5F2EFF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Thông tin bài học
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.titleLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${lesson.durationMinutes} phút",
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.assignment_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      lesson.type,
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToQuiz(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          courseId: widget.courseId,
          lessonId: lesson.id,
        ),
      ),
    ).then((_) {
      // Khi từ Quiz quay lại, load lại danh sách để cập nhật tích xanh
      setState(() {
        _lessonsFuture = CourseService.getLessons(widget.courseId);
      });
    });
  }
}