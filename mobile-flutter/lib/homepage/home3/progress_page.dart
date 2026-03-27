// import 'package:flutter/material.dart';
// // Import theme_notifier để lắng nghe trạng thái đổi màu
// import '../homepagesetting/theme_notifier.dart';
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
//   String selectedLanguage = "German";
//
//   final List<String> languages = [
//     "English", "French", "German", "Hindi", "Korean",
//     "Bengali", "Italian", "Spanish", "Vietnamese", "Japanese",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     // 1. Lắng nghe themeNotifier
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//         final isDark = mode == ThemeMode.dark;
//
//         return Scaffold(
//           // 2. Sử dụng màu nền từ Theme
//           backgroundColor: theme.scaffoldBackgroundColor,
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím đặc trưng
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Progress",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Course",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleMedium?.color)),
//                 const SizedBox(height: 10),
//
//                 // ================= DROPDOWN =================
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   decoration: BoxDecoration(
//                     // Đổi màu nền card cho dropdown
//                     color: theme.cardColor,
//                     border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedLanguage,
//                       isExpanded: true,
//                       // Đổi màu nền menu dropdown khi sổ xuống
//                       dropdownColor: theme.cardColor,
//                       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent),
//                       items: languages.map((String item) {
//                         return DropdownMenuItem(
//                             value: item,
//                             child: Text(item,
//                                 style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500))
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedLanguage = value!;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Progress",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: theme.textTheme.titleLarge?.color)),
//                     const Row(
//                       children: [
//                         Text("This Week", style: TextStyle(color: Colors.grey)),
//                         Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // ================= BIỂU ĐỒ CỘT =================
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _buildBar(60, "Mon", false, theme),
//                     _buildBar(80, "Tue", false, theme),
//                     _buildBar(50, "Wed", false, theme),
//                     _buildBar(100, "Thur", true, theme),
//                     _buildBar(40, "Fri", false, theme),
//                     _buildBar(110, "Sat", false, theme),
//                     _buildBar(55, "Sun", false, theme),
//                   ],
//                 ),
//
//                 const SizedBox(height: 30),
//                 Text("Completed Task",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleLarge?.color)),
//                 const SizedBox(height: 15),
//
//                 // ================= DANH SÁCH BÀI HỌC =================
//                 _buildTaskItem("Erater Tag in Berlin", "Lesson 1", true, theme),
//                 _buildTaskItem("First Steps", "Lesson 2", false, theme),
//                 _buildTaskItem("Vocabulary", "Lesson 3", false, theme),
//               ],
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
//         Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.topCenter,
//           children: [
//             Container(
//               width: 25,
//               height: height,
//               decoration: BoxDecoration(
//                 // Nếu không active, dùng màu xám của theme
//                 color: isActive ? Colors.orange : theme.disabledColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//             if (isActive)
//               Positioned(
//                 top: -30,
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
//                   child: const Text("31",
//                       style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }
//
//   Widget _buildTaskItem(String title, String sub, bool isChecked, ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: theme.cardColor, // Đổi màu card theo theme
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 5)
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF), size: 40),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         color: theme.textTheme.titleMedium?.color)),
//                 Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//               ],
//             ),
//           ),
//           Icon(isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
//               color: isChecked ? const Color(0xFF5F2EFF) : Colors.grey.shade300),
//         ],
//       ),
//     );
//   }
// }


//bản mới khi kết nối API
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/token_service.dart';
// import '../../models/course_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'LessonListPage.dart';
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
//                   Center(
//                     child: Column(
//                       children: [
//                         // Sửa dòng này để dùng dữ liệu từ selectedCourse
//                         Text(
//                           "${selectedCourse?.progressPercent ?? 0}%", // Chú ý: Dùng selectedCourse
//                           style: const TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange),
//                         ),
//                         const SizedBox(height: 5),
//                         // Sửa dòng này luôn cho đồng bộ tiêu đề
//                         Text("${selectedCourse?.title ?? ''} Progress", // Dùng selectedCourse
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
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LessonListPage(
//               courseId: course.id,
//               courseTitle: course.title,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5))
//           ],
//         ),
//         child: Row( // ĐOẠN NÀY PHẢI CÓ CODE UI THÌ NÓ MỚI HIỆN RA
//           children: [
//             const Icon(Icons.menu_book, color: Color(0xFF5F2EFF), size: 40),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(course.title,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: theme.textTheme.titleMedium?.color)),
//                   Text(course.level,
//                       style: const TextStyle(color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.orange.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 "${course.progressPercent}%",
//                 style: const TextStyle(
//                     color: Colors.orange, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





//bản biểu đồ thật
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart'; // Thêm thư viện này để xử lý ngày tháng
// import '../../services/token_service.dart';
// import '../../models/course_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'LessonListPage.dart';
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
//   Map<String, dynamic>? streakData;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadAllData();
//   }
//
//   // Hàm load song song cả Khóa học và Streak
//   Future<void> loadAllData() async {
//     setState(() => isLoading = true);
//     await Future.wait([
//       fetchCourses(),
//       fetchStreakData(),
//     ]);
//     setState(() => isLoading = false);
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
//       if (response.statusCode == 200) {
//         final data = jsonDecode(utf8.decode(response.bodyBytes));
//         final List list = data['content'] ?? [];
//         courses = list.map((e) => Course.fromJson(e)).toList();
//       }
//     } catch (e) {
//       print("Error fetching courses: $e");
//     }
//   }
//
//   Future<void> fetchStreakData() async {
//     const String apiUrl = "http://10.0.2.2:8080/api/v1/study-logs/streak";
//     try {
//       final token = await TokenService.getToken();
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//       );
//       if (response.statusCode == 200) {
//         streakData = jsonDecode(utf8.decode(response.bodyBytes));
//       }
//     } catch (e) {
//       print("Error fetching streak: $e");
//     }
//   }
//
//   // Logic kiểm tra ngày trong tuần có nằm trong danh sách đã học từ Backend không
//   bool _isDateStudied(DateTime date) {
//     if (streakData == null || streakData!['studyDates'] == null) return false;
//     List<dynamic> studiedDates = streakData!['studyDates'];
//     String formattedDate = DateFormat('yyyy-MM-dd').format(date);
//     return studiedDates.contains(formattedDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Learning Progress", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//             onRefresh: loadAllData,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildStreakCard(theme),
//                   const SizedBox(height: 25),
//                   Text("Weekly Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
//                   const SizedBox(height: 20),
//                   _buildWeeklyChart(theme),
//                   const SizedBox(height: 30),
//                   Text("My Courses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
//                   const SizedBox(height: 15),
//                   ...courses.map((course) => _buildCourseItem(course, theme)).toList(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStreakCard(ThemeData theme) {
//     int currentStreak = streakData?['currentStreak'] ?? 0;
//     bool studiedToday = streakData?['studiedToday'] ?? false;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 50),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("$currentStreak Days Streak!", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                 Text(studiedToday ? "You've studied today. Keep it up!" : "Complete a lesson to maintain your streak!",
//                     style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeeklyChart(ThemeData theme) {
//     // Lấy danh sách 7 ngày gần nhất tính từ hôm nay
//     DateTime now = DateTime.now();
//     List<DateTime> last7Days = List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: last7Days.map((date) {
//         bool isStudied = _isDateStudied(date);
//         bool isToday = DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now);
//         String dayName = DateFormat('E').format(date); // Mon, Tue...
//
//         return Column(
//           children: [
//             Container(
//               width: 30,
//               height: isStudied ? 80 : 20, // Nếu có học thì cột cao, không thì thấp
//               decoration: BoxDecoration(
//                 color: isStudied ? Colors.orange : theme.disabledColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//                 border: isToday ? Border.all(color: Colors.blueAccent, width: 2) : null,
//               ),
//               child: isStudied ? const Icon(Icons.check, size: 15, color: Colors.white) : null,
//             ),
//             const SizedBox(height: 8),
//             Text(dayName, style: TextStyle(color: isToday ? Colors.blueAccent : Colors.grey, fontSize: 12, fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildCourseItem(Course course, ThemeData theme) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LessonListPage(courseId: course.id, courseTitle: course.title)),
//         ).then((_) => loadAllData()); // Refresh khi quay lại
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.menu_book, color: Color(0xFF5F2EFF), size: 40),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(course.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.textTheme.titleMedium?.color)),
//                   Text(course.level, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: (course.progressPercent ?? 0) / 100,
//                   backgroundColor: Colors.grey.withOpacity(0.2),
//                   color: Colors.orange,
//                   strokeWidth: 4,
//                 ),
//                 Text("${course.progressPercent}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




