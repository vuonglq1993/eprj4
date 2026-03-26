import 'package:flutter/material.dart';
// Import theme_notifier để lắng nghe trạng thái đổi màu
import '../homepagesetting/theme_notifier.dart';

class ProgressPage extends StatefulWidget {
  final VoidCallback onBack;

  const ProgressPage({super.key, required this.onBack});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  String selectedLanguage = "German";

  final List<String> languages = [
    "English", "French", "German", "Hindi", "Korean",
    "Bengali", "Italian", "Spanish", "Vietnamese", "Japanese",
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Lắng nghe themeNotifier
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          // 2. Sử dụng màu nền từ Theme
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím đặc trưng
            elevation: 0,
            centerTitle: true,
            title: const Text("Progress",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: widget.onBack,
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Course",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleMedium?.color)),
                const SizedBox(height: 10),

                // ================= DROPDOWN =================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    // Đổi màu nền card cho dropdown
                    color: theme.cardColor,
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      isExpanded: true,
                      // Đổi màu nền menu dropdown khi sổ xuống
                      dropdownColor: theme.cardColor,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent),
                      items: languages.map((String item) {
                        return DropdownMenuItem(
                            value: item,
                            child: Text(item,
                                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500))
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
                    Text("Progress",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color)),
                    const Row(
                      children: [
                        Text("This Week", style: TextStyle(color: Colors.grey)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ================= BIỂU ĐỒ CỘT =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(60, "Mon", false, theme),
                    _buildBar(80, "Tue", false, theme),
                    _buildBar(50, "Wed", false, theme),
                    _buildBar(100, "Thur", true, theme),
                    _buildBar(40, "Fri", false, theme),
                    _buildBar(110, "Sat", false, theme),
                    _buildBar(55, "Sun", false, theme),
                  ],
                ),

                const SizedBox(height: 30),
                Text("Completed Task",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color)),
                const SizedBox(height: 15),

                // ================= DANH SÁCH BÀI HỌC =================
                _buildTaskItem("Erater Tag in Berlin", "Lesson 1", true, theme),
                _buildTaskItem("First Steps", "Lesson 2", false, theme),
                _buildTaskItem("Vocabulary", "Lesson 3", false, theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBar(double height, String day, bool isActive, ThemeData theme) {
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
                // Nếu không active, dùng màu xám của theme
                color: isActive ? Colors.orange : theme.disabledColor.withOpacity(0.2),
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

  Widget _buildTaskItem(String title, String sub, bool isChecked, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor, // Đổi màu card theo theme
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF), size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.textTheme.titleMedium?.color)),
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



// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/token_service.dart';
// import '../../models/course_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'lesson_list_page.dart';
//
// // Lưu ý: Đảm bảo class Course trong course_model.dart có factory Course.fromJson khớp với Backend
//
// class ProgressPage extends StatefulWidget {
//   final VoidCallback onBack;
//
//   const ProgressPage({super.key, required this.onBack});
//
//   @override
//   State<ProgressPage> createState() => _ProgressPageState();
// }
//
// class _ProgressPageState extends State<ProgressPage> {
//   List<Course> courses = [];
//   Course? selectedCourse;
//   bool isLoading = true;
//
//   // Giả lập dữ liệu tuần (Sau này bạn có thể nối API thống kê học tập riêng)
//   final List<Map<String, dynamic>> weeklyData = [
//     {"day": "Mon", "value": 30.0},
//     {"day": "Tue", "value": 45.0},
//     {"day": "Wed", "value": 20.0},
//     {"day": "Thu", "value": 60.0},
//     {"day": "Fri", "value": 75.0},
//     {"day": "Sat", "value": 40.0},
//     {"day": "Sun", "value": 55.0},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCourses();
//   }
//
//   Future<void> fetchCourses() async {
//     const String apiUrl = "http://10.0.2.2:8080/api/v1/courses";
//     try {
//       final token = await TokenService.getToken();
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(utf8.decode(response.bodyBytes));
//         // Lấy list từ content của PageResponse
//         final List list = data['content'] ?? [];
//
//         setState(() {
//           courses = list.map((e) => Course.fromJson(e)).toList();
//           if (courses.isNotEmpty) {
//             selectedCourse = courses[0];
//           }
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load courses");
//       }
//     } catch (e) {
//       print("Error fetching courses: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Progress",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : courses.isEmpty
//               ? const Center(child: Text("No courses found in database"))
//               : RefreshIndicator(
//             onRefresh: fetchCourses,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ================= DROPDOWN =================
//                   Text("Select Course",
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleMedium?.color)),
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: theme.cardColor,
//                       border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedCourse?.id,
//                         isExpanded: true,
//                         dropdownColor: theme.cardColor,
//                         icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent),
//                         items: courses.map((course) {
//                           return DropdownMenuItem(
//                             value: course.id,
//                             child: Text(course.title,
//                                 style: const TextStyle(
//                                     color: Colors.blueAccent,
//                                     fontWeight: FontWeight.w500)),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCourse = courses.firstWhere((c) => c.id == value);
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 25),
//
//                   // ================= CHART HEADER =================
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Weekly Activity",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: theme.textTheme.titleLarge?.color)),
//                       const Text("This Week", style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//
//                   const SizedBox(height: 40),
//
//                   // ================= BIỂU ĐỒ =================
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: weeklyData.map((item) {
//                       // Logic: Cột cao nhất sẽ có màu cam
//                       double maxVal = weeklyData.map((e) => e["value"] as double).reduce((a, b) => a > b ? a : b);
//                       bool isActive = item["value"] == maxVal;
//
//                       return _buildBar(item["value"].toDouble(), item["day"], isActive, theme);
//                     }).toList(),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // ================= TRẠNG THÁI KHÓA HỌC CHỌN =================
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           "${selectedCourse?.progressPercent ?? 0}%",
//                           style: const TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange),
//                         ),
//                         const SizedBox(height: 5),
//                         Text("${selectedCourse?.title} Progress",
//                             style: const TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   // ================= LIST TẤT CẢ KHÓA HỌC =================
//                   Text("All Courses",
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color)),
//                   const SizedBox(height: 15),
//                   Column(
//                     children: courses.map((course) {
//                       return _buildCourseItem(course, theme);
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBar(double height, String day, bool isActive, ThemeData theme) {
//     return Column(
//       children: [
//         Container(
//           width: 25,
//           height: height,
//           decoration: BoxDecoration(
//             color: isActive ? Colors.orange : theme.disabledColor.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(6),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }
//
//   Widget _buildCourseItem(Course course, ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 5))
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.menu_book, color: Color(0xFF5F2EFF), size: 40),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(course.title,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         color: theme.textTheme.titleMedium?.color)),
//                 Text(course.level,
//                     style: const TextStyle(color: Colors.grey, fontSize: 13)),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: Colors.orange.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               "${course.progressPercent}%",
//               style: const TextStyle(
//                   color: Colors.orange, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }