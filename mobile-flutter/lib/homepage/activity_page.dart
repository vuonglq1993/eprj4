import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC), // Nền xám nhạt đồng bộ app
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Activity",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined, color: Colors.white)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TABS SELECTOR =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                ),
                child: Row(
                  children: [
                    _buildTabItem("Daily", false),
                    _buildTabItem("Weekly", true), // Đang chọn Weekly
                    _buildTabItem("Monthly", false),
                  ],
                ),
              ),
            ),

            // ================= CHART SECTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Learning Hours",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: ActivityChartPainter(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Chú thích các thứ trong tuần
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                          .map((day) => Text(day,
                          style: const TextStyle(color: Colors.grey, fontSize: 12)
                      )).toList(),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ================= SUMMARY SECTION =================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text("Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: _buildSummaryCard(
                          "Total time",
                          "10 hr 20min",
                          Icons.access_time_filled,
                          const Color(0xFF5F2EFF), // Màu tím
                          const Color(0xFFF0EDFF)
                      )
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildSummaryCard(
                          "Courses",
                          "4 Courses",
                          Icons.auto_awesome,
                          Colors.orange,
                          const Color(0xFFFFF4E6)
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14
            )
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

// Lớp vẽ biểu đồ chuyên nghiệp với Gradient Fill
class ActivityChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Vẽ đường cong chính (Stroke)
    var paint = Paint()
      ..color = const Color(0xFF5F2EFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
        size.width * 0.2, size.height * 0.8,
        size.width * 0.3, size.height * 0.2,
        size.width * 0.5, size.height * 0.4
    );
    path.cubicTo(
        size.width * 0.7, size.height * 0.6,
        size.width * 0.8, size.height * 0.1,
        size.width, size.height * 0.3
    );

    // 2. Vẽ vùng Gradient phía dưới
    var fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    var fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF5F2EFF).withOpacity(0.3),
          const Color(0xFF5F2EFF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // 3. Vẽ điểm nhấn (Indicator) tại vị trí cao nhất
    var pointPaint = Paint()..color = const Color(0xFF5F2EFF);
    var glowPaint = Paint()..color = const Color(0xFF5F2EFF).withOpacity(0.2);

    Offset indicatorPos = Offset(size.width * 0.8, size.height * 0.1);
    canvas.drawCircle(indicatorPos, 12, glowPaint); // Vòng mờ bên ngoài
    canvas.drawCircle(indicatorPos, 6, pointPaint); // Điểm đậm bên trong
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}