//sửa bản đồ và fix lại
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../../services/token_service.dart';
// import '../../models/course_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'LessonListPage.dart';
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
//
//   // ===== DATA =====
//   List<Course> courses = []; // danh sách khóa học
//   Map<String, dynamic>? streakData; // dữ liệu streak từ backend
//   bool isLoading = true; // loading UI
//
//   @override
//   void initState() {
//     super.initState();
//     loadAllData(); // load dữ liệu khi vào màn
//   }
//
//   // ===== LOAD SONG SONG API =====
//   Future<void> loadAllData() async {
//     setState(() => isLoading = true);
//
//     await Future.wait([
//       fetchCourses(),
//       fetchStreakData(),
//     ]);
//
//     setState(() => isLoading = false);
//   }
//
//   // ===== LẤY DANH SÁCH KHÓA HỌC =====
//   Future<void> fetchCourses() async {
//     const String apiUrl = "http://10.0.2.2:8080/api/v1/courses";
//
//     try {
//       final token = await TokenService.getToken();
//
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
//         final List list = data['content'] ?? [];
//
//         courses = list.map((e) => Course.fromJson(e)).toList();
//       }
//     } catch (e) {
//       print("Error fetching courses: $e");
//     }
//   }
//
//   // ===== LẤY STREAK =====
//   Future<void> fetchStreakData() async {
//     const String apiUrl = "http://10.0.2.2:8080/api/v1/study-logs/streak";
//
//     try {
//       final token = await TokenService.getToken();
//
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         streakData = jsonDecode(utf8.decode(response.bodyBytes));
//       }
//     } catch (e) {
//       print("Error fetching streak: $e");
//     }
//   }
//
//   // ===== KIỂM TRA NGÀY CÓ HỌC KHÔNG =====
//   bool _isDateStudied(DateTime date) {
//     if (streakData == null || streakData!['studyDates'] == null) return false;
//
//     List<dynamic> studiedDates = streakData!['studyDates'];
//
//     // ép về yyyy-MM-dd
//     String target = DateFormat('yyyy-MM-dd').format(date);
//
//     return studiedDates.any((d) {
//       DateTime parsed = DateTime.parse(d.toString()).toLocal(); // 🔥 FIX TIMEZONE
//       String apiDate = DateFormat('yyyy-MM-dd').format(parsed);
//       return apiDate == target;
//     });
//   }
//
//   // ===== BUILD UI =====
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//
//         final theme = Theme.of(context);
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//
//           // ===== APPBAR =====
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text(
//               "Learning Progress",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new,
//                   color: Colors.white),
//               onPressed: widget.onBack,
//             ),
//           ),
//
//           // ===== BODY =====
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//             onRefresh: loadAllData,
//
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   // ===== CARD STREAK =====
//                   _buildStreakCard(theme),
//
//                   const SizedBox(height: 25),
//
//                   // ===== TITLE =====
//                   Text("Weekly Activity",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color)),
//
//                   const SizedBox(height: 20),
//
//                   // ===== BIỂU ĐỒ =====
//                   _buildWeeklyChart(theme),
//
//                   const SizedBox(height: 30),
//
//                   // ===== TITLE KHÓA HỌC =====
//                   Text("My Courses",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color)),
//
//                   const SizedBox(height: 15),
//
//                   // ===== LIST COURSE =====
//                   ...courses.map((course) =>
//                       _buildCourseItem(course, theme)).toList(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // ===== STREAK CARD =====
//   Widget _buildStreakCard(ThemeData theme) {
//
//     int currentStreak = streakData?['currentStreak'] ?? 0;
//
//     // kiểm tra hôm nay có học không
//     bool studiedToday = _isDateStudied(DateTime.now());
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//
//       child: Row(
//         children: [
//
//           // icon lửa streak
//           const Icon(Icons.local_fire_department,
//               color: Colors.orangeAccent, size: 50),
//
//           const SizedBox(width: 15),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 // số ngày streak
//                 Text("$currentStreak Days Streak!",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold)),
//
//                 // trạng thái hôm nay
//                 Text(
//                   studiedToday
//                       ? "You've studied today. Keep it up!"
//                       : "Complete a lesson to maintain your streak!",
//                   style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ===== BIỂU ĐỒ 7 NGÀY =====
//   Widget _buildWeeklyChart(ThemeData theme) {
//
//     DateTime now = DateTime.now();
//     DateTime today = DateTime(now.year, now.month, now.day);
//
//     // tạo danh sách 7 ngày gần nhất
//     List<DateTime> last7Days = List.generate(7, (index) {
//       return today.subtract(Duration(days: 6 - index));
//     });
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//
//       children: last7Days.map((date) {
//
//         bool isStudied = _isDateStudied(date);
//
//         // check hôm nay
//         bool isToday = date.year == today.year &&
//             date.month == today.month &&
//             date.day == today.day;
//
//         String dayName = DateFormat('E').format(date);
//
//         return Column(
//           children: [
//
//             // ===== CỘT BIỂU ĐỒ =====
//             Container(
//               width: 32,
//               height: isStudied ? 80 : 25,
//
//               decoration: BoxDecoration(
//
//                 // màu cột
//                 color: isStudied
//                     ? (isToday
//                     ? Colors.orange
//                     : Colors.orange.withOpacity(0.7))
//                     : Colors.grey.withOpacity(0.2),
//
//                 borderRadius: BorderRadius.circular(8),
//
//                 // chỉ viền khi là hôm nay và có học
//                 border: (isToday && isStudied)
//                     ? Border.all(color: Colors.blueAccent, width: 2)
//                     : null,
//               ),
//
//               // icon check nếu có học
//               child: isStudied
//                   ? const Icon(Icons.check,
//                   size: 14, color: Colors.white)
//                   : null,
//             ),
//
//             const SizedBox(height: 8),
//
//             // ===== TÊN THỨ =====
//             Text(
//               dayName,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: isToday ? Colors.blueAccent : Colors.grey,
//                 fontWeight:
//                 isToday ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   // ===== ITEM KHÓA HỌC =====
//   Widget _buildCourseItem(Course course, ThemeData theme) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LessonListPage(
//               courseId: course.id,
//               courseTitle: course.title,
//             ),
//           ),
//         ).then((_) => loadAllData()); // reload khi quay lại
//       },
//
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(15),
//
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5))
//           ],
//         ),
//
//         child: Row(
//           children: [
//
//             // icon khóa học
//             const Icon(Icons.menu_book,
//                 color: Color(0xFF5F2EFF), size: 40),
//
//             const SizedBox(width: 15),
//
//             // thông tin khóa học
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(course.title,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: theme.textTheme.titleMedium?.color)),
//
//                   Text(course.level,
//                       style: const TextStyle(
//                           color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//
//             // progress %
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: (course.progressPercent ?? 0) / 100,
//                   backgroundColor:
//                   Colors.grey.withOpacity(0.2),
//                   color: Colors.orange,
//                   strokeWidth: 4,
//                 ),
//                 Text("${course.progressPercent}%",
//                     style: const TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.orange)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//fix lại bản mới nhất
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../services/token_service.dart';
import '../../models/course_model.dart';
import '../homepagesetting/theme_notifier.dart';
import 'LessonListPage.dart';

