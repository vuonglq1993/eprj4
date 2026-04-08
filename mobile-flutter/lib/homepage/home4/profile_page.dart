// import 'package:flutter/material.dart';
// import '../../services/fake_auth.dart';
// import '../homepagesetting/language_selection_page.dart';
// // Import theme_notifier để lắng nghe trạng thái đổi màu
// import '../homepagesetting/theme_notifier.dart';
//
// class ProfilePage extends StatelessWidget {
//   final VoidCallback onBack;
//   final VoidCallback onOpenActivity;
//   final VoidCallback onOpenSettings;
//
//   const ProfilePage({
//     super.key,
//     required this.onBack,
//     required this.onOpenActivity,
//     required this.onOpenSettings,
//   });
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
//         final String displayUserName = FakeAuth.userName ?? "Guest";
//
//         return Scaffold(
//           // 2. Sử dụng màu nền từ Theme
//           backgroundColor: theme.scaffoldBackgroundColor,
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím thương hiệu
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//               onPressed: onBack,
//             ),
//             title: const Text(
//               "Profile",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.settings_outlined, color: Colors.white),
//                 onPressed: onOpenSettings,
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//
//           body: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 35),
//
//                       // AVATAR
//                       CircleAvatar(
//                         radius: 45,
//                         backgroundColor: theme.cardColor,
//                         backgroundImage: FakeAuth.avatar != null
//                             ? FileImage(FakeAuth.avatar!)
//                             : const NetworkImage("https://i.pravatar.cc/150?img=3") as ImageProvider,
//                       ),
//
//                       const SizedBox(height: 15),
//
//                       // TÊN NGƯỜI DÙNG
//                       Text(
//                         displayUserName,
//                         style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: theme.textTheme.titleLarge?.color // Tự động Đen/Trắng
//                         ),
//                       ),
//
//                       const Text(
//                         "Joined March 2023",
//                         style: TextStyle(color: Colors.grey, fontSize: 14),
//                       ),
//
//                       const SizedBox(height: 25),
//
//                       // NÚT ADD LANGUAGE
//                       OutlinedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Color(0xFF5F2EFF), width: 1.5),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                         ),
//                         child: const Text(
//                           "My Languages",
//                           style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold),
//                         ),
//                       ),
//
//                       // 3. Cập nhật màu Divider
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 25),
//                         child: Divider(
//                             indent: 30,
//                             endIndent: 30,
//                             color: theme.dividerColor.withOpacity(0.1)
//                         ),
//                       ),
//
//                       // --- My Activity & Achievement ---
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           children: [
//                             _buildSectionHeader("My Activity", onOpenActivity, theme),
//                             const SizedBox(height: 15),
//                             _buildActivityCard(theme, isDark),
//                             const SizedBox(height: 35),
//                             _buildSectionHeader("Achievement", () {}, theme),
//                             const SizedBox(height: 15),
//                             Row(
//                               children: [
//                                 Expanded(child: _buildAchievementCard("German Language", "Level 1", "🇩🇪", theme)),
//                                 const SizedBox(width: 15),
//                                 Expanded(child: _buildAchievementCard("Spanish Language", "Level 2", "🇪🇸", theme)),
//                               ],
//                             ),
//                             const SizedBox(height: 30),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSectionHeader(String title, VoidCallback onTap, ThemeData theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title,
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.titleMedium?.color
//             )),
//         GestureDetector(
//           onTap: onTap,
//           child: const Text("View All",
//               style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w600, fontSize: 13)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActivityCard(ThemeData theme, bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         // 4. Thay đổi màu xám sáng cố định thành màu card hoặc màu nền tối hơn một chút
//         color: isDark ? theme.cardColor : const Color(0xFFF4F5F7),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.access_time_filled, color: Colors.red, size: 22),
//               const SizedBox(width: 12),
//               Text("8h : 20 min",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17,
//                       color: theme.textTheme.bodyLarge?.color
//                   )),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               // Màu nền của nút chọn tuần
//                 color: isDark ? Colors.white10 : Colors.white,
//                 borderRadius: BorderRadius.circular(10)
//             ),
//             child: const Row(
//               children: [
//                 Text("This Week", style: TextStyle(color: Color(0xFF4B00D1), fontSize: 12, fontWeight: FontWeight.bold)),
//                 Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF4B00D1)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAchievementCard(String title, String level, String flagEmoji, ThemeData theme) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 22),
//       decoration: BoxDecoration(
//         color: theme.cardColor, // Đổi theo theme
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
//       ),
//       child: Column(
//         children: [
//           Text(flagEmoji, style: const TextStyle(fontSize: 38)),
//           const SizedBox(height: 12),
//           Text(title,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                   color: theme.textTheme.titleSmall?.color
//               )),
//           Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }


//hàm cũ achivement fake
// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import '../homepagesetting/language_selection_page.dart';
// import '../homepagesetting/theme_notifier.dart';
//
// class ProfilePage extends StatefulWidget {
//   final VoidCallback onBack;
//   final VoidCallback onOpenActivity;
//   final VoidCallback onOpenSettings;
//
//   const ProfilePage({
//     super.key,
//     required this.onBack,
//     required this.onOpenActivity,
//     required this.onOpenSettings,
//   });
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? user;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUser();
//   }
//
//   Future<void> _fetchUser() async {
//     final data = await ApiService.getProfile();
//
//     if (!mounted) return;
//
//     setState(() {
//       user = data;
//       isLoading = false;
//     });
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
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//             title: const Text(
//               "Profile",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.settings_outlined, color: Colors.white),
//                 onPressed: widget.onOpenSettings,
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 35),
//
//                       // ✅ AVATAR từ backend
//                       CircleAvatar(
//                         radius: 45,
//                         backgroundColor: theme.cardColor,
//                         backgroundImage: user?['avatarUrl'] != null
//                             ? NetworkImage(user!['avatarUrl'])
//                             : const NetworkImage("https://i.pravatar.cc/150?img=3"),
//                       ),
//
//                       const SizedBox(height: 15),
//
//                       // ✅ TÊN USER (first + last)
//                       Text(
//                         "${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                       ),
//
//                       const SizedBox(height: 5),
//
//                       // ✅ EMAIL (thay cho Joined)
//                       Text(
//                         user?['email'] ?? '',
//                         style: const TextStyle(color: Colors.grey, fontSize: 14),
//                       ),
//
//                       const SizedBox(height: 25),
//
//                       // BUTTON
//                       OutlinedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const LanguageSelectionPage()),
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Color(0xFF5F2EFF), width: 1.5),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                         ),
//                         child: const Text(
//                           "My Languages",
//                           style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 25),
//                         child: Divider(
//                           indent: 30,
//                           endIndent: 30,
//                           color: theme.dividerColor.withOpacity(0.1),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           children: [
//                             _buildSectionHeader("My Activity", widget.onOpenActivity, theme),
//                             const SizedBox(height: 15),
//                             _buildActivityCard(theme, isDark),
//                             const SizedBox(height: 35),
//                             _buildSectionHeader("Achievement", () {}, theme),
//                             const SizedBox(height: 15),
//                             Row(
//                               children: [
//                                 Expanded(child: _buildAchievementCard("German Language", "Level 1", "🇩🇪", theme)),
//                                 const SizedBox(width: 15),
//                                 Expanded(child: _buildAchievementCard("Spanish Language", "Level 2", "🇪🇸", theme)),
//                               ],
//                             ),
//                             const SizedBox(height: 30),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSectionHeader(String title, VoidCallback onTap, ThemeData theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title,
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.titleMedium?.color)),
//         GestureDetector(
//           onTap: onTap,
//           child: const Text("View All",
//               style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w600, fontSize: 13)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActivityCard(ThemeData theme, bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: isDark ? theme.cardColor : const Color(0xFFF4F5F7),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.access_time_filled, color: Colors.red, size: 22),
//               const SizedBox(width: 12),
//               Text("8h : 20 min",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17,
//                       color: theme.textTheme.bodyLarge?.color)),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//                 color: isDark ? Colors.white10 : Colors.white,
//                 borderRadius: BorderRadius.circular(10)),
//             child: const Row(
//               children: [
//                 Text("This Week",
//                     style: TextStyle(color: Color(0xFF4B00D1), fontSize: 12, fontWeight: FontWeight.bold)),
//                 Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF4B00D1)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAchievementCard(String title, String level, String flagEmoji, ThemeData theme) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 22),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
//       ),
//       child: Column(
//         children: [
//           Text(flagEmoji, style: const TextStyle(fontSize: 38)),
//           const SizedBox(height: 12),
//           Text(title,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                   color: theme.textTheme.titleSmall?.color)),
//           Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }


