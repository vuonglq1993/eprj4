// import 'package:flutter/material.dart';
// import '../homepagesetting/settings_page.dart';
// import '../homepagesetting/theme_notifier.dart';
//
// class ActivityPage extends StatelessWidget {
//   const ActivityPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//         final isDark = mode == ThemeMode.dark;
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: const Text(
//               "Activity",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.settings_outlined, color: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SettingsPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ================= TABS SELECTOR =================
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: theme.cardColor,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         )
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         _buildTabItem("Daily", false),
//                         _buildTabItem("Weekly", true),
//                         _buildTabItem("Monthly", false),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // ================= CHART SECTION =================
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: theme.cardColor,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Learning Hours",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: theme.textTheme.titleMedium?.color,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         SizedBox(
//                           height: 180,
//                           width: double.infinity,
//                           child: CustomPaint(
//                             painter: ActivityChartPainter(isDark: isDark),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
//                               .map((day) => Text(
//                             day,
//                             style: const TextStyle(color: Colors.grey, fontSize: 12),
//                           ))
//                               .toList(),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 // ================= SUMMARY SECTION =================
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Text(
//                     "Summary",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: theme.textTheme.titleLarge?.color,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildSummaryCard(
//                           context,
//                           "Total time",
//                           "10 hr 20min",
//                           Icons.access_time_filled,
//                           const Color(0xFF5F2EFF),
//                           isDark ? const Color(0xFF2A244D) : const Color(0xFFF0EDFF),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: _buildSummaryCard(
//                           context,
//                           "Courses",
//                           "4 Courses",
//                           Icons.auto_awesome,
//                           Colors.orange,
//                           isDark ? const Color(0xFF3D2C1E) : const Color(0xFFFFF4E6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTabItem(String text, bool isSelected) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSummaryCard(
//       BuildContext context,
//       String title,
//       String value,
//       IconData icon,
//       Color iconColor,
//       Color iconBgColor,
//       ) {
//     final theme = Theme.of(context);
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(themeNotifier.value == ThemeMode.dark ? 0.2 : 0.03),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
//             child: Icon(icon, color: iconColor, size: 22),
//           ),
//           const SizedBox(height: 15),
//           const Text("Total time", style: TextStyle(color: Colors.grey, fontSize: 13)),
//           const SizedBox(height: 5),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: theme.textTheme.titleMedium?.color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ActivityChartPainter extends CustomPainter {
//   final bool isDark;
//   ActivityChartPainter({required this.isDark});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // 1. Cấu hình đường nét vẽ
//     var paint = Paint()
//       ..color = const Color(0xFF5F2EFF)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4
//       ..strokeCap = StrokeCap.round;
//
//     var path = Path();
//     path.moveTo(0, size.height * 0.7);
//     path.cubicTo(
//         size.width * 0.2, size.height * 0.8,
//         size.width * 0.3, size.height * 0.2,
//         size.width * 0.5, size.height * 0.4
//     );
//     path.cubicTo(
//         size.width * 0.7, size.height * 0.6,
//         size.width * 0.8, size.height * 0.1,
//         size.width, size.height * 0.3
//     );
//
//     // 2. Vẽ vùng Gradient đổ bóng phía dưới
//     var fillPath = Path.from(path);
//     fillPath.lineTo(size.width, size.height);
//     fillPath.lineTo(0, size.height);
//     fillPath.close();
//
//     var fillPaint = Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           const Color(0xFF5F2EFF).withOpacity(isDark ? 0.4 : 0.3),
//           const Color(0xFF5F2EFF).withOpacity(0.0),
//         ],
//       ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
//
//     canvas.drawPath(fillPath, fillPaint);
//     canvas.drawPath(path, paint);
//
//     // 3. Vẽ điểm nhấn dữ liệu (Indicator)
//     var pointPaint = Paint()..color = const Color(0xFF5F2EFF);
//     var glowPaint = Paint()..color = const Color(0xFF5F2EFF).withOpacity(isDark ? 0.4 : 0.2);
//
//     Offset indicatorPos = Offset(size.width * 0.8, size.height * 0.1);
//     canvas.drawCircle(indicatorPos, 12, glowPaint);
//     canvas.drawCircle(indicatorPos, 6, pointPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant ActivityChartPainter oldDelegate) => oldDelegate.isDark != isDark;
// }







import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/stats_model.dart';
import '../../services/progress_service.dart';
import '../homepagesetting/settings_page.dart';
import '../homepagesetting/theme_notifier.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String selectedPeriod = "WEEK";
  bool isLoading = true;
  String? errorMessage;
  StatsResponse? stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats({String? period}) async {
    final targetPeriod = period ?? selectedPeriod;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ProgressApiService.getStats(targetPeriod);

      if (!mounted) return;

      setState(() {
        selectedPeriod = targetPeriod;
        stats = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = "Lỗi tải thống kê: $e";
        isLoading = false;
      });
    }
  }

  String _formatMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    }
    return "${minutes}m";
  }

  List<FlSpot> _buildSpots() {
    if (stats == null || stats!.data.isEmpty) return [];
    return List.generate(
      stats!.data.length,
          (index) => FlSpot(index.toDouble(), stats!.data[index].studyMinutes.toDouble()),
    );
  }

  double _maxY() {
    if (stats == null || stats!.data.isEmpty) return 10;
    final maxValue = stats!.data
        .map((e) => e.studyMinutes.toDouble())
        .reduce((a, b) => a > b ? a : b);
    return maxValue <= 10 ? 10 : (maxValue + 10).ceilToDouble();
  }

  String _titleByPeriod() {
    switch (selectedPeriod) {
      case "MONTH":
        return "Learning Time This Month";
      case "YEAR":
        return "Learning Time This Year";
      default:
        return "Learning Time This Week";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
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
              "Activity",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : RefreshIndicator(
            onRefresh: () => _loadStats(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildTabItem("Week", "WEEK"),
                          _buildTabItem("Month", "MONTH"),
                          _buildTabItem("Year", "YEAR"),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titleByPeriod(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: (stats!.data.length - 1).toDouble(),
                                minY: 0,
                                maxY: _maxY(),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: _maxY() / 4,
                                ),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 36,
                                      interval: _maxY() / 4,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 || index >= stats!.data.length) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            stats!.data[index].label,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        final item = stats!.data[spot.x.toInt()];
                                        return LineTooltipItem(
                                          "${item.studyMinutes} min",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _buildSpots(),
                                    isCurved: true,
                                    barWidth: 4,
                                    dotData: const FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFF5F2EFF).withOpacity(
                                            isDark ? 0.30 : 0.20,
                                          ),
                                          const Color(0xFF5F2EFF).withOpacity(0.02),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            "Total time",
                            _formatMinutes(stats!.totalMinutes),
                            Icons.access_time_filled,
                            const Color(0xFF5F2EFF),
                            isDark
                                ? const Color(0xFF2A244D)
                                : const Color(0xFFF0EDFF),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            "Lessons",
                            "${stats!.totalLessons} lessons",
                            Icons.auto_awesome,
                            Colors.orange,
                            isDark
                                ? const Color(0xFF3D2C1E)
                                : const Color(0xFFFFF4E6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSummaryCard(
                      context,
                      "Average score",
                      "${stats!.averageScore.toStringAsFixed(1)}%",
                      Icons.star,
                      Colors.amber,
                      isDark
                          ? const Color(0xFF3B3220)
                          : const Color(0xFFFFF8E1),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(String text, String periodValue) {
    final isSelected = selectedPeriod == periodValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => _loadStats(period: periodValue),
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
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color iconColor,
      Color iconBgColor,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              themeNotifier.value == ThemeMode.dark ? 0.2 : 0.03,
            ),
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
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}