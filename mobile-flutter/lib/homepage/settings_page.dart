import 'package:flutter/material.dart';
import 'language_selection_page.dart'; // File mới tạo bên dưới
import 'invite_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsItem(context, "Edit Profile", Icons.person_outline, Colors.blue, () {}),
          _buildSettingsItem(context, "Settings", Icons.settings_outlined, Colors.orange, () {}),
          // Mục My Languages dẫn đến danh sách chọn ngôn ngữ
          _buildSettingsItem(context, "My Languages", Icons.language, Colors.blueAccent, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSelectionPage()));
          }),
          // Mục Invite Friends đặt tại đây theo ý bạn
          _buildSettingsItem(context, "Invite Friends", Icons.people_outline, Colors.orangeAccent, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InvitePage()));
          }),
          _buildSettingsItem(context, "Help", Icons.help_outline, Colors.lightBlue, () {}),
          _buildSettingsItem(context, "Get Access", Icons.lock_open, Colors.redAccent, () {}),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}