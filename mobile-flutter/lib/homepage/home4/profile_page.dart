import 'package:flutter/material.dart';
import '../../services/fake_auth.dart';
import '../homepagesetting/language_selection_page.dart';
// Import theme_notifier để lắng nghe trạng thái đổi màu
import '../homepagesetting/theme_notifier.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenActivity;
  final VoidCallback onOpenSettings;

  const ProfilePage({
    super.key,
    required this.onBack,
    required this.onOpenActivity,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Lắng nghe themeNotifier
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        final String displayUserName = FakeAuth.userName ?? "Guest";

        return Scaffold(
          // 2. Sử dụng màu nền từ Theme
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím thương hiệu
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: onBack,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: onOpenSettings,
              ),
              const SizedBox(width: 8),
            ],
          ),

          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),

                      // AVATAR
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: theme.cardColor,
                        backgroundImage: FakeAuth.avatar != null
                            ? FileImage(FakeAuth.avatar!)
                            : const NetworkImage("https://i.pravatar.cc/150?img=3") as ImageProvider,
                      ),

                      const SizedBox(height: 15),

                      // TÊN NGƯỜI DÙNG
                      Text(
                        displayUserName,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color // Tự động Đen/Trắng
                        ),
                      ),

                      const Text(
                        "Joined March 2023",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),

                      const SizedBox(height: 25),

                      // NÚT ADD LANGUAGE
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF5F2EFF), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        ),
                        child: const Text(
                          "My Languages",
                          style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold),
                        ),
                      ),

                      // 3. Cập nhật màu Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Divider(
                            indent: 30,
                            endIndent: 30,
                            color: theme.dividerColor.withOpacity(0.1)
                        ),
                      ),

                      // --- My Activity & Achievement ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildSectionHeader("My Activity", onOpenActivity, theme),
                            const SizedBox(height: 15),
                            _buildActivityCard(theme, isDark),
                            const SizedBox(height: 35),
                            _buildSectionHeader("Achievement", () {}, theme),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(child: _buildAchievementCard("German Language", "Level 1", "🇩🇪", theme)),
                                const SizedBox(width: 15),
                                Expanded(child: _buildAchievementCard("Spanish Language", "Level 2", "🇪🇸", theme)),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleMedium?.color
            )),
        GestureDetector(
          onTap: onTap,
          child: const Text("View All",
              style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildActivityCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // 4. Thay đổi màu xám sáng cố định thành màu card hoặc màu nền tối hơn một chút
        color: isDark ? theme.cardColor : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled, color: Colors.red, size: 22),
              const SizedBox(width: 12),
              Text("8h : 20 min",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: theme.textTheme.bodyLarge?.color
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              // Màu nền của nút chọn tuần
                color: isDark ? Colors.white10 : Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: const Row(
              children: [
                Text("This Week", style: TextStyle(color: Color(0xFF4B00D1), fontSize: 12, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF4B00D1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, String level, String flagEmoji, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: theme.cardColor, // Đổi theo theme
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(flagEmoji, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: theme.textTheme.titleSmall?.color
              )),
          Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}