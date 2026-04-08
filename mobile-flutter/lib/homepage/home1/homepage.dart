// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import '../../services/course_service.dart';
// import '../../models/course_model.dart';
// import '../home3/LessonListPage.dart';
// import '../home3/progress_page.dart';
// import '../home2/task_page.dart';
// import '../home4/profile_page.dart';
// import '../home4/activity_page.dart';
// import '../homepagesetting/settings_page.dart';
// import '../homepagesetting/theme_notifier.dart';
// import '../../notification/notification_page.dart';
// import '../../services/notification_service.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;
//   Map<String, dynamic>? user;
//   List<Course> courses = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     try {
//       final results = await Future.wait([
//         ApiService.getProfile(),
//         CourseService.getPublishedCourses(),
//       ]);
//
//       if (!mounted) return;
//
//       setState(() {
//         user = results[0] as Map<String, dynamic>?;
//         courses = results[1] as List<Course>;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error loading data: $e");
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final isDark = mode == ThemeMode.dark;
//         final theme = Theme.of(context);
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _getSelectedPage(),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: currentIndex,
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) {
//               setState(() {
//                 currentIndex = index;
//               });
//               // Reload dữ liệu khi chuyển tab
//               if (index == 0 || index == 2) {
//                 _loadData();
//               }
//             },
//             selectedItemColor: const Color(0xFF5F2EFF),
//             unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey,
//             backgroundColor: theme.cardColor,
//             showSelectedLabels: true,
//             showUnselectedLabels: false,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Task"),
//               BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: "Stats"),
//               BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _getSelectedPage() {
//     switch (currentIndex) {
//       case 0:
//         return _buildHomeContent();
//       case 1:
//         return TaskPage(onBack: () => setState(() => currentIndex = 0));
//       case 2:
//         return ProgressPage(onBack: () => setState(() => currentIndex = 0));
//       case 3:
//         return ProfilePage(
//           onBack: () async {
//             await _loadData();
//             setState(() {
//               currentIndex = 0;
//             });
//           },
//           onOpenActivity: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityPage())),
//           onOpenSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
//         );
//       default:
//         return _buildHomeContent();
//     }
//   }
//
//   // Widget _buildHomeContent() {
//   //   final theme = Theme.of(context);
//   //   final isDark = themeNotifier.value == ThemeMode.dark;
//   //
//   //   // Lấy danh sách khóa học đang học (progress > 0), sắp xếp theo tiến độ giảm dần
//   //   List<Course> displayContinuing = courses.where((c) => c.progressPercent > 0).toList();
//   //   displayContinuing.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
//   //
//   //   // Nếu không có khóa học nào đang học, lấy 2 khóa học mới nhất
//   //   if (displayContinuing.isEmpty) {
//   //     displayContinuing = courses.take(2).toList();
//   //   } else {
//   //     // Nếu có khóa học đang học, lấy tối đa 2 cái đầu tiên (tiến độ cao nhất)
//   //     displayContinuing = displayContinuing.take(2).toList();
//   //   }
//   //
//   //   return Column(
//   //     children: [
//   //       Container(
//   //         padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
//   //         decoration: const BoxDecoration(
//   //           color: Color(0xFF5F2EFF),
//   //           borderRadius: BorderRadius.only(
//   //             bottomLeft: Radius.circular(30),
//   //             bottomRight: Radius.circular(30),
//   //           ),
//   //         ),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Row(
//   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //               children: [
//   //                 CircleAvatar(
//   //                   radius: 22,
//   //                   backgroundImage: user?['avatarUrl'] != null
//   //                       ? NetworkImage(user!['avatarUrl'])
//   //                       : const NetworkImage("https://i.pravatar.cc/150?img=3"),
//   //                 ),
//   //                 Stack(
//   //                   children: [
//   //                     IconButton(
//   //                       icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
//   //                       onPressed: () {
//   //                         Navigator.push(
//   //                           context,
//   //                           MaterialPageRoute(builder: (_) => const NotificationPage()),
//   //                         ).then((_) => setState(() {}));
//   //                       },
//   //                     ),
//   //                     if (NotificationService.unreadCount() > 0)
//   //                       Positioned(
//   //                         right: 0,
//   //                         top: 0,
//   //                         child: Container(
//   //                           padding: const EdgeInsets.all(4),
//   //                           decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//   //                           child: Text(
//   //                             NotificationService.unreadCount().toString(),
//   //                             style: const TextStyle(color: Colors.white, fontSize: 10),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                   ],
//   //                 )
//   //               ],
//   //             ),
//   //             const SizedBox(height: 20),
//   //             Text(
//   //               "Hello, ${user?['firstName'] ?? 'User'}",
//   //               style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//   //             ),
//   //             const SizedBox(height: 5),
//   //             const Text(
//   //               "What would you like to learn today?",
//   //               style: TextStyle(color: Colors.white70, fontSize: 14),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       Expanded(
//   //         child: RefreshIndicator(
//   //           onRefresh: _loadData,
//   //           child: SingleChildScrollView(
//   //             padding: const EdgeInsets.symmetric(horizontal: 20),
//   //             physics: const AlwaysScrollableScrollPhysics(),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 if (displayContinuing.isNotEmpty) ...[
//   //                   const SizedBox(height: 25),
//   //                   sectionTitle("Continue Course", theme, () {
//   //                     setState(() {
//   //                       currentIndex = 2; // Chuyển sang trang Stats/Progress
//   //                     });
//   //                   }),
//   //                   const SizedBox(height: 15),
//   //                   Row(
//   //                     children: displayContinuing.map((c) {
//   //                       return Expanded(
//   //                         child: Padding(
//   //                           padding: EdgeInsets.only(
//   //                             right: displayContinuing.indexOf(c) == 0 ? 15 : 0,
//   //                           ),
//   //                           child: continueCard(
//   //                             c.title,
//   //                             "${c.progressPercent}%",
//   //                             c.progressPercent / 100,
//   //                             displayContinuing.indexOf(c) == 0 ? const Color(0xFF5F2EFF) : Colors.orange,
//   //                             theme,
//   //                             () => _openCourse(c),
//   //                           ),
//   //                         ),
//   //                       );
//   //                     }).toList(),
//   //                   ),
//   //                 ],
//   //                 const SizedBox(height: 30),
//   //                 sectionTitle("Featured Courses", theme, () {
//   //                   setState(() {
//   //                     currentIndex = 2;
//   //                   });
//   //                 }),
//   //                 const SizedBox(height: 15),
//   //                 ...courses.map((c) => featuredCard(
//   //                   c.title,
//   //                   c.description,
//   //                   "${c.totalLessons} Lessons",
//   //                   theme,
//   //                   () => _openCourse(c),
//   //                 )),
//   //                 const SizedBox(height: 20),
//   //                 Container(
//   //                   padding: const EdgeInsets.all(16),
//   //                   decoration: BoxDecoration(
//   //                     color: isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFEFE3),
//   //                     borderRadius: BorderRadius.circular(16),
//   //                   ),
//   //                   child: Row(
//   //                     children: [
//   //                       const Icon(Icons.emoji_events, color: Colors.orange),
//   //                       const SizedBox(width: 12),
//   //                       Expanded(
//   //                         child: Text(
//   //                           "Set Weekly Goal!\nUsers who set goals stay motivated.",
//   //                           style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
//   //                         ),
//   //                       )
//   //                     ],
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 30),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//
//
//
//   Widget _buildHomeContent() {
//     final theme = Theme.of(context);
//     final isDark = themeNotifier.value == ThemeMode.dark;
//
//     // 1. Lọc các khóa học đang học (progress > 0) và sắp xếp giảm dần theo %
//     List<Course> inProgress = courses.where((c) => c.progressPercent > 0).toList();
//     inProgress.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
//
//     // 2. Tạo danh sách hiển thị (mục tiêu lấy 2 item)
//     List<Course> displayContinuing = [];
//
//     if (inProgress.length >= 2) {
//       // Nếu có >= 2 khóa đang học: Lấy 2 khóa tiến độ cao nhất
//       displayContinuing = inProgress.take(2).toList();
//     } else {
//       // Nếu có ít hơn 2 khóa đang học (0 hoặc 1 khóa)
//       displayContinuing.addAll(inProgress);
//
//       // Lấy thêm các khóa học chưa học (progress == 0) để lấp đầy cho đủ 2 cột
//       // Loại trừ những khóa đã có trong danh sách displayContinuing
//       List<Course> notStarted = courses
//           .where((c) => c.progressPercent == 0 && !displayContinuing.contains(c))
//           .toList();
//
//       int needed = 2 - displayContinuing.length;
//       displayContinuing.addAll(notStarted.take(needed));
//     }
//
//     return Column(
//       children: [
//         // --- Phần Header màu tím ---
//         Container(
//           padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
//           decoration: const BoxDecoration(
//             color: Color(0xFF5F2EFF),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     radius: 22,
//                     backgroundImage: user?['avatarUrl'] != null
//                         ? NetworkImage(user!['avatarUrl'])
//                         : const NetworkImage("https://i.pravatar.cc/150?img=3"),
//                   ),
//                   Stack(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const NotificationPage()),
//                           ).then((_) => setState(() {}));
//                         },
//                       ),
//                       if (NotificationService.unreadCount() > 0)
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                             child: Text(
//                               NotificationService.unreadCount().toString(),
//                               style: const TextStyle(color: Colors.white, fontSize: 10),
//                             ),
//                           ),
//                         ),
//                     ],
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Hello, ${user?['firstName'] ?? 'User'}",
//                 style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 5),
//               const Text(
//                 "What would you like to learn today?",
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//
//         // --- Phần nội dung cuộn bên dưới ---
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: _loadData,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (displayContinuing.isNotEmpty) ...[
//                     const SizedBox(height: 25),
//                     sectionTitle("Continue Course", theme, () {
//                       setState(() => currentIndex = 2);
//                     }),
//                     const SizedBox(height: 15),
//                     // Render 2 cột cố định
//                     Row(
//                       children: [
//                         // Cột bên trái
//                         Expanded(
//                           child: continueCard(
//                             displayContinuing[0].title,
//                             "${displayContinuing[0].progressPercent}%",
//                             displayContinuing[0].progressPercent / 100,
//                             const Color(0xFF5F2EFF),
//                             theme,
//                                 () => _openCourse(displayContinuing[0]),
//                           ),
//                         ),
//                         const SizedBox(width: 15), // Khoảng cách giữa 2 card
//                         // Cột bên phải
//                         Expanded(
//                           child: displayContinuing.length > 1
//                               ? continueCard(
//                             displayContinuing[1].title,
//                             "${displayContinuing[1].progressPercent}%",
//                             displayContinuing[1].progressPercent / 100,
//                             Colors.orange,
//                             theme,
//                                 () => _openCourse(displayContinuing[1]),
//                           )
//                               : const SizedBox(), // Nếu DB chỉ có đúng 1 khóa học duy nhất
//                         ),
//                       ],
//                     ),
//                   ],
//                   const SizedBox(height: 30),
//                   sectionTitle("Featured Courses", theme, () {
//                     setState(() => currentIndex = 2);
//                   }),
//                   const SizedBox(height: 15),
//                   ...courses.map((c) => featuredCard(
//                     c.title,
//                     c.description,
//                     "${c.totalLessons} Lessons",
//                     theme,
//                         () => _openCourse(c),
//                   )),
//                   const SizedBox(height: 20),
//                   // Banner mục tiêu tuần
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFEFE3),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.emoji_events, color: Colors.orange),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             "Set Weekly Goal!\nUsers who set goals stay motivated.",
//                             style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//
//   void _openCourse(Course course) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => LessonListPage(
//           courseId: course.id,
//           courseTitle: course.title,
//         ),
//       ),
//     ).then((_) => _loadData());
//   }
//
//   Widget sectionTitle(String text, ThemeData theme, VoidCallback onSeeAll) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.textTheme.titleLarge?.color)),
//         GestureDetector(
//           onTap: onSeeAll,
//           child: const Text("See All", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w500)),
//         ),
//       ],
//     );
//   }
//
//   Widget continueCard(String title, String progress, double value, Color color, ThemeData theme, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               width: 65,
//               height: 65,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     value: value,
//                     strokeWidth: 6,
//                     backgroundColor: theme.disabledColor.withOpacity(0.1),
//                     valueColor: AlwaysStoppedAnimation(color),
//                   ),
//                   Text(progress, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.textTheme.bodyMedium?.color)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.titleMedium?.color),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget featuredCard(String title, String subtitle, String info, ThemeData theme, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF5F2EFF).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF)),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.textTheme.titleMedium?.color)),
//                   const SizedBox(height: 4),
//                   Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Text(info, style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }









//bản mới nối api topic
// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import '../../services/course_service.dart';
// import '../../services/topic_service.dart';
// import '../../services/notification_service.dart';
// import '../../models/course_model.dart';
// import '../../models/topic_model.dart';
// import '../home3/LessonListPage.dart';
// import '../home3/progress_page.dart';
// import '../home2/task_page.dart';
// import 'topic_courses_page.dart';
// import '../home4/profile_page.dart';
// import '../home4/activity_page.dart';
// import '../homepagesetting/settings_page.dart';
// import '../homepagesetting/theme_notifier.dart';
// import '../../notification/notification_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;
//   Map<String, dynamic>? user;
//   List<Course> courses = [];
//   List<TopicModel> topics = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     try {
//       final results = await Future.wait([
//         ApiService.getProfile(),
//         CourseService.getPublishedCourses(),
//         TopicService.getTopics(),
//       ]);
//
//       if (!mounted) return;
//
//       setState(() {
//         user = results[0] as Map<String, dynamic>?;
//         courses = results[1] as List<Course>;
//         topics = results[2] as List<TopicModel>;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error loading data: $e");
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final isDark = mode == ThemeMode.dark;
//         final theme = Theme.of(context);
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _getSelectedPage(),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: currentIndex,
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) {
//               setState(() {
//                 currentIndex = index;
//               });
//
//               if (index == 0 || index == 2) {
//                 _loadData();
//               }
//             },
//             selectedItemColor: const Color(0xFF5F2EFF),
//             unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey,
//             backgroundColor: theme.cardColor,
//             showSelectedLabels: true,
//             showUnselectedLabels: false,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home_filled),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.menu_book),
//                 label: "Task",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.pie_chart_outline),
//                 label: "Stats",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person_outline),
//                 label: "Profile",
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _getSelectedPage() {
//     switch (currentIndex) {
//       case 0:
//         return _buildHomeContent();
//       case 1:
//         return TaskPage(
//           onBack: () => setState(() => currentIndex = 0),
//         );
//       case 2:
//         return ProgressPage(
//           onBack: () => setState(() => currentIndex = 0),
//         );
//       case 3:
//         return ProfilePage(
//           onBack: () async {
//             await _loadData();
//             setState(() {
//               currentIndex = 0;
//             });
//           },
//           onOpenActivity: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const ActivityPage()),
//           ),
//           onOpenSettings: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const SettingsPage()),
//           ),
//         );
//       default:
//         return _buildHomeContent();
//     }
//   }
//
//   Widget _buildHomeContent() {
//     final theme = Theme.of(context);
//     final isDark = themeNotifier.value == ThemeMode.dark;
//
//     List<Course> inProgress =
//     courses.where((c) => c.progressPercent > 0).toList();
//     inProgress.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
//
//     List<Course> displayContinuing = [];
//
//     if (inProgress.length >= 2) {
//       displayContinuing = inProgress.take(2).toList();
//     } else {
//       displayContinuing.addAll(inProgress);
//
//       List<Course> notStarted = courses
//           .where((c) => c.progressPercent == 0 && !displayContinuing.contains(c))
//           .toList();
//
//       int needed = 2 - displayContinuing.length;
//       displayContinuing.addAll(notStarted.take(needed));
//     }
//
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
//           decoration: const BoxDecoration(
//             color: Color(0xFF5F2EFF),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     radius: 22,
//                     backgroundImage: user?['avatarUrl'] != null
//                         ? NetworkImage(user!['avatarUrl'])
//                         : const NetworkImage("https://i.pravatar.cc/150?img=3"),
//                   ),
//                   Stack(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.notifications_none,
//                           color: Colors.white,
//                           size: 26,
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const NotificationPage(),
//                             ),
//                           ).then((_) => setState(() {}));
//                         },
//                       ),
//                       if (NotificationService.unreadCount() > 0)
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: const BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               NotificationService.unreadCount().toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Hello, ${user?['firstName'] ?? 'User'}",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               const Text(
//                 "What would you like to learn today?",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: _loadData,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (displayContinuing.isNotEmpty) ...[
//                     const SizedBox(height: 25),
//                     sectionTitle("Continue Course", theme, () {
//                       setState(() => currentIndex = 2);
//                     }),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: continueCard(
//                             displayContinuing[0].title,
//                             "${displayContinuing[0].progressPercent}%",
//                             displayContinuing[0].progressPercent / 100,
//                             const Color(0xFF5F2EFF),
//                             theme,
//                                 () => _openCourse(displayContinuing[0]),
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                         Expanded(
//                           child: displayContinuing.length > 1
//                               ? continueCard(
//                             displayContinuing[1].title,
//                             "${displayContinuing[1].progressPercent}%",
//                             displayContinuing[1].progressPercent / 100,
//                             Colors.orange,
//                             theme,
//                                 () => _openCourse(displayContinuing[1]),
//                           )
//                               : const SizedBox(),
//                         ),
//                       ],
//                     ),
//                   ],
//
//                   const SizedBox(height: 30),
//
//                   sectionTitle("Topics", theme, () {}),
//                   const SizedBox(height: 15),
//
//                   SizedBox(
//                     height: 120,
//                     child: topics.isEmpty
//                         ? Center(
//                       child: Text(
//                         "Chưa có chủ đề nào",
//                         style: TextStyle(
//                           color: theme.textTheme.bodyMedium?.color,
//                         ),
//                       ),
//                     )
//                         : ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: topics.length,
//                       separatorBuilder: (_, __) =>
//                       const SizedBox(width: 12),
//                       itemBuilder: (context, index) {
//                         final topic = topics[index];
//
//                         return GestureDetector(
//                           onTap: () => _openTopic(topic),
//                           child: Container(
//                             width: 140,
//                             padding: const EdgeInsets.all(14),
//                             decoration: BoxDecoration(
//                               color: theme.cardColor,
//                               borderRadius: BorderRadius.circular(18),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(
//                                     themeNotifier.value == ThemeMode.dark
//                                         ? 0.3
//                                         : 0.05,
//                                   ),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _topicEmoji(topic),
//                                   style: const TextStyle(fontSize: 28),
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   topic.name,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                     color:
//                                     theme.textTheme.titleMedium?.color,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "${topic.totalCourses} courses",
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Color(0xFF5F2EFF),
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   sectionTitle("Featured Courses", theme, () {
//                     setState(() => currentIndex = 2);
//                   }),
//                   const SizedBox(height: 15),
//
//                   ...courses.map(
//                         (c) => featuredCard(
//                       c.title,
//                       c.description,
//                       "${c.totalLessons} Lessons",
//                       theme,
//                           () => _openCourse(c),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isDark
//                           ? Colors.orange.withOpacity(0.2)
//                           : const Color(0xFFFFEFE3),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.emoji_events, color: Colors.orange),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             "Set Weekly Goal!\nUsers who set goals stay motivated.",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: theme.textTheme.bodyMedium?.color,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _openCourse(Course course) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => LessonListPage(
//           courseId: course.id,
//           courseTitle: course.title,
//         ),
//       ),
//     ).then((_) => _loadData());
//   }
//
//   void _openTopic(TopicModel topic) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => TopicCoursesPage(
//           topicId: topic.id,
//           topicName: topic.name,
//         ),
//       ),
//     ).then((_) => _loadData());
//   }
//
//   String _topicEmoji(TopicModel topic) {
//     final icon = topic.iconUrl?.trim();
//     if (icon != null && icon.isNotEmpty) return icon;
//
//     final lower = topic.name.toLowerCase();
//     if (lower.contains("travel")) return "✈️";
//     if (lower.contains("food")) return "🍔";
//     if (lower.contains("business")) return "💼";
//     if (lower.contains("daily")) return "🏠";
//     if (lower.contains("family")) return "👨‍👩‍👧";
//     return "📚";
//   }
//
//   Widget sectionTitle(
//       String text,
//       ThemeData theme,
//       VoidCallback onSeeAll,
//       ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           text,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: theme.textTheme.titleLarge?.color,
//           ),
//         ),
//         GestureDetector(
//           onTap: onSeeAll,
//           child: const Text(
//             "See All",
//             style: TextStyle(
//               color: Color(0xFF5F2EFF),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget continueCard(
//       String title,
//       String progress,
//       double value,
//       Color color,
//       ThemeData theme,
//       VoidCallback onTap,
//       ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: theme.dividerColor.withOpacity(0.1),
//           ),
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               width: 65,
//               height: 65,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     value: value,
//                     strokeWidth: 6,
//                     backgroundColor: theme.disabledColor.withOpacity(0.1),
//                     valueColor: AlwaysStoppedAnimation(color),
//                   ),
//                   Text(
//                     progress,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                       color: theme.textTheme.bodyMedium?.color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: theme.textTheme.titleMedium?.color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget featuredCard(
//       String title,
//       String subtitle,
//       String info,
//       ThemeData theme,
//       VoidCallback onTap,
//       ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(
//                 themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05,
//               ),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF5F2EFF).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.play_circle_fill,
//                 color: Color(0xFF5F2EFF),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                       color: theme.textTheme.titleMedium?.color,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               info,
//               style: const TextStyle(
//                 color: Colors.blueGrey,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




//bản sửa see all
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/course_service.dart';
import '../../services/topic_service.dart';
import '../../services/notification_service.dart';
import '../../models/course_model.dart';
import '../../models/topic_model.dart';
import '../home3/LessonListPage.dart';
import '../home3/progress_page.dart';
import '../home2/task_page.dart';
import 'topic_courses_page.dart';
import 'topics_page.dart';
import '../home4/profile_page.dart';
import '../home4/activity_page.dart';
import '../homepagesetting/settings_page.dart';
import '../homepagesetting/theme_notifier.dart';
import '../../notification/notification_page.dart';
import 'learning_paths_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  Map<String, dynamic>? user;
  List<Course> courses = [];
  List<TopicModel> topics = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ApiService.getProfile(),
        CourseService.getPublishedCourses(),
        TopicService.getTopics(),
      ]);

      if (!mounted) return;

      setState(() {
        user = results[0] as Map<String, dynamic>?;
        courses = results[1] as List<Course>;
        topics = results[2] as List<TopicModel>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _getSelectedPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });

              if (index == 0 || index == 2) {
                _loadData();
              }
            },
            selectedItemColor: const Color(0xFF5F2EFF),
            unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey,
            backgroundColor: theme.cardColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: "Task",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline),
                label: "Stats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getSelectedPage() {
    switch (currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return TaskPage(
          onBack: () => setState(() => currentIndex = 0),
        );
      case 2:
        return ProgressPage(
          onBack: () => setState(() => currentIndex = 0),
        );
      case 3:
        return ProfilePage(
          onBack: () async {
            await _loadData();
            setState(() {
              currentIndex = 0;
            });
          },
          onOpenActivity: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ActivityPage()),
          ),
          onOpenSettings: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        );
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final theme = Theme.of(context);
    final isDark = themeNotifier.value == ThemeMode.dark;

    List<Course> inProgress =
    courses.where((c) => c.progressPercent > 0).toList();
    inProgress.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));

    List<Course> displayContinuing = [];

    if (inProgress.length >= 2) {
      displayContinuing = inProgress.take(2).toList();
    } else {
      displayContinuing.addAll(inProgress);

      List<Course> notStarted = courses
          .where((c) => c.progressPercent == 0 && !displayContinuing.contains(c))
          .toList();

      int needed = 2 - displayContinuing.length;
      displayContinuing.addAll(notStarted.take(needed));
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
          decoration: const BoxDecoration(
            color: Color(0xFF5F2EFF),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: user?['avatarUrl'] != null
                        ? NetworkImage(user!['avatarUrl'])
                        : const NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationPage(),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                      if (NotificationService.unreadCount() > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              NotificationService.unreadCount().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hello, ${user?['firstName'] ?? 'User'}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "What would you like to learn today?",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayContinuing.isNotEmpty) ...[
                    const SizedBox(height: 25),
                    sectionTitle("Continue Course", theme, () {
                      setState(() => currentIndex = 2);
                    }),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: continueCard(
                            displayContinuing[0].title,
                            "${displayContinuing[0].progressPercent}%",
                            displayContinuing[0].progressPercent / 100,
                            const Color(0xFF5F2EFF),
                            theme,
                                () => _openCourse(displayContinuing[0]),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: displayContinuing.length > 1
                              ? continueCard(
                            displayContinuing[1].title,
                            "${displayContinuing[1].progressPercent}%",
                            displayContinuing[1].progressPercent / 100,
                            Colors.orange,
                            theme,
                                () => _openCourse(displayContinuing[1]),
                          )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 30),

                  sectionTitle("Topics", theme, _openAllTopics),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 135,
                    child: topics.isEmpty
                        ? Center(
                      child: Text(
                        "Chưa có chủ đề nào",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    )
                        : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: topics.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final topic = topics[index];

                        return GestureDetector(
                          onTap: () => _openTopic(topic),
                          child: Container(
                            width: 145,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    themeNotifier.value == ThemeMode.dark
                                        ? 0.3
                                        : 0.05,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                _buildTopicIcon(topic),
                                const Spacer(),
                                Text(
                                  topic.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color:
                                    theme.textTheme.titleMedium?.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${topic.totalCourses} courses",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF5F2EFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  sectionTitle("Learning Paths", theme, _openAllLearningPaths),
                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: _openAllLearningPaths,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.route, color: Color(0xFF5F2EFF)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Explore learning paths tailored to your level",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  sectionTitle("Featured Courses", theme, () {
                    setState(() => currentIndex = 2);
                  }),
                  const SizedBox(height: 15),

                  ...courses.map(
                        (c) => featuredCard(
                      c.title,
                      c.description,
                      "${c.totalLessons} Lessons",
                      theme,
                          () => _openCourse(c),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.orange.withOpacity(0.2)
                          : const Color(0xFFFFEFE3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Set Weekly Goal!\nUsers who set goals stay motivated.",
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openCourse(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonListPage(
          courseId: course.id,
          courseTitle: course.title,
        ),
      ),
    ).then((_) => _loadData());
  }

  void _openTopic(TopicModel topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicCoursesPage(
          topicId: topic.id,
          topicName: topic.name,
        ),
      ),
    ).then((_) => _loadData());
  }

  void _openAllLearningPaths() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LearningPathsPage(),
      ),
    ).then((_) => _loadData());
  }

  void _openAllTopics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TopicsPage(),
      ),
    ).then((_) => _loadData());
  }

  Widget _buildTopicIcon(TopicModel topic) {
    final icon = topic.iconUrl?.trim();

    if (icon != null && icon.isNotEmpty) {
      final isNetworkImage = icon.startsWith("http://") || icon.startsWith("https://");

      if (isNetworkImage) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            icon,
            width: 42,
            height: 42,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackTopicIcon(topic),
          ),
        );
      }

      if (icon.runes.length <= 4) {
        return Text(
          icon,
          style: const TextStyle(fontSize: 28),
        );
      }
    }

    return _fallbackTopicIcon(topic);
  }

  Widget _fallbackTopicIcon(TopicModel topic) {
    IconData iconData = Icons.topic;

    final lower = topic.name.toLowerCase();
    if (lower.contains("grammar")) iconData = Icons.spellcheck;
    if (lower.contains("vocabulary")) iconData = Icons.menu_book;
    if (lower.contains("listening")) iconData = Icons.headphones;
    if (lower.contains("travel")) iconData = Icons.flight;
    if (lower.contains("food")) iconData = Icons.restaurant;
    if (lower.contains("business")) iconData = Icons.business_center;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF5F2EFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: const Color(0xFF5F2EFF),
        size: 22,
      ),
    );
  }

  Widget sectionTitle(
      String text,
      ThemeData theme,
      VoidCallback onSeeAll,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            "See All",
            style: TextStyle(
              color: Color(0xFF5F2EFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget continueCard(
      String title,
      String progress,
      double value,
      Color color,
      ThemeData theme,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 65,
              height: 65,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: value,
                    strokeWidth: 6,
                    backgroundColor: theme.disabledColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                  Text(
                    progress,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featuredCard(
      String title,
      String subtitle,
      String info,
      ThemeData theme,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF5F2EFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_circle_fill,
                color: Color(0xFF5F2EFF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              info,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}