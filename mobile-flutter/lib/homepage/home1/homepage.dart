// import 'package:flutter/material.dart';
// import '../../services/fake_auth.dart';
// import '../../quiz/quiz_page.dart';
// import '../home3/progress_page.dart';
// import '../home2/task_page.dart';
// import '../home4/profile_page.dart';
// import '../home4/activity_page.dart';
// import '../homepagesetting/settings_page.dart';
// import '../homepagesetting/theme_notifier.dart';
// import '../../data/task_question_data.dart';
// import '../../notification/notification_page.dart';
// import '../../models/notification_model.dart';
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
//           body: _getSelectedPage(),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: currentIndex,
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) {
//               setState(() {
//                 currentIndex = index;
//               });
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
//           onBack: () => setState(() => currentIndex = 0),
//           onOpenActivity: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityPage())),
//           onOpenSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
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
//                     backgroundImage: FakeAuth.avatar != null
//                         ? FileImage(FakeAuth.avatar!)
//                         : const NetworkImage("https://i.pravatar.cc/150?img=3") as ImageProvider,
//                   ),
//                   // const Icon(Icons.notifications_none, color: Colors.white, size: 26),
//                   //notification
//                   Stack(
//                     children: [
//
//                       IconButton(
//                         icon: const Icon(Icons.notifications_none,
//                             color: Colors.white, size: 26),
//
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const NotificationPage(),
//                             ),
//                           ).then((_) {
//                             setState(() {});
//                           });
//                         },
//                       ),
//
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
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Hello, ${FakeAuth.userName ?? 'User'}",
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
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 25),
//                 sectionTitle("Continue Course", theme),
//                 const SizedBox(height: 15),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: continueCard(
//                         "German\nLanguage",
//                         "15/20",
//                         0.75,
//                         const Color(0xFF5F2EFF),
//                         theme,
//                             () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => QuizPage(
//                                 taskQuestions: germanQuestions,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: continueCard(
//                         "Spanish\nLanguage",
//                         "10/30",
//                         0.33,
//                         Colors.orange,
//                         theme,
//                             () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => QuizPage(
//                                 taskQuestions: germanQuestions,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 30),
//                 sectionTitle("Featured Courses", theme),
//                 const SizedBox(height: 15),
//                 featuredCard("Grammar Quiz", "Business English", "2 hours", theme),
//                 const SizedBox(height: 15),
//                 featuredCard("Online Phrases", "Business English", "2 hours", theme),
//
//                 const SizedBox(height: 20),
//
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFEFE3),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.emoji_events, color: Colors.orange),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           "Set Weekly Goal!\nUsers who set goals stay motivated.",
//                           style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget sectionTitle(String text, ThemeData theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.textTheme.titleLarge?.color)),
//         const Text("See All", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w500)),
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
//       VoidCallback? onTap,
//       ) {
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
//             Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.titleMedium?.color)),
//             const SizedBox(height: 5),
//             const Text("20 Classes - Easy", style: TextStyle(fontSize: 11, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget featuredCard(String title, String subtitle, String time, ThemeData theme) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage())),
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
//                   Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Text(time, style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }




