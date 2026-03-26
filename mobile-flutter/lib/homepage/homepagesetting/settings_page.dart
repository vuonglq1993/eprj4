import 'package:flutter/material.dart';
import '../home4/profile_page.dart';
import 'language_selection_page.dart';
import 'invite_page.dart';
import 'edit_profile_page.dart';
import 'subscription_page.dart';
import 'help_chat_page.dart';
import 'app_settings_page.dart';
// Đảm bảo import theme_notifier
import 'theme_notifier.dart';
import 'Profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lắng nghe themeNotifier để cập nhật giao diện tức thì
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          // 2. Sử dụng màu nền từ Theme thay vì Colors.white
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
                "Settings",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ),

          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSettingsItem(context, "Profile", Icons.person_outline, Colors.blue, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Profile()));
              }),
              _buildSettingsItem(context, "Settings", Icons.settings_outlined, Colors.orange, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsPage()));
              }),
              _buildSettingsItem(context, "My Languages", Icons.language, Colors.blueAccent, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionPage()));
              }),
              _buildSettingsItem(context, "Invite Friends", Icons.people_outline, Colors.orangeAccent, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const InvitePage()));
              }),
              _buildSettingsItem(context, "Help", Icons.help_outline, Colors.lightBlue, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpChatPage()));
              }),
              _buildSettingsItem(context, "Subscription", Icons.lock_open, Colors.redAccent, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, Color iconColor, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: theme.cardColor, // Sử dụng màu card của Theme
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // SỬA LỖI Ở ĐÂY: Màu nền icon thay đổi theo mode
            color: isDark ? iconColor.withOpacity(0.15) : iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color // Màu chữ tự động Đen/Trắng
            )
        ),
        trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.disabledColor.withOpacity(0.3)
        ),
        onTap: onTap,
      ),
    );
  }
}