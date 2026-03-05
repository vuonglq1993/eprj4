import 'package:flutter/material.dart';
import '../services/fake_auth.dart';
import 'language_selection_page.dart';

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
    // Lấy thông tin user từ FakeAuth
    final String displayUserName = FakeAuth.userName ?? "Guest";
    final String firstLetter = displayUserName.isNotEmpty
        ? displayUserName[0].toUpperCase()
        : "?";

    return Scaffold(
      backgroundColor: Colors.white,
      // SỬ DỤNG APPBAR ĐỂ ĐẢM BẢO ĐỘ DÀI VÀ KÍCH THƯỚC CHUẨN 100% VỚI CÁC TRANG KHÁC
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        centerTitle: true,
        // Nút Back chuẩn
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: onBack,
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // Không cần set fontSize vì AppBar mặc định đã chuẩn với các trang khác
          ),
        ),
        // Nút Settings chuẩn bên phải
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: onOpenSettings,
          ),
          const SizedBox(width: 8), // Tạo khoảng cách nhỏ ở biên phải
        ],
      ),
      body: Column(
        children: [
          // ================= PHẦN NỘI DUNG USER (NỀN TRẮNG) =================
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 35), // Khoảng cách từ Header xuống Avatar

                  // AVATAR
                  Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFF121943),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // TÊN NGƯỜI DÙNG
                  Text(
                    displayUserName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    "Joined March 2023",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 25),

                  // Nút Add Language
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
                      "Add Language  +",
                      style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Divider(indent: 30, endIndent: 30, color: Color(0xFFF1F1F1)),
                  ),

                  // --- My Activity & Achievement ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildSectionHeader("My Activity", onOpenActivity),
                        const SizedBox(height: 15),
                        _buildActivityCard(),
                        const SizedBox(height: 35),
                        _buildSectionHeader("Achievement", () {}),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(child: _buildAchievementCard("German Language", "Level 1", "🇩🇪")),
                            const SizedBox(width: 15),
                            Expanded(child: _buildAchievementCard("Spanish Language", "Level 2", "🇪🇸")),
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
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: const Text("View All", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time_filled, color: Colors.red, size: 22),
              SizedBox(width: 12),
              Text("8h : 20 min", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
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

  Widget _buildAchievementCard(String title, String level, String flagEmoji) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Text(flagEmoji, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}