//home fake
// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import '../../quiz/quiz_page.dart';
// import '../home3/progress_page.dart';
// import '../home2/task_page.dart';
// import '../home4/profile_page.dart';
// import '../home4/activity_page.dart';
// import '../homepagesetting/settings_page.dart';
// import '../homepagesetting/theme_notifier.dart';
// import '../../data/task_question_data.dart';
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
//
//   Map<String, dynamic>? user;
//   bool isLoadingUser = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUser();
//   }
//
//   Future<void> _loadUser() async {
//     final data = await ApiService.getProfile();
//
//     if (!mounted) return;
//
//     setState(() {
//       user = data;
//       isLoadingUser = false;
//     });
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
//           body: _getSelectedPage(),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: currentIndex,
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) {
//               setState(() {
//                 currentIndex = index;
//               });
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
//             // 🔥 Quan trọng: Gọi fetch lại dữ liệu mới nhất từ server
//             await _loadUser();
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
//   Widget _buildHomeContent() {
//     final theme = Theme.of(context);
//     final isDark = themeNotifier.value == ThemeMode.dark;
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
//
//                   // 🔔 Notification
//                   Stack(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.notifications_none,
//                             color: Colors.white, size: 26),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const NotificationPage(),
//                             ),
//                           ).then((_) {
//                             setState(() {});
//                           });
//                         },
//                       ),
//
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
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // 🔥 NAME FROM BACKEND
//               Text(
//                 "Hello, ${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold),
//               ),
//
//               const SizedBox(height: 5),
//               const Text(
//                 "What would you like to learn today?",
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 25),
//                 sectionTitle("Continue Course", theme),
//                 const SizedBox(height: 15),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: continueCard(
//                         "German\nLanguage",
//                         "15/20",
//                         0.75,
//                         const Color(0xFF5F2EFF),
//                         theme,
//                             () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => QuizPage(
//                                 taskQuestions: germanQuestions,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: continueCard(
//                         "Spanish\nLanguage",
//                         "10/30",
//                         0.33,
//                         Colors.orange,
//                         theme,
//                             () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => QuizPage(
//                                 taskQuestions: germanQuestions,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 30),
//                 sectionTitle("Featured Courses", theme),
//                 const SizedBox(height: 15),
//                 featuredCard("Grammar Quiz", "Business English", "2 hours", theme),
//                 const SizedBox(height: 15),
//                 featuredCard("Online Phrases", "Business English", "2 hours", theme),
//
//                 const SizedBox(height: 20),
//
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Colors.orange.withOpacity(0.2)
//                         : const Color(0xFFFFEFE3),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.emoji_events, color: Colors.orange),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           "Set Weekly Goal!\nUsers who set goals stay motivated.",
//                           style: TextStyle(
//                               fontSize: 13,
//                               color: theme.textTheme.bodyMedium?.color),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget sectionTitle(String text, ThemeData theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(text,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: theme.textTheme.titleLarge?.color)),
//         const Text("See All",
//             style: TextStyle(
//                 color: Color(0xFF5F2EFF), fontWeight: FontWeight.w500)),
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
//       VoidCallback? onTap,
//       ) {
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
//                   Text(progress,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                           color: theme.textTheme.bodyMedium?.color)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: theme.textTheme.titleMedium?.color)),
//             const SizedBox(height: 5),
//             const Text("20 Classes - Easy",
//                 style: TextStyle(fontSize: 11, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget featuredCard(
//       String title, String subtitle, String time, ThemeData theme) {
//     return GestureDetector(
//       onTap: () =>
//           Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage())),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(
//                   themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05),
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
//               child:
//               const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF)),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: theme.textTheme.titleMedium?.color)),
//                   const SizedBox(height: 4),
//                   Text(subtitle,
//                       style:
//                       const TextStyle(color: Colors.grey, fontSize: 13)),
//                 ],
//               ),
//             ),
//             Text(time,
//                 style: const TextStyle(
//                     color: Colors.blueGrey,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }





//
// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import '../../services/course_service.dart';
// import '../../models/course_model.dart';
// import '../home3/lesson_list_page.dart';
//
// import '../home3/progress_page.dart';
// import '../home2/task_page.dart';
// import '../home4/profile_page.dart';
// import '../home4/activity_page.dart';
// import '../homepagesetting/settings_page.dart';
// import '../homepagesetting/theme_notifier.dart';
//
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
//
//   Map<String, dynamic>? user;
//   List<Course> courses = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadAll();
//   }
//
//   Future<void> loadAll() async {
//     try {
//       final userData = await ApiService.getProfile();
//       final courseData = await CourseService.getCourses();
//
//       setState(() {
//         user = userData;
//         courses = courseData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print(e);
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
//           body: _getSelectedPage(),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: currentIndex,
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) => setState(() => currentIndex = index),
//             selectedItemColor: const Color(0xFF5F2EFF),
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Task"),
//               BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
//               BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
//         return _home();
//       case 1:
//         return TaskPage(onBack: () => setState(() => currentIndex = 0));
//       case 2:
//         return ProgressPage(onBack: () => setState(() => currentIndex = 0));
//       case 3:
//         return ProfilePage(
//           onBack: () => setState(() => currentIndex = 0),
//           onOpenActivity: () {},
//           onOpenSettings: () {},
//         );
//       default:
//         return _home();
//     }
//   }
//
//   Widget _home() {
//     final theme = Theme.of(context);
//
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Column(
//       children: [
//         // ===== HEADER =====
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
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(
//                       user?['avatarUrl'] ??
//                           "https://i.pravatar.cc/150?img=3",
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.notifications, color: Colors.white),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const NotificationPage()),
//                       );
//                     },
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Hello, ${user?['firstName'] ?? ''}",
//                 style: const TextStyle(color: Colors.white, fontSize: 22),
//               ),
//             ],
//           ),
//         ),
//
//         // ===== COURSE LIST =====
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: courses.length,
//             itemBuilder: (context, index) {
//               final c = courses[index];
//
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => LessonListPage(course: c),
//                     ),
//                   ).then((_) => loadAll()); // reload progress
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 15),
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: theme.cardColor,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.menu_book,
//                           color: Color(0xFF5F2EFF)),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Text(c.title,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       Text("${c.progressPercent ?? 0}%"),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }




//home mới api
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/api_service.dart';
import '../../services/token_service.dart';
import '../../models/course_model.dart';
import '../../notification/notification_page.dart';
import '../../services/notification_service.dart';
import '../homepagesetting/settings_page.dart';
import '../homepagesetting/theme_notifier.dart';
import '../homepagesetting/settings_page.dart';
import '../home3/progress_page.dart';
import '../home2/task_page.dart';
import '../home4/profile_page.dart';
import '../home4/activity_page.dart';
import '../../homepage/home3/LessonListPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  Map<String, dynamic>? user;
  List<Course> allCourses = [];
  List<Course> continueCourses = [];
  bool isLoadingUser = true;
  bool isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Hàm load tổng hợp cả user và khóa học
  Future<void> _loadData() async {
    await Future.wait([
      _loadUser(),
      _fetchCourses(),
    ]);
  }

  Future<void> _loadUser() async {
    final data = await ApiService.getProfile();
    if (!mounted) return;
    setState(() {
      user = data;
      isLoadingUser = false;
    });
  }

  Future<void> _fetchCourses() async {
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
        List<Course> fetched = list.map((e) => Course.fromJson(e)).toList();

        setState(() {
          allCourses = fetched;

          // --- LOGIC XỬ LÝ CONTINUE COURSE ---
          // 1. Sắp xếp tất cả khóa học theo tiến độ giảm dần
          fetched.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));

          // 2. Lọc danh sách đang học (0 < progress < 100)
          List<Course> inProgress = fetched.where((c) => c.progressPercent > 0 && c.progressPercent < 100).toList();
          // 3. Lọc danh sách chưa học (progress == 0)
          List<Course> notStarted = fetched.where((c) => c.progressPercent == 0).toList();

          if (inProgress.length >= 2) {
            // Nếu có >= 2 khóa dở: Lấy 2 khóa % cao nhất
            continueCourses = inProgress.take(2).toList();
          } else if (inProgress.length == 1) {
            // Nếu có 1 khóa dở: Lấy khóa đó + 1 khóa chưa học
            continueCourses = [inProgress.first];
            if (notStarted.isNotEmpty) continueCourses.add(notStarted.first);
          } else {
            // Nếu không có khóa nào dở: Lấy 2 khóa chưa học (0%)
            continueCourses = notStarted.take(2).toList();
          }

          isLoadingCourses = false;
        });
      }
    } catch (e) {
      print("Error home courses: $e");
      setState(() => isLoadingCourses = false);
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
          body: _getSelectedPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(() => currentIndex = index),
            selectedItemColor: const Color(0xFF5F2EFF),
            unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey,
            backgroundColor: theme.cardColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Task"),
              BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: "Stats"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
            ],
          ),
        );
      },
    );
  }

  Widget _getSelectedPage() {
    switch (currentIndex) {
      case 0: return _buildHomeContent();
      case 1: return TaskPage(onBack: () => setState(() => currentIndex = 0));
      case 2: return ProgressPage(onBack: () => setState(() => currentIndex = 0));
      case 3: return ProfilePage(
        onBack: () async {
          await _loadUser();
          setState(() => currentIndex = 0);
        },
        onOpenActivity: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityPage())),
        onOpenSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
      );
      default: return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final theme = Theme.of(context);
    final isDark = themeNotifier.value == ThemeMode.dark;

    return Column(
      children: [
        // --- HEADER TÍM ---
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
          decoration: const BoxDecoration(
            color: Color(0xFF5F2EFF),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: (user != null && user!['avatarUrl'] != null)
                        ? NetworkImage(user!['avatarUrl'])
                        : const NetworkImage("https://via.placeholder.com/150"),
                  ),
                  _buildNotificationBadge(),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hello, ${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text("What would you like to learn today?", style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  // Click See All -> Chuyển sang tab Stats (ProgressPage)
                  _buildSectionTitle("Continue Course", theme, onSeeAll: () {
                    setState(() => currentIndex = 2);
                  }),
                  const SizedBox(height: 15),

                  // HIỂN THỊ 2 KHÓA ĐANG HỌC
                  isLoadingCourses
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                    children: continueCourses.isEmpty
                        ? [const Text("No courses in progress")]
                        : continueCourses.map((course) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildContinueCard(course, theme),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle("Featured Courses", theme),
                  const SizedBox(height: 15),

                  // HIỂN THỊ TOÀN BỘ KHÓA HỌC
                  isLoadingCourses
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    children: allCourses.map((course) => _buildFeaturedCard(course, theme)).toList(),
                  ),

                  const SizedBox(height: 20),
                  _buildGoalBanner(isDark, theme),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildNotificationBadge() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage())).then((_) => setState(() {})),
        ),
        if (NotificationService.unreadCount() > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text(NotificationService.unreadCount().toString(), style: const TextStyle(color: Colors.white, fontSize: 8)),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String text, ThemeData theme, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.textTheme.titleLarge?.color)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text("See All", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w500)),
          ),
      ],
    );
  }

  Widget _buildContinueCard(Course course, ThemeData theme) {
    // Tính toán bài đã học: (phần trăm * tổng bài) / 100
    int learned = (course.progressPercent * course.totalLessons) ~/ 100;

    return GestureDetector(
      onTap: () => _openCourse(course),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 65, height: 65,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: course.progressPercent / 100,
                    strokeWidth: 6,
                    backgroundColor: theme.disabledColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(course.progressPercent > 50 ? const Color(0xFF5F2EFF) : Colors.orange),
                  ),
                  Text("${course.progressPercent}%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: theme.textTheme.bodyMedium?.color)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(course.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.titleMedium?.color)),
            const SizedBox(height: 5),
            Text("$learned/${course.totalLessons} Lessons", style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Course course, ThemeData theme) {
    return GestureDetector(
      onTap: () => _openCourse(course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF5F2EFF).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.textTheme.titleMedium?.color)),
                  Text(course.languageName, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(course.level, style: const TextStyle(color: Colors.blueGrey, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalBanner(bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFEFE3), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(child: Text("Set Weekly Goal!\nUsers who set goals stay motivated.", style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color))),
        ],
      ),
    );
  }

  void _openCourse(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonListPage(courseId: course.id, courseTitle: course.title),
      ),
    ).then((_) => _fetchCourses()); // Load lại khi quay về để cập nhật % tiến độ
  }
}