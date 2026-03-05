import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  final List<Map<String, String>> languages = const [
    {"name": "English", "flag": "🇺🇸"},
    {"name": "Vietnamese", "flag": "🇻🇳"},
    {"name": "French", "flag": "🇫🇷"},
    {"name": "German", "flag": "🇩🇪"},
    {"name": "Spanish", "flag": "🇪🇸"},
    {"name": "Japanese", "flag": "🇯🇵"},
    {"name": "Korean", "flag": "🇰🇷"},
    {"name": "Chinese", "flag": "🇨🇳"},
    {"name": "Russian", "flag": "🇷🇺"},
    {"name": "Italian", "flag": "🇮🇹"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Màu tím đậm đồng bộ với Task và Settings
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        centerTitle: true,
        // Nút back màu trắng, kiểu iOS giống trang Settings
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
            "Select Language",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: languages.length,
        separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F1F1), height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            leading: Text(
                languages[index]['flag']!,
                style: const TextStyle(fontSize: 26)
            ),
            title: Text(
                languages[index]['name']!,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF1F1F1F)
                )
            ),
            // Icon tròn chưa chọn màu xám nhạt
            trailing: const Icon(Icons.circle_outlined, color: Colors.grey, size: 22),
            onTap: () {
              // Logic chọn ngôn ngữ
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}