//hàm mới achivent thật
// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import '../homepagesetting/language_selection_page.dart';
// import '../homepagesetting/theme_notifier.dart';
// // Thêm các import cần thiết để gọi API khóa học
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/token_service.dart';
// import '../../models/course_model.dart';
// import '../../services/progress_service.dart';
// import '../../models/stats_model.dart';
//
// class ProfilePage extends StatefulWidget {
//   final VoidCallback onBack;
//   final VoidCallback onOpenActivity;
//   final VoidCallback onOpenSettings;
//
//   const ProfilePage({
//     super.key,
//     required this.onBack,
//     required this.onOpenActivity,
//     required this.onOpenSettings,
//   });
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? user;
//   bool isLoading = true;
//   // 🔥 Biến lưu danh sách khóa học đã hoàn thành
//   List<Course> completedCourses = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialData();
//   }
//
//   // 🔥 Hàm load dữ liệu ban đầu
//   Future<void> _fetchInitialData() async {
//     setState(() => isLoading = true);
//     await Future.wait([
//       _fetchUser(),
//       _fetchCompletedCourses(), // Gọi thêm cái này để lấy Achievement thật
//     ]);
//     if (mounted) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _fetchUser() async {
//     final data = await ApiService.getProfile();
//     if (!mounted) return;
//     setState(() {
//       user = data;
//     });
//   }
//
//   // 🔥 HÀM LẤY ACHIEVEMENT THẬT TỪ API KHÓA HỌC
//   Future<void> _fetchCompletedCourses() async {
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
//
//         // Chỉ lấy những khóa học có progress là 100%
//         List<Course> allCourses = list.map((e) => Course.fromJson(e)).toList();
//         completedCourses = allCourses.where((c) => (c.progressPercent ?? 0) >= 100).toList();
//       }
//     } catch (e) {
//       print("Error fetching achievements: $e");
//     }
//   }
//
//   // Hàm phụ lấy cờ theo tên khóa học
//   String _getFlagEmoji(String title) {
//     if (title.contains("German")) return "🇩🇪";
//     if (title.contains("Spanish")) return "🇪🇸";
//     if (title.contains("English")) return "🇬🇧";
//     if (title.contains("French")) return "🇫🇷";
//     if (title.contains("Japanese")) return "🇯🇵";
//     return "🏆";
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
//
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF4B00D1),
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//               onPressed: widget.onBack,
//             ),
//             title: const Text(
//               "Profile",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.settings_outlined, color: Colors.white),
//                 onPressed: widget.onOpenSettings,
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 35),
//
//                       // ✅ GIỮ NGUYÊN AVATAR
//                       CircleAvatar(
//                         radius: 45,
//                         backgroundColor: theme.cardColor,
//                         backgroundImage: user?['avatarUrl'] != null
//                             ? NetworkImage(user!['avatarUrl'])
//                             : const NetworkImage("https://i.pravatar.cc/150?img=3"),
//                       ),
//
//                       const SizedBox(height: 15),
//
//                       // ✅ GIỮ NGUYÊN TÊN USER
//                       Text(
//                         "${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                       ),
//
//                       const SizedBox(height: 5),
//
//                       // ✅ GIỮ NGUYÊN EMAIL
//                       Text(
//                         user?['email'] ?? '',
//                         style: const TextStyle(color: Colors.grey, fontSize: 14),
//                       ),
//
//                       const SizedBox(height: 25),
//
//                       // ✅ GIỮ NGUYÊN BUTTON MY LANGUAGES
//                       OutlinedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const LanguageSelectionPage()),
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Color(0xFF5F2EFF), width: 1.5),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                         ),
//                         child: const Text(
//                           "My Languages",
//                           style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 25),
//                         child: Divider(
//                           indent: 30,
//                           endIndent: 30,
//                           color: theme.dividerColor.withOpacity(0.1),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           children: [
//                             // ✅ GIỮ NGUYÊN MY ACTIVITY
//                             _buildSectionHeader("My Activity", widget.onOpenActivity, theme),
//                             const SizedBox(height: 15),
//                             _buildActivityCard(theme, isDark),
//                             const SizedBox(height: 35),
//
//                             // 🔥 SỬA PHẦN ACHIEVEMENT (HIỂN THỊ DỮ LIỆU THẬT)
//                             _buildSectionHeader("Achievement", () {}, theme),
//                             const SizedBox(height: 15),
//
//                             // Logic hiển thị grid achievement thật
//                             completedCourses.isEmpty
//                                 ? _buildNoAchievement(theme) // Nếu chưa xong khóa nào
//                                 : GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: completedCourses.length,
//                               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 15,
//                                 mainAxisSpacing: 15,
//                                 childAspectRatio: 0.9,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final course = completedCourses[index];
//                                 return _buildAchievementCard(
//                                     course.title,
//                                     "Level ${course.level}",
//                                     _getFlagEmoji(course.title),
//                                     theme
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 30),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Widget hiển thị khi chưa có thành tựu nào
//   Widget _buildNoAchievement(ThemeData theme) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
//       ),
//       child: const Text(
//         "No achievements yet. Finish a course to earn one!",
//         textAlign: TextAlign.center,
//         style: TextStyle(color: Colors.grey),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, VoidCallback onTap, ThemeData theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title,
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.titleMedium?.color)),
//         GestureDetector(
//           onTap: onTap,
//           child: const Text("View All",
//               style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w600, fontSize: 13)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActivityCard(ThemeData theme, bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: isDark ? theme.cardColor : const Color(0xFFF4F5F7),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.access_time_filled, color: Colors.red, size: 22),
//               const SizedBox(width: 12),
//               Text("8h : 20 min",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17,
//                       color: theme.textTheme.bodyLarge?.color)),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//                 color: isDark ? Colors.white10 : Colors.white,
//                 borderRadius: BorderRadius.circular(10)),
//             child: const Row(
//               children: [
//                 Text("This Week",
//                     style: TextStyle(color: Color(0xFF4B00D1), fontSize: 12, fontWeight: FontWeight.bold)),
//                 Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF4B00D1)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAchievementCard(String title, String level, String flagEmoji, ThemeData theme) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 22),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(flagEmoji, style: const TextStyle(fontSize: 38)),
//           const SizedBox(height: 12),
//           Text(title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                   color: theme.textTheme.titleSmall?.color)),
//           Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../homepagesetting/language_selection_page.dart';
import '../homepagesetting/theme_notifier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/token_service.dart';
import '../../models/course_model.dart';
import '../../services/progress_service.dart';
import '../../models/stats_model.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenActivity;
  final VoidCallback onOpenSettings;

  const ProfilePage({
    super.key,
    required this.onBack,
    required this.onOpenActivity,
    required this.onOpenSettings,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  List<Course> completedCourses = [];

  StatsResponse? weeklyStats;
  String activityTimeText = "0m";

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _fetchUser(),
      _fetchCompletedCourses(),
      _fetchWeeklyStats(),
    ]);
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchUser() async {
    final data = await ApiService.getProfile();
    if (!mounted) return;
    setState(() {
      user = data;
    });
  }

  Future<void> _fetchCompletedCourses() async {
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
        List<Course> allCourses = list.map((e) => Course.fromJson(e)).toList();
        completedCourses =
            allCourses.where((c) => (c.progressPercent ?? 0) >= 100).toList();
      }
    } catch (e) {
      print("Error fetching achievements: $e");
    }
  }

  Future<void> _fetchWeeklyStats() async {
    try {
      final stats = await ProgressApiService.getStats("WEEK");
      if (!mounted) return;

      setState(() {
        weeklyStats = stats;
        activityTimeText = _formatMinutes(stats.totalMinutes);
      });
    } catch (e) {
      print("Error fetching weekly stats: $e");
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

  String _getFlagEmoji(String title) {
    if (title.contains("German")) return "🇩🇪";
    if (title.contains("Spanish")) return "🇪🇸";
    if (title.contains("English")) return "🇬🇧";
    if (title.contains("French")) return "🇫🇷";
    if (title.contains("Japanese")) return "🇯🇵";
    return "🏆";
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
              onPressed: widget.onBack,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: widget.onOpenSettings,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: theme.cardColor,
                        backgroundImage: user?['avatarUrl'] != null
                            ? NetworkImage(user!['avatarUrl'])
                            : const NetworkImage("https://i.pravatar.cc/150?img=3"),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?['email'] ?? '',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 25),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LanguageSelectionPage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF5F2EFF),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "My Languages",
                          style: TextStyle(
                            color: Color(0xFF5F2EFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Divider(
                          indent: 30,
                          endIndent: 30,
                          color: theme.dividerColor.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildSectionHeader(
                              "My Activity",
                              widget.onOpenActivity,
                              theme,
                            ),
                            const SizedBox(height: 15),
                            _buildActivityCard(theme, isDark, activityTimeText),
                            const SizedBox(height: 35),
                            _buildSectionHeader("Achievement", () {}, theme),
                            const SizedBox(height: 15),
                            completedCourses.isEmpty
                                ? _buildNoAchievement(theme)
                                : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: completedCourses.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final course = completedCourses[index];
                                return _buildAchievementCard(
                                  course.title,
                                  "Level ${course.level}",
                                  _getFlagEmoji(course.title),
                                  theme,
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoAchievement(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: const Text(
        "No achievements yet. Finish a course to earn one!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "View All",
            style: TextStyle(
              color: Color(0xFF5F2EFF),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(
      ThemeData theme,
      bool isDark,
      String activityText,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled, color: Colors.red, size: 22),
              const SizedBox(width: 12),
              Text(
                activityText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Text(
                  "This Week",
                  style: TextStyle(
                    color: Color(0xFF4B00D1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF4B00D1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      String title,
      String level,
      String flagEmoji,
      ThemeData theme,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(flagEmoji, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: theme.textTheme.titleSmall?.color,
            ),
          ),
          Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}