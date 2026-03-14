import 'package:flutter/material.dart';
import '../../quiz/quiz_page.dart';
import '../../data/task_question_data.dart';
import '../../models/question_model.dart';
// Import theme_notifier để lắng nghe trạng thái
import '../homepagesetting/theme_notifier.dart';

class TaskPage extends StatelessWidget {
  final VoidCallback onBack;

  const TaskPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    // 1. Sử dụng ValueListenableBuilder để lắng nghe thay đổi theme
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          // 2. Thay đổi màu nền Scaffold theo theme
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím thương hiệu
            elevation: 0,
            centerTitle: true,
            title: const Text("Task",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: onBack,
            ),
          ),

          body: Column(
            children: [
              // PHẦN LỊCH (CALENDAR)
              Container(
                padding: const EdgeInsets.all(20),
                // 3. Đổi màu nền container lịch
                color: theme.cardColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("January 19, 2023",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color // Màu chữ theo theme
                            )),
                        Icon(Icons.calendar_month_outlined,
                            color: isDark ? Colors.grey[500] : Colors.grey.shade400),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateItem("Sat", "17", false, theme),
                        _buildDateItem("Sun", "17", false, theme),
                        _buildDateItem("Mon", "18", false, theme),
                        _buildDateItem("Tue", "19", true, theme),
                        _buildDateItem("Wed", "20", false, theme),
                        _buildDateItem("Thu", "21", false, theme),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  children: [
                    _buildTimelineRow("08:00", theme),

                    _buildTimelineRow(
                      "09:00",
                      theme,
                      task: _buildTaskCard(
                        context,
                        "German Language",
                        "Remaining 5 Task",
                        const Color(0xFF62A98D),
                        Icons.language,
                        germanQuestions,
                      ),
                    ),

                    _buildTimelineRow("10:00", theme),
                    _buildTimelineRow("11:00", theme),

                    _buildTimelineRow(
                      "12:00",
                      theme,
                      task: _buildTaskCard(
                        context,
                        "Spanish Language",
                        "Remaining 20 Tasks",
                        Colors.orange,
                        Icons.language,
                        germanQuestions,
                      ),
                    ),

                    _buildTimelineRow("13:00", theme),
                    _buildTimelineRow("14:00", theme),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateItem(String day, String date, bool isSelected, ThemeData theme) {
    return Column(
      children: [
        Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            date,
            style: TextStyle(
              // Nếu chọn thì màu trắng, không chọn thì lấy màu body của theme
              color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineRow(String time, ThemeData theme, {Widget? task}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(time,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          child: Column(
            children: [
              if (task != null) task else const SizedBox(height: 60),
              // 4. Đổi màu đường kẻ Divider
              Divider(thickness: 1, color: theme.dividerColor.withOpacity(0.1)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(
      BuildContext context,
      String title,
      String sub,
      Color color,
      IconData icon,
      List<Question> questions) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizPage(taskQuestions: questions),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color, // Màu đặc trưng của task giữ nguyên để nổi bật
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text(sub,
                    style:
                    const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}