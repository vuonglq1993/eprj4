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



//
//
// import 'package:flutter/material.dart';
// import '../../services/course_service.dart';
// import '../../models/course_model.dart';
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
//   List<Course> courses = [];
//   Course? selectedCourse;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCourses();
//   }
//
//   Future<void> fetchCourses() async {
//     try {
//       final data = await CourseService.getCourses();
//
//       setState(() {
//         courses = data;
//         if (courses.isNotEmpty) {
//           selectedCourse = courses[0];
//         }
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error: $e");
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
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Progress",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new,
//                   color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : courses.isEmpty
//               ? const Center(child: Text("No courses found"))
//               : SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ================= DROPDOWN =================
//                 Text("Course",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleMedium?.color)),
//
//                 const SizedBox(height: 10),
//
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 15),
//                   decoration: BoxDecoration(
//                     color: theme.cardColor,
//                     border: Border.all(
//                         color: Colors.blueAccent.withOpacity(0.3)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCourse?.id,
//                       isExpanded: true,
//                       dropdownColor: theme.cardColor,
//                       icon: const Icon(
//                           Icons.keyboard_arrow_down,
//                           color: Colors.blueAccent),
//                       items: courses.map((course) {
//                         return DropdownMenuItem(
//                           value: course.id,
//                           child: Text(course.title,
//                               style: const TextStyle(
//                                   color: Colors.blueAccent,
//                                   fontWeight: FontWeight.w500)),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedCourse = courses
//                               .firstWhere((c) => c.id == value);
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // ================= PROGRESS =================
//                 Text("Progress",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleLarge?.color)),
//
//                 const SizedBox(height: 20),
//
//                 Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         "${selectedCourse?.progressPercent ?? 0}%",
//                         style: const TextStyle(
//                             fontSize: 50,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text("Course Progress",
//                           style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // ================= LIST COURSE =================
//                 Text("All Courses",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleLarge?.color)),
//
//                 const SizedBox(height: 15),
//
//                 Column(
//                   children: courses.map((course) {
//                     return _buildCourseItem(course, theme);
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
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
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.menu_book,
//               color: Color(0xFF5F2EFF), size: 40),
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
//                     style:
//                     const TextStyle(color: Colors.grey, fontSize: 13)),
//               ],
//             ),
//           ),
//           Text("${course.progressPercent}%",
//               style: const TextStyle(
//                   color: Colors.orange,
//                   fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }



//
// import 'package:flutter/material.dart';
// import '../../services/course_service.dart';
// import '../../models/course_model.dart';
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
//   List<Course> courses = [];
//   Course? selectedCourse;
//   bool isLoading = true;
//
//   // 🔥 dữ liệu biểu đồ (fake nhẹ, sau sẽ nối API lesson)
//   final List<Map<String, dynamic>> weeklyData = [
//     {"day": "Mon", "value": 60},
//     {"day": "Tue", "value": 80},
//     {"day": "Wed", "value": 50},
//     {"day": "Thu", "value": 100},
//     {"day": "Fri", "value": 40},
//     {"day": "Sat", "value": 110},
//     {"day": "Sun", "value": 55},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCourses();
//   }
//
//   Future<void> fetchCourses() async {
//     try {
//       final data = await CourseService.getCourses();
//
//       setState(() {
//         courses = data;
//         if (courses.isNotEmpty) {
//           selectedCourse = courses[0];
//         }
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error: $e");
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
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             title: const Text("Progress",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.white)),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new,
//                   color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//           ),
//
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : courses.isEmpty
//               ? const Center(child: Text("No courses found"))
//               : SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ================= DROPDOWN =================
//                 Text("Course",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleMedium?.color)),
//
//                 const SizedBox(height: 10),
//
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 15),
//                   decoration: BoxDecoration(
//                     color: theme.cardColor,
//                     border: Border.all(
//                         color: Colors.blueAccent.withOpacity(0.3)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCourse?.id,
//                       isExpanded: true,
//                       dropdownColor: theme.cardColor,
//                       icon: const Icon(
//                           Icons.keyboard_arrow_down,
//                           color: Colors.blueAccent),
//                       items: courses.map((course) {
//                         return DropdownMenuItem(
//                           value: course.id,
//                           child: Text(course.title,
//                               style: const TextStyle(
//                                   color: Colors.blueAccent,
//                                   fontWeight: FontWeight.w500)),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedCourse = courses.firstWhere(
//                                   (c) => c.id == value);
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 // ================= HEADER =================
//                 Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Progress",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: theme
//                                 .textTheme.titleLarge?.color)),
//                     const Row(
//                       children: [
//                         Text("This Week",
//                             style: TextStyle(color: Colors.grey)),
//                         Icon(Icons.keyboard_arrow_down,
//                             color: Colors.grey),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // ================= BIỂU ĐỒ =================
//                 Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: weeklyData.map((item) {
//                     bool isActive =
//                         item["value"] ==
//                             weeklyData
//                                 .map((e) => e["value"])
//                                 .reduce((a, b) =>
//                             a > b ? a : b);
//
//                     return _buildBar(
//                         item["value"].toDouble(),
//                         item["day"],
//                         isActive,
//                         theme);
//                   }).toList(),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // ================= PROGRESS TEXT =================
//                 Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         "${selectedCourse?.progressPercent ?? 0}%",
//                         style: const TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange),
//                       ),
//                       const SizedBox(height: 5),
//                       const Text("Course Progress",
//                           style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // ================= LIST COURSE =================
//                 Text("Courses",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleLarge?.color)),
//
//                 const SizedBox(height: 15),
//
//                 Column(
//                   children: courses.map((course) {
//                     return _buildCourseItem(course, theme);
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // ================= BAR =================
//   Widget _buildBar(
//       double height, String day, bool isActive, ThemeData theme) {
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
//                 color: isActive
//                     ? Colors.orange
//                     : theme.disabledColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//             if (isActive)
//               Positioned(
//                 top: -30,
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: const BoxDecoration(
//                       color: Colors.orange,
//                       shape: BoxShape.circle),
//                   child: Text(
//                     "${selectedCourse?.progressPercent ?? 0}",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(day,
//             style:
//             const TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }
//
//   // ================= COURSE ITEM =================
//   // Widget _buildCourseItem(Course course, ThemeData theme) {
//   //   return Container(
//   //     margin: const EdgeInsets.only(bottom: 12),
//   //     padding: const EdgeInsets.all(15),
//   //     decoration: BoxDecoration(
//   //       color: theme.cardColor,
//   //       borderRadius: BorderRadius.circular(15),
//   //       boxShadow: [
//   //         BoxShadow(
//   //             color: Colors.black.withOpacity(0.05),
//   //             blurRadius: 10,
//   //             offset: const Offset(0, 5))
//   //       ],
//   //     ),
//   //     child: Row(
//   //       children: [
//   //         const Icon(Icons.menu_book,
//   //             color: Color(0xFF5F2EFF), size: 40),
//   //         const SizedBox(width: 15),
//   //         Expanded(
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Text(course.title,
//   //                   style: TextStyle(
//   //                       fontWeight: FontWeight.bold,
//   //                       fontSize: 15,
//   //                       color: theme.textTheme.titleMedium?.color)),
//   //               Text(course.level,
//   //                   style: const TextStyle(
//   //                       color: Colors.grey, fontSize: 13)),
//   //             ],
//   //           ),
//   //         ),
//   //         Text("${course.progressPercent}%",
//   //             style: const TextStyle(
//   //                 color: Colors.orange,
//   //                 fontWeight: FontWeight.bold)),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//
//
//
//
//   Widget _buildCourseItem(Course course, ThemeData theme) {
//     return GestureDetector(
//       onTap: () {
//         // 👉 CLICK VÀO COURSE → MỞ LESSON
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => LessonListPage(course: course),
//           ),
//         );
//       },
//
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
//         child: Row(
//           children: [
//             const Icon(Icons.menu_book,
//                 color: Color(0xFF5F2EFF), size: 40),
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
//                       style: const TextStyle(
//                           color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Text("${course.progressPercent}%",
//                 style: const TextStyle(
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }