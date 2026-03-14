import 'package:flutter/material.dart';
import '../homepage/home1/homepage.dart';
// 1. Import theme_notifier
import '../homepage//homepagesetting/theme_notifier.dart';

class LessonCompletedPage extends StatelessWidget {
  const LessonCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Lắng nghe thay đổi theme
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          // Sử dụng màu nền từ theme
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.chevron_left,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => _backToHome(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => _backToHome(context),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Biểu tượng vòng tròn cam với dấu tích xanh
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Điều chỉnh màu border cam sáng hơn một chút trong Dark mode nếu cần
                        border: Border.all(color: Colors.orange, width: 8),
                      ),
                    ),
                    const Icon(
                      Icons.check,
                      size: 60,
                      color: Colors.teal,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Text(
                  "Lesson Completed",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color, // Tự động trắng/đen
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "You have completed lesson 1 of the\nDutch language course",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const Spacer(),

                // Nút Back to home màu tím thương hiệu
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => _backToHome(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F2EFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Back to home",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _backToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }
}