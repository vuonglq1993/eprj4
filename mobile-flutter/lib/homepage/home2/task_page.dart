// import 'package:flutter/material.dart';
// import '../../quiz/quiz_page.dart';
// import '../../data/task_question_data.dart';
// import '../../models/question_model.dart';
// // Import theme_notifier để lắng nghe trạng thái
// import '../homepagesetting/theme_notifier.dart';
//
// class TaskPage extends StatelessWidget {
//   final VoidCallback onBack;
//
//   const TaskPage({super.key, required this.onBack});
//
//   @override
//   Widget build(BuildContext context) {
//     // 1. Sử dụng ValueListenableBuilder để lắng nghe thay đổi theme
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//         final isDark = mode == ThemeMode.dark;
//
//         return Scaffold(
//           // 2. Thay đổi màu nền Scaffold theo theme
//           backgroundColor: theme.scaffoldBackgroundColor,
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím thương hiệu
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Task",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: onBack,
//             ),
//           ),
//
//           body: Column(
//             children: [
//               // PHẦN LỊCH (CALENDAR)
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 // 3. Đổi màu nền container lịch
//                 color: theme.cardColor,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("January 19, 2023",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.textTheme.titleLarge?.color // Màu chữ theo theme
//                             )),
//                         Icon(Icons.calendar_month_outlined,
//                             color: isDark ? Colors.grey[500] : Colors.grey.shade400),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildDateItem("Sat", "17", false, theme),
//                         _buildDateItem("Sun", "17", false, theme),
//                         _buildDateItem("Mon", "18", false, theme),
//                         _buildDateItem("Tue", "19", true, theme),
//                         _buildDateItem("Wed", "20", false, theme),
//                         _buildDateItem("Thu", "21", false, theme),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//                   children: [
//                     _buildTimelineRow("08:00", theme),
//
//                     _buildTimelineRow(
//                       "09:00",
//                       theme,
//                       task: _buildTaskCard(
//                         context,
//                         "German Language",
//                         "Remaining 5 Task",
//                         const Color(0xFF62A98D),
//                         Icons.language,
//                         germanQuestions,
//                       ),
//                     ),
//
//                     _buildTimelineRow("10:00", theme),
//                     _buildTimelineRow("11:00", theme),
//
//                     _buildTimelineRow(
//                       "12:00",
//                       theme,
//                       task: _buildTaskCard(
//                         context,
//                         "Spanish Language",
//                         "Remaining 20 Tasks",
//                         Colors.orange,
//                         Icons.language,
//                         germanQuestions,
//                       ),
//                     ),
//
//                     _buildTimelineRow("13:00", theme),
//                     _buildTimelineRow("14:00", theme),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDateItem(String day, String date, bool isSelected, ThemeData theme) {
//     return Column(
//       children: [
//         Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             date,
//             style: TextStyle(
//               // Nếu chọn thì màu trắng, không chọn thì lấy màu body của theme
//               color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimelineRow(String time, ThemeData theme, {Widget? task}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 50,
//           child: Text(time,
//               style: const TextStyle(color: Colors.grey, fontSize: 13)),
//         ),
//         Expanded(
//           child: Column(
//             children: [
//               if (task != null) task else const SizedBox(height: 60),
//               // 4. Đổi màu đường kẻ Divider
//               Divider(thickness: 1, color: theme.dividerColor.withOpacity(0.1)),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTaskCard(
//       BuildContext context,
//       String title,
//       String sub,
//       Color color,
//       IconData icon,
//       List<Question> questions) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => QuizPage(taskQuestions: questions),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: color, // Màu đặc trưng của task giữ nguyên để nổi bật
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white.withOpacity(0.9),
//               child: Icon(icon, color: Colors.black87),
//             ),
//             const SizedBox(width: 15),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15)),
//                 Text(sub,
//                     style:
//                     const TextStyle(color: Colors.white70, fontSize: 12)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//task api
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Thêm package intl vào pubspec.yaml để định dạng ngày
// import '../../services/api_service.dart';
// import '../../models/course_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/token_service.dart';
// import '../../homepage/home3/LessonListPage.dart'; // Import để chuyển trang bài học
//
// class TaskPage extends StatefulWidget {
//   final VoidCallback onBack;
//   const TaskPage({super.key, required this.onBack});
//
//   @override
//   State<TaskPage> createState() => _TaskPageState();
// }
//
// class _TaskPageState extends State<TaskPage> {
//   List<Course> activeCourses = [];
//   bool isLoading = true;
//   DateTime now = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTasks();
//   }
//
//   // 🔥 Lấy dữ liệu khóa học thật để làm Task
//   Future<void> _fetchTasks() async {
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
//         final List list = data['content'] ?? [];
//         setState(() {
//           // Chỉ lấy những khóa đang học dở (progress < 100)
//           activeCourses = list
//               .map((e) => Course.fromJson(e))
//               .where((c) => (c.progressPercent ?? 0) < 100)
//               .toList();
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching tasks: $e");
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
//         final isDark = mode == ThemeMode.dark;
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Daily Tasks",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//           body: Column(
//             children: [
//               // PHẦN LỊCH (Tự động lấy theo tuần hiện tại)
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 color: theme.cardColor,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(DateFormat('MMMM dd, yyyy').format(now),
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.textTheme.titleLarge?.color)),
//                         const Icon(Icons.calendar_month_outlined, color: Colors.grey),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(7, (index) {
//                         // Tính toán 7 ngày trong tuần
//                         DateTime day = now.subtract(Duration(days: now.weekday - 1 - index));
//                         bool isSelected = day.day == now.day;
//                         return _buildDateItem(
//                             DateFormat('E').format(day),
//                             day.day.toString(),
//                             isSelected,
//                             theme
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 child: isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : activeCourses.isEmpty
//                     ? const Center(child: Text("No tasks for today!"))
//                     : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//                   itemCount: 10, // Giả lập các khung giờ từ 8h - 17h
//                   itemBuilder: (context, index) {
//                     int hour = index + 8;
//                     String timeStr = "${hour.toString().padLeft(2, '0')}:00";
//
//                     // Phân bổ khóa học vào các khung giờ (ví dụ đơn giản)
//                     Course? taskForThisHour;
//                     if (index < activeCourses.length) {
//                       taskForThisHour = activeCourses[index];
//                     }
//
//                     return _buildTimelineRow(
//                       timeStr,
//                       theme,
//                       task: taskForThisHour != null
//                           ? _buildTaskCard(
//                         context,
//                         taskForThisHour,
//                         index % 2 == 0 ? const Color(0xFF62A98D) : Colors.orange,
//                       )
//                           : null,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDateItem(String day, String date, bool isSelected, ThemeData theme) {
//     return Column(
//       children: [
//         Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             date,
//             style: TextStyle(
//               color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimelineRow(String time, ThemeData theme, {Widget? task}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 50,
//           child: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//         ),
//         Expanded(
//           child: Column(
//             children: [
//               if (task != null) task else const SizedBox(height: 60),
//               Divider(thickness: 1, color: theme.dividerColor.withOpacity(0.1)),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTaskCard(BuildContext context, Course course, Color color) {
//     // Tính số task còn lại giả định dựa trên %
//     int remaining = course.totalLessons - ((course.progressPercent * course.totalLessons) ~/ 100);
//
//     return GestureDetector(
//       onTap: () {
//         // Chuyển thẳng sang danh sách bài học của khóa đó
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => LessonListPage(
//               courseId: course.id,
//               courseTitle: course.title,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               backgroundColor: Colors.white24,
//               child: Icon(Icons.menu_book, color: Colors.white),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(course.title,
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
//                   Text("Remaining $remaining lessons",
//                       style: const TextStyle(color: Colors.white70, fontSize: 12)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
//           ],
//         ),
//       ),
//     );
//   }
// }


//task mới
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../services/api_service.dart';
// import '../../models/course_model.dart';
// import '../homepagesetting/theme_notifier.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/token_service.dart';
// import '../../homepage/home3/LessonListPage.dart';
//
// class TaskPage extends StatefulWidget {
//   final VoidCallback onBack;
//   const TaskPage({super.key, required this.onBack});
//
//   @override
//   State<TaskPage> createState() => _TaskPageState();
// }
//
// class _TaskPageState extends State<TaskPage> {
//   List<Course> activeCourses = [];
//   bool isLoading = true;
//
//   // 1. Khai báo ngày hiện tại và ngày đang được người dùng chọn
//   DateTime now = DateTime.now();
//   late DateTime selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = now; // Mặc định khi vào trang là chọn ngày hôm nay
//     _fetchTasks();
//   }
//
//   Future<void> _fetchTasks() async {
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
//         final List list = data['content'] ?? [];
//         setState(() {
//           activeCourses = list
//               .map((e) => Course.fromJson(e))
//               .where((c) => (c.progressPercent ?? 0) < 100)
//               .toList();
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching tasks: $e");
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
//             title: const Text("Daily Tasks",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//           body: Column(
//             children: [
//               // --- PHẦN LỊCH (Đã thêm tính năng Click) ---
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 color: theme.cardColor,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Hiển thị tháng/năm dựa trên ngày đang chọn
//                         Text(DateFormat('MMMM dd, yyyy').format(selectedDate),
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.textTheme.titleLarge?.color)),
//                         const Icon(Icons.calendar_month_outlined, color: Colors.grey),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//
//                     // --- ĐOẠN CODE VẼ LỊCH 7 NGÀY (Hùng xem kỹ comment ở đây) ---
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(7, (index) {
//                         /* LOGIC TÍNH NGÀY:
//                            - now.weekday: Trả về thứ hiện tại (1 là Thứ 2, 7 là Chủ Nhật).
//                            - Lấy ngày hiện tại trừ đi (thứ hiện tại - 1) sẽ ra ngày Thứ 2 của tuần này.
//                            - Sau đó cộng thêm 'index' để lần lượt lấy từ Thứ 2 -> Chủ Nhật.
//                         */
//                         DateTime dayInWeek = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: index));
//
//                         // Kiểm tra xem ngày này có trùng với ngày đang được chọn (selectedDate) hay không
//                         bool isSelected = dayInWeek.day == selectedDate.day &&
//                             dayInWeek.month == selectedDate.month &&
//                             dayInWeek.year == selectedDate.year;
//
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedDate = dayInWeek; // Cập nhật ngày được chọn khi Hùng ấn vào
//                             });
//                             // Sau này Hùng có thể gọi lại API ở đây để lọc Task theo ngày:
//                             // _fetchTasksByDate(selectedDate);
//                           },
//                           child: _buildDateItem(
//                               DateFormat('E').format(dayInWeek), // Lấy tên thứ (Mon, Tue...)
//                               dayInWeek.day.toString(),         // Lấy số ngày
//                               isSelected,                       // Truyền trạng thái chọn để đổi màu
//                               theme
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 child: isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : activeCourses.isEmpty
//                     ? const Center(child: Text("No tasks for today!"))
//                     : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//                     int hour = index + 8;
//                     String timeStr = "${hour.toString().padLeft(2, '0')}:00";
//
//                     Course? taskForThisHour;
//                     if (index < activeCourses.length) {
//                       taskForThisHour = activeCourses[index];
//                     }
//
//                     return _buildTimelineRow(
//                       timeStr,
//                       theme,
//                       task: taskForThisHour != null
//                           ? _buildTaskCard(
//                         context,
//                         taskForThisHour,
//                         index % 2 == 0 ? const Color(0xFF62A98D) : Colors.orange,
//                       )
//                           : null,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // --- Widget vẽ từng item ngày trên lịch ---
//   Widget _buildDateItem(String dayName, String dateNum, bool isSelected, ThemeData theme) {
//     return Column(
//       children: [
//         Text(dayName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           decoration: BoxDecoration(
//             // Nếu được chọn thì hiện màu tím đặc trưng của app bạn
//             color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             dateNum,
//             style: TextStyle(
//               color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // (Các widget _buildTimelineRow và _buildTaskCard giữ nguyên như cũ)
//   Widget _buildTimelineRow(String time, ThemeData theme, {Widget? task}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 50,
//           child: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//         ),
//         Expanded(
//           child: Column(
//             children: [
//               if (task != null) task else const SizedBox(height: 60),
//               Divider(thickness: 1, color: theme.dividerColor.withOpacity(0.1)),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTaskCard(BuildContext context, Course course, Color color) {
//     int remaining = course.totalLessons - ((course.progressPercent * course.totalLessons) ~/ 100);
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => LessonListPage(
//               courseId: course.id,
//               courseTitle: course.title,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.menu_book, color: Colors.white)),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(course.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
//                   Text("Remaining $remaining lessons", style: const TextStyle(color: Colors.white70, fontSize: 12)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
//           ],
//         ),
//       ),
//     );
//   }
// }


//chặn k cho ấn trước các ngày
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/course_model.dart';
import '../homepagesetting/theme_notifier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/token_service.dart';
import '../../homepage/home3/LessonListPage.dart';

class TaskPage extends StatefulWidget {
  final VoidCallback onBack;
  const TaskPage({super.key, required this.onBack});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Course> activeCourses = [];
  bool isLoading = true;
  DateTime now = DateTime.now();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = now; // Mặc định chọn ngày hôm nay
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    const String apiUrl = "http://10.0.2.2:8080/api/v1/courses";
    try {
      final token = await TokenService.getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List list = data['content'] ?? [];
        setState(() {
          activeCourses = list
              .map((e) => Course.fromJson(e))
              .where((c) => (c.progressPercent ?? 0) < 100)
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            centerTitle: true,
            title: const Text("Daily Tasks",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: widget.onBack,
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: theme.cardColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Đẩy text sang trái
                      children: [
                        Text(DateFormat('MMMM dd, yyyy').format(selectedDate),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color)),
                        // ĐÃ XÓA ICON LỊCH Ở ĐÂY
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- KHỐI HÌNH LỊCH MÌNH KHOANH TRÒN ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        /* LOGIC TÍNH NGÀY TRONG TUẦN:
                           1. Tìm ngày Thứ 2 đầu tuần: now.subtract(Duration(days: now.weekday - 1))
                           2. Cộng thêm index (0->6) để ra từ Thứ 2 đến Chủ Nhật
                        */
                        DateTime dayInWeek = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: index));

                        // Kiểm tra nếu dayInWeek là ngày trong tương lai (sau ngày "now")
                        bool isFuture = dayInWeek.isAfter(now);

                        bool isSelected = dayInWeek.day == selectedDate.day &&
                            dayInWeek.month == selectedDate.month &&
                            dayInWeek.year == selectedDate.year;

                        return GestureDetector(
                          onTap: isFuture ? null : () { // NẾU LÀ NGÀY MAI THÌ KHÔNG CHO ẤN (null)
                            setState(() {
                              selectedDate = dayInWeek;
                            });
                          },
                          child: Opacity(
                            opacity: isFuture ? 0.3 : 1.0, // Làm mờ những ngày tương lai
                            child: _buildDateItem(
                                DateFormat('E').format(dayInWeek),
                                dayInWeek.day.toString(),
                                isSelected,
                                theme
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : activeCourses.isEmpty
                    ? const Center(child: Text("No tasks for today!"))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    int hour = index + 8;
                    String timeStr = "${hour.toString().padLeft(2, '0')}:00";

                    Course? taskForThisHour;
                    if (index < activeCourses.length) {
                      taskForThisHour = activeCourses[index];
                    }

                    return _buildTimelineRow(
                      timeStr,
                      theme,
                      task: taskForThisHour != null
                          ? _buildTaskCard(
                        context,
                        taskForThisHour,
                        index % 2 == 0 ? const Color(0xFF62A98D) : Colors.orange,
                      )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateItem(String dayName, String dateNum, bool isSelected, ThemeData theme) {
    return Column(
      children: [
        Text(dayName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5F2EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            dateNum,
            style: TextStyle(
              color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineRow(String time, ThemeData theme, {Widget? task}) {
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
              Divider(thickness: 1, color: theme.dividerColor.withOpacity(0.1)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, Course course, Color color) {
    int remaining = course.totalLessons - ((course.progressPercent * course.totalLessons) ~/ 100);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonListPage(
              courseId: course.id,
              courseTitle: course.title,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.menu_book, color: Colors.white)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("Remaining $remaining lessons", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}