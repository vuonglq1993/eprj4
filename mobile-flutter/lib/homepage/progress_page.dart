import 'package:flutter/material.dart';

// class ProgressPage extends StatefulWidget {
//   const ProgressPage({super.key});
class ProgressPage extends StatefulWidget {
  final VoidCallback onBack;

  const ProgressPage({super.key, required this.onBack});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Đảm bảo giá trị khởi tạo nằm trong danh sách languages
  String selectedLanguage = "German";

  final List<String> languages = [
    "English",
    "French",
    "German",
    "Hindi",
    "Korean",
    "Bengali",
    "Italian",
    "Spanish",
    "Vietnamese",
    "Japanese",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      // AppBar THẲNG - Không bo góc
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        centerTitle: true,
        title: const Text("Progress", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            // Quay về trang chủ (xóa hết các trang trong stack nếu cần)
            // Navigator.of(context).popUntil((route) => route.isFirst);
            widget.onBack();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Course",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),

            // ================= DROPDOWN ĐẦY ĐỦ NGÔN NGỮ =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent),
                  items: languages.map((String item) {
                    return DropdownMenuItem(
                        value: item,
                        child: Text(item, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500))
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Row(
                  children: [
                    Text("This Week", style: TextStyle(color: Colors.grey)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40), // Khoảng trống cho bong bóng "31"

            // ================= BIỂU ĐỒ CỘT =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(60, "Mon", false),
                _buildBar(80, "Tue", false),
                _buildBar(50, "Wed", false),
                _buildBar(100, "Thur", true), // Cột đang được chọn
                _buildBar(40, "Fri", false),
                _buildBar(110, "Sat", false),
                _buildBar(55, "Sun", false),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Completed Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // ================= DANH SÁCH BÀI HỌC =================
            _buildTaskItem("Erater Tag in Berlin", "Lesson 1", true),
            _buildTaskItem("First Steps", "Lesson 2", false),
            _buildTaskItem("Vocabulary", "Lesson 3", false),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, String day, bool isActive) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 25,
              height: height,
              decoration: BoxDecoration(
                color: isActive ? Colors.orange : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            if (isActive)
              Positioned(
                top: -30,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  child: const Text("31",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildTaskItem(String title, String sub, bool isChecked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF), size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Icon(isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isChecked ? const Color(0xFF5F2EFF) : Colors.grey.shade300),
        ],
      ),
    );
  }
}