import 'package:flutter/material.dart';

// class TaskPage extends StatelessWidget {
//   const TaskPage({super.key});
class TaskPage extends StatelessWidget {
  final VoidCallback onBack;

  const TaskPage({super.key, required this.onBack});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      // AppBar THẲNG - Không bo góc
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        centerTitle: true,
        title: const Text("Task", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            // Backup về trang Home (Trang đầu tiên trong stack)
            // Navigator.of(context).popUntil((route) => route.isFirst);
            onBack();
          },
        ),
      ),
      body: Column(
        children: [
          // ================= CHỌN NGÀY THÁNG =================
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("January 19, 2023",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Icon(Icons.calendar_month_outlined, color: Colors.grey.shade400),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateItem("Sat", "17", false),
                    _buildDateItem("Sun", "17", false),
                    _buildDateItem("Mon", "18", false),
                    _buildDateItem("Tue", "19", true), // Ngày đang chọn
                    _buildDateItem("Wed", "20", false),
                    _buildDateItem("Thu", "21", false),
                  ],
                ),
              ],
            ),
          ),

          // ================= LỊCH TRÌNH TIMELINE =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              children: [
                _buildTimelineRow("08:00"),
                _buildTimelineRow("09:00",
                    task: _buildTaskCard("German Language", "Remaining 5 Task", const Color(0xFF62A98D), Icons.language)),
                _buildTimelineRow("10:00"),
                _buildTimelineRow("11:00"),
                _buildTimelineRow("12:00",
                    task: _buildTaskCard("Spanish Language", "Remaining 20 Tasks", Colors.orange, Icons.language)),
                _buildTimelineRow("13:00"),
                _buildTimelineRow("14:00"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, bool isSelected) {
    return Column(
      children: [
        Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? null : Border.all(color: Colors.grey.shade100),
          ),
          child: Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineRow(String time, {Widget? task}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          child: Column(
            children: [
              if (task != null) task else const SizedBox(height: 60),
              const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(String title, String sub, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
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
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}