class ProgressPage extends StatefulWidget {
  final VoidCallback onBack;
  const ProgressPage({super.key, required this.onBack});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Course> courses = [];
  Map<String, dynamic>? streakData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    await Future.wait([fetchCourses(), fetchStreakData()]);
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> fetchCourses() async {
    const String apiUrl = "http://10.0.2.2:8080/api/v1/courses";
    try {
      final token = await TokenService.getToken();
      final response = await http.get(Uri.parse(apiUrl), headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List list = data['content'] ?? [];
        courses = list.map((e) => Course.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching courses: $e");
    }
  }

  Future<void> fetchStreakData() async {
    const String apiUrl = "http://10.0.2.2:8080/api/v1/study-logs/streak";
    try {
      final token = await TokenService.getToken();
      final response = await http.get(Uri.parse(apiUrl), headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        streakData = jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint("Error fetching streak: $e");
    }
  }

  // 🔥 HÀM KIỂM TRA NGÀY HỌC (FIX CHUẨN)
  bool _isDateStudied(DateTime date) {
    if (streakData == null || streakData!['studyDates'] == null) return false;
    List<dynamic> studiedDates = streakData!['studyDates'];

    // Chỉ lấy phần yyyy-MM-dd để so sánh, mặc kệ múi giờ
    String formattedTarget = DateFormat('yyyy-MM-dd').format(date);

    return studiedDates.any((d) {
      // Parse ngày từ server và format lại yyyy-MM-dd
      String serverDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(d.toString()));
      return serverDate == formattedTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: _buildAppBar(),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
            onRefresh: loadAllData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStreakCard(theme), // Widget hiển thị ngọn lửa & số ngày học liên tiếp
                  const SizedBox(height: 25),
                  _buildSectionTitle(theme, "Weekly Activity"),
                  const SizedBox(height: 20),
                  _buildWeeklyChart(theme), // Widget biểu đồ 7 ngày (Thứ 2 -> CN)
                  const SizedBox(height: 30),
                  _buildSectionTitle(theme, "My Courses"),
                  const SizedBox(height: 15),
                  ...courses.map((course) => _buildCourseItem(course, theme)).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET: Thanh tiêu đề ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF4B00D1),
      elevation: 0,
      centerTitle: true,
      title: const Text("Learning Progress", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: widget.onBack,
      ),
    );
  }

  // --- WIDGET: Card thông tin Streak ---
  Widget _buildStreakCard(ThemeData theme) {
    int currentStreak = streakData?['currentStreak'] ?? 0;
    bool studiedToday = _isDateStudied(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 50),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$currentStreak Days Streak!", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  studiedToday ? "You've studied today. Keep it up!" : "Study today to keep your streak alive!",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: Biểu đồ tuần (THỨ 2 -> CN) ---
  // Widget _buildWeeklyChart(ThemeData theme) {
  //   DateTime now = DateTime.now();
  //   // Tìm ngày Thứ 2 của tuần này (Monday = 1)
  //   DateTime monday = now.subtract(Duration(days: now.weekday - 1));
  //   monday = DateTime(monday.year, monday.month, monday.day);
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: List.generate(7, (index) {
  //       // Tạo ngày từ Thứ 2 (index 0) đến Chủ Nhật (index 6)
  //       DateTime date = monday.add(Duration(days: index));
  //       bool isStudied = _isDateStudied(date);
  //       bool isToday = date.day == now.day && date.month == now.month && date.year == now.year;
  //       String dayName = DateFormat('E').format(date); // Mon, Tue...
  //
  //       return Column(
  //         children: [
  //           Container(
  //             width: 35,
  //             height: isStudied ? 80 : 25, // Có học thì cột cao, không thì lùn
  //             decoration: BoxDecoration(
  //               color: isStudied ? Colors.orange : Colors.grey.withOpacity(0.2),
  //               borderRadius: BorderRadius.circular(8),
  //               border: isToday ? Border.all(color: Colors.blueAccent, width: 2) : null, // Viền xanh cho hôm nay
  //             ),
  //             child: isStudied ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             dayName,
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
  //               color: isToday ? Colors.blueAccent : Colors.grey,
  //             ),
  //           ),
  //         ],
  //       );
  //     }),
  //   );
  // }



  Widget _buildWeeklyChart(ThemeData theme) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // TÌM NGÀY THỨ 2 CỦA TUẦN NÀY (Để cố định thứ tự T2 -> CN)
    DateTime monday = today.subtract(Duration(days: today.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        DateTime date = monday.add(Duration(days: index));

        // 1. Kiểm tra xem ngày này có dữ liệu học trong DB không
        bool hasDataInDb = _isDateStudied(date);

        // 2. Kiểm tra xem có đúng là ngày hôm nay không
        bool isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        // 🔥 LOGIC QUAN TRỌNG:
        // Chỉ cho phép sáng (isActive) nếu: LÀ HÔM NAY + CÓ HỌC TRONG DB
        bool isActive = isToday && hasDataInDb;

        String dayName = DateFormat('E').format(date);

        return Column(
          children: [
            Container(
              width: 35,
              height: isActive ? 80 : 25, // Chỉ cột hôm nay mới cao nếu có học
              decoration: BoxDecoration(
                // Chỉ sáng cam nếu isActive = true (là hôm nay và có học)
                color: isActive
                    ? Colors.orange
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),

                // Viền xanh để đánh dấu vị trí "Ngày hôm nay" cho người dùng biết
                border: isToday
                    ? Border.all(color: Colors.blueAccent, width: 2)
                    : null,
              ),
              child: isActive
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12,
                color: isToday ? Colors.blueAccent : Colors.grey,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- WIDGET: Item từng khóa học ---
  Widget _buildCourseItem(Course course, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LessonListPage(courseId: course.id, courseTitle: course.title)),
        ).then((_) => loadAllData());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book, color: Color(0xFF5F2EFF), size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.textTheme.titleMedium?.color)),
                  Text(course.level, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            _buildCircularProgress(course.progressPercent ?? 0),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: Vòng tròn phần trăm tiến độ ---
  Widget _buildCircularProgress(int percent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: percent / 100,
          backgroundColor: Colors.grey.withOpacity(0.2),
          color: Colors.orange,
          strokeWidth: 4,
        ),
        Text("$percent%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color));
  }
}