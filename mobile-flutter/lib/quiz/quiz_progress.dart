// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart'; // Nhớ cài package này
// import '../services/exercise_service.dart';
// import '../models/question_model.dart'; // Đảm bảo QuestionType enum nằm đây
// import 'widgets/image_choice_widget.dart';
// import 'widgets/word_choice_widget.dart';
// import 'widgets/input_field_widget.dart';
// import 'lesson_completed_page.dart';
// import '../homepage/homepagesetting/theme_notifier.dart';
// import '../services/study_log_service.dart';
//
// class QuizProgressPage extends StatefulWidget {
//   final String courseId;
//   final String lessonId;
//
//
//   const QuizProgressPage({
//     super.key,
//     required this.courseId,
//     required this.lessonId
//   });
//
//   @override
//   State<QuizProgressPage> createState() => _QuizProgressPageState();
// }
//
// class _QuizProgressPageState extends State<QuizProgressPage> {
//   Set<int> submittedQuestions = {};
//   int backendTotalLessonScore = 0;
//   int totalLessonPoints = 0;
//   // --- Quản lý trạng thái PageView ---
//   final PageController _pageController = PageController();
//   int currentIndex = 0;
//   bool isLoading = true;
//   String? errorMessage;
//   DateTime? startTime;
//   bool isSubmitting = false;
//
//   // --- Quản lý trạng thái câu hỏi hiện tại ---
//   bool isChecked = false;
//   bool? isCorrect;
//   final TextEditingController inputController = TextEditingController();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   // --- Dữ liệu ---
//   List<Question> questions = [];
//   Map<int, String> userAnswers = {}; // Lưu câu trả lời của user theo index câu hỏi
//
//   @override
//   void initState() {
//     super.initState();
//     // startTime = DateTime.now(); // ⏱ bắt đầu học
//     _fetchData();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     inputController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   // --- 1. Lấy dữ liệu thật từ DB ---
//   Future<void> _fetchData() async {
//     print("LOAD LESSON ID: ${widget.lessonId}");
//     try {
//       final data = await ExerciseService.getExercises(widget.courseId, widget.lessonId);
//       if (mounted) {
//         setState(() {
//           questions = data;
//           totalLessonPoints = questions.fold<int>(0, (sum, q) => sum + q.points);
//           isLoading = false;
//           startTime = DateTime.now();
//
//           if (questions.isEmpty) {
//             errorMessage = "Bài học này chưa có bài tập.";
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           errorMessage = "Lỗi tải bài tập: $e";
//         });
//       }
//     }
//   }
//
//   // --- 2. Logic xử lý giao diện ---
//
//   void _goBack() {
//     if (currentIndex > 0) {
//       _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   void _playAudio(String text) async {
//     // Backend chưa gửi URL thật, đây là text-to-speech giả lập
//     // Nếu có URL audio thật thì dùng UrlSource(url)
//     // await _audioPlayer.play(UrlSource(url));
//     print("Playing audio for: $text");
//   }
//
//   // --- 4. Logic Next / Hoàn thành ---
//   Future<void> _handleNext() async {
//     if (isSubmitting) return;
//
//     setState(() {
//       isSubmitting = true;
//     });
//
//     final q = questions[currentIndex];
//     String answer = "";
//
//     try {
//       // 1. Chuẩn hóa answer đúng format backend cần
//       if (q.type == QuestionType.imageChoice || q.type == QuestionType.wordChoice) {
//         final selectedText = userAnswers[currentIndex] ?? "";
//
//         if (selectedText.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Vui lòng chọn đáp án")),
//           );
//           return;
//         }
//
//         final selectedIndex = q.options.indexOf(selectedText);
//         if (selectedIndex == -1) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Đáp án không hợp lệ")),
//           );
//           return;
//         }
//
//         // Backend cần index string: "0", "1", "2"
//         answer = selectedIndex.toString();
//       } else {
//         answer = inputController.text.trim();
//
//         if (answer.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Vui lòng nhập đáp án")),
//           );
//           return;
//         }
//       }
//
//       // 2. Submit backend và lấy kết quả CHẤM THẬT
//       final result = await ExerciseService.submitSingle(
//         widget.courseId,
//         widget.lessonId,
//         q.id,
//         answer,
//       );
//
//       // 3. Đồng bộ điểm theo backend
//       setState(() {
//         backendTotalLessonScore = result.totalLessonScore;
//         submittedQuestions.add(currentIndex);
//       });
//
//       // 4. Sang câu tiếp theo hoặc finish
//       if (currentIndex < questions.length - 1) {
//         _pageController.nextPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       } else {
//         final durationSeconds = DateTime.now().difference(startTime!).inSeconds;
//
//         // % cuối cùng phải theo backend
//         final int finalPercent = totalLessonPoints > 0
//             ? ((backendTotalLessonScore / totalLessonPoints) * 100).round()
//             : 0;
//
//         print("BACKEND TOTAL LESSON SCORE: $backendTotalLessonScore");
//         print("TOTAL LESSON POINTS: $totalLessonPoints");
//         print("FINAL PERCENT FROM BACKEND: $finalPercent");
//         print("LESSON ID: ${widget.lessonId}");
//
//         await StudyLogService.logStudySession(
//           lessonId: widget.lessonId,
//           durationSeconds: durationSeconds,
//           score: finalPercent,
//           activityType: "EXERCISE_SUBMIT",
//         );
//
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
//           );
//         }
//       }
//     } catch (e) {
//       print("ERROR: $e");
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Có lỗi khi nộp bài: $e")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => isSubmitting = false);
//       }
//     }
//   }
//
//   // --- 5. Biểu diễn Widget Bài tập dựa theo Type ---
//   Widget _buildExerciseContent(Question q, ThemeData theme) {
//     switch (q.type) {
//       case QuestionType.wordChoice:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               q.subTitle ?? "Chọn đáp án đúng",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.bodyLarge?.color,
//               ),
//             ),
//             const SizedBox(height: 20),
//             WordChoiceWidget(
//               options: q.options,
//               selectedOption: userAnswers[currentIndex],
//               onSelect: isChecked
//                   ? null
//                   : (val) => setState(() => userAnswers[currentIndex] = val),
//             ),
//           ],
//         );
//
//       case QuestionType.imageChoice:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               q.subTitle ?? "Nghe và chọn đáp án",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.bodyLarge?.color,
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (q.audioText != null)
//               IconButton(
//                 icon: const Icon(Icons.volume_up, size: 40, color: Color(0xFF5F2EFF)),
//                 onPressed: () => _playAudio(q.audioText!),
//               ),
//             WordChoiceWidget(
//               options: q.options,
//               selectedOption: userAnswers[currentIndex],
//               onSelect: isChecked
//                   ? null
//                   : (val) => setState(() => userAnswers[currentIndex] = val),
//             ),
//           ],
//         );
//
//       case QuestionType.inputField:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               q.subTitle ?? "Điền vào chỗ trống",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: theme.textTheme.bodyLarge?.color,
//               ),
//             ),
//             const SizedBox(height: 20),
//             InputFieldWidget(
//               controller: inputController,
//               enabled: !isChecked,
//             ),
//           ],
//         );
//
//       default:
//         return Text("Loại bài tập chưa được hỗ trợ giao diện.");
//     }
//   }
//
//   // --- 6. Build Main UI ---
//   // @override
//   // Widget build(BuildContext context) {
//   //   return ValueListenableBuilder<ThemeMode>(
//   //     valueListenable: themeNotifier,
//   //     builder: (context, mode, child) {
//   //       final theme = Theme.of(context);
//   //
//   //       if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   //       if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));
//   //
//   //       final totalQuestions = questions.length;
//   //
//   //       return Scaffold(
//   //         backgroundColor: theme.scaffoldBackgroundColor,
//   //         appBar: AppBar(
//   //           elevation: 0,
//   //           backgroundColor: const Color(0xFF4B00D1),
//   //           leading: IconButton(
//   //             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//   //             onPressed: _goBack,
//   //           ),
//   //           actions: [
//   //             IconButton(
//   //               icon: const Icon(Icons.close, color: Colors.white),
//   //               onPressed: () => Navigator.pop(context),
//   //             ),
//   //           ],
//   //           title: Row(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Stack(
//   //                 alignment: Alignment.center,
//   //                 children: [
//   //                   SizedBox(
//   //                     width: 40,
//   //                     height: 40,
//   //                     child: CircularProgressIndicator(
//   //                       value: (currentIndex + 1) / totalQuestions,
//   //                       strokeWidth: 4,
//   //                       backgroundColor: Colors.white24,
//   //                       valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//   //                     ),
//   //                   ),
//   //                   Text(
//   //                     "${((currentIndex + 1) / totalQuestions * 100).toInt()}%",
//   //                     style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
//   //                   ),
//   //                 ],
//   //               ),
//   //               const SizedBox(width: 12),
//   //               Text(
//   //                 "Question ${currentIndex + 1}/$totalQuestions",
//   //                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//   //               ),
//   //             ],
//   //           ),
//   //           centerTitle: true,
//   //         ),
//   //         body: Column(
//   //           children: [
//   //             Expanded(
//   //               child: PageView.builder(
//   //                 controller: _pageController,
//   //                 physics: const NeverScrollableScrollPhysics(),
//   //                 onPageChanged: (index) {
//   //                   setState(() {
//   //                     currentIndex = index;
//   //                     isChecked = false;
//   //                     isCorrect = null;
//   //                     inputController.text = userAnswers[index] ?? "";
//   //                   });
//   //                 },
//   //                 itemCount: totalQuestions,
//   //                 itemBuilder: (context, index) {
//   //                   final q = questions[index];
//   //                   return SingleChildScrollView(
//   //                     padding: const EdgeInsets.all(24),
//   //                     child: Column(
//   //                       crossAxisAlignment: CrossAxisAlignment.start,
//   //                       children: [
//   //                         Text(
//   //                           q.title,
//   //                           style: TextStyle(
//   //                             fontSize: 24,
//   //                             fontWeight: FontWeight.bold,
//   //                             color: theme.textTheme.titleLarge?.color,
//   //                           ),
//   //                         ),
//   //                         const SizedBox(height: 30),
//   //                         _buildExerciseContent(q, theme),
//   //                       ],
//   //                     ),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //             isChecked
//   //                 ? _buildResultBottom(theme)
//   //                 : _buildCheckBottom(),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//
//         if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));
//
//         final totalQuestions = questions.length;
//         // Tính toán tỉ lệ hoàn thành cho thanh progress ngang
//         double progressValue = (currentIndex + 1) / totalQuestions;
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: const Color(0xFF4B00D1),
//             // Nút quay lại (mũi tên)
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: _goBack,
//             ),
//             // Nút X để thoát
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//             // Phần tiêu đề chứa thanh Progress ngang và số câu
//             title: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 10),
//                 // Thanh progress ngang với bo góc
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.6, // Độ dài thanh
//                     height: 10, // Độ dày thanh
//                     child: LinearProgressIndicator(
//                       value: progressValue,
//                       backgroundColor: Colors.white24,
//                       // Màu của thanh chạy (màu trắng hoặc xanh nhạt cho nổi)
//                       valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 // Hiển thị số câu ngay bên dưới thanh progress
//                 Text(
//                   "${currentIndex + 1}/$totalQuestions",
//                   style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white
//                   ),
//                 ),
//               ],
//             ),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               // Phần nội dung câu hỏi (PageView)
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentIndex = index;
//                       isChecked = false;
//                       isCorrect = null;
//                       inputController.text = userAnswers[index] ?? "";
//                     });
//                   },
//                   itemCount: totalQuestions,
//                   itemBuilder: (context, index) {
//                     final q = questions[index];
//                     return SingleChildScrollView(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             q.title,
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: theme.textTheme.titleLarge?.color,
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//                           _buildExerciseContent(q, theme),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // Phần nút Check hoặc Kết quả đúng/sai ở dưới cùng
//               _buildNextBottom()
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//
//
//
//
//
//   Widget _buildNextBottom() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: ElevatedButton(
//             onPressed: _handleNext,
//             child: Text(
//               currentIndex == questions.length - 1 ? "Finish" : "Next",
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildResultBottom(ThemeData theme) {
//     bool correct = isCorrect == true;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: correct ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(correct ? Icons.check_circle : Icons.error, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text(
//                   correct ? "Correct Answer!" : "Wrong Answer!",
//                   style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: correct ? _handleNext : () => setState(() => isChecked = false),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: correct ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                 ),
//                 child: Text(
//                   correct ? (currentIndex == questions.length - 1 ? "Finish" : "Continue") : "Try again",
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//bản không time
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../services/exercise_service.dart';
// import '../models/question_model.dart';
// import 'widgets/word_choice_widget.dart';
// import 'widgets/input_field_widget.dart';
// import 'lesson_completed_page.dart';
// import '../homepage/homepagesetting/theme_notifier.dart';
// import '../services/study_log_service.dart';
//
// class QuizProgressPage extends StatefulWidget {
//   final String courseId;
//   final String lessonId;
//
//   const QuizProgressPage({
//     super.key,
//     required this.courseId,
//     required this.lessonId,
//   });
//
//   @override
//   State<QuizProgressPage> createState() => _QuizProgressPageState();
// }
//
// class _QuizProgressPageState extends State<QuizProgressPage> {
//   final PageController _pageController = PageController();
//   final TextEditingController inputController = TextEditingController();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   int currentIndex = 0;
//   bool isLoading = true;
//   bool isSubmitting = false;
//   String? errorMessage;
//   DateTime? startTime;
//
//   List<Question> questions = [];
//   final Map<int, String> userAnswers = {};
//
//   int backendTotalLessonScore = 0;
//   int totalLessonPoints = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     inputController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchData() async {
//     try {
//       final data = await ExerciseService.getExercises(
//         widget.courseId,
//         widget.lessonId,
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         questions = data;
//         totalLessonPoints = data.fold<int>(0, (sum, q) => sum + q.points);
//         startTime = DateTime.now();
//         isLoading = false;
//
//         if (questions.isEmpty) {
//           errorMessage = "Bài học này chưa có bài tập.";
//         }
//       });
//     } catch (e) {
//       if (!mounted) return;
//
//       setState(() {
//         isLoading = false;
//         errorMessage = "Lỗi tải bài tập: $e";
//       });
//     }
//   }
//
//   void _goBack() {
//     if (currentIndex > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   Future<void> _playAudio(String text) async {
//     debugPrint("Playing audio for: $text");
//   }
//
//   String? _buildAnswerForBackend(Question q) {
//     if (q.type == QuestionType.wordChoice || q.type == QuestionType.imageChoice) {
//       final selectedText = userAnswers[currentIndex] ?? "";
//       if (selectedText.isEmpty) {
//         return null;
//       }
//
//       final selectedIndex = q.options.indexOf(selectedText);
//       if (selectedIndex == -1) {
//         return null;
//       }
//
//       return selectedIndex.toString();
//     }
//
//     final typedAnswer = inputController.text.trim();
//     if (typedAnswer.isEmpty) {
//       return null;
//     }
//     return typedAnswer;
//   }
//
//   Future<void> _handleNext() async {
//     if (isSubmitting || questions.isEmpty) return;
//
//     final q = questions[currentIndex];
//     final answer = _buildAnswerForBackend(q);
//
//     if (answer == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             q.type == QuestionType.inputField
//                 ? "Vui lòng nhập đáp án"
//                 : "Vui lòng chọn đáp án",
//           ),
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       isSubmitting = true;
//     });
//
//     try {
//       final result = await ExerciseService.submitSingle(
//         widget.courseId,
//         widget.lessonId,
//         q.id,
//         answer,
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         backendTotalLessonScore = result.totalLessonScore;
//       });
//
//       if (currentIndex < questions.length - 1) {
//         _pageController.nextPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       } else {
//         final durationSeconds = startTime == null
//             ? 0
//             : DateTime.now().difference(startTime!).inSeconds;
//
//         final int finalPercent = totalLessonPoints > 0
//             ? ((backendTotalLessonScore / totalLessonPoints) * 100).round()
//             : 0;
//
//         await StudyLogService.logStudySession(
//           lessonId: widget.lessonId,
//           durationSeconds: durationSeconds,
//           score: finalPercent,
//           activityType: "EXERCISE_SUBMIT",
//         );
//
//         if (!mounted) return;
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Có lỗi khi nộp bài: $e")),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           isSubmitting = false;
//         });
//       }
//     }
//   }
//
//   Widget _buildExerciseContent(Question q, ThemeData theme) {
//     switch (q.type) {
//       case QuestionType.wordChoice:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               q.subTitle ?? "Chọn đáp án đúng",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.bodyLarge?.color,
//               ),
//             ),
//             const SizedBox(height: 20),
//             WordChoiceWidget(
//               options: q.options,
//               selectedOption: userAnswers[currentIndex],
//               onSelect: (val) => setState(() => userAnswers[currentIndex] = val),
//             ),
//           ],
//         );
//
//       case QuestionType.imageChoice:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               q.subTitle ?? "Nghe và chọn đáp án",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.bodyLarge?.color,
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (q.audioText != null && q.audioText!.isNotEmpty)
//               IconButton(
//                 icon: const Icon(
//                   Icons.volume_up,
//                   size: 40,
//                   color: Color(0xFF5F2EFF),
//                 ),
//                 onPressed: () => _playAudio(q.audioText!),
//               ),
//             WordChoiceWidget(
//               options: q.options,
//               selectedOption: userAnswers[currentIndex],
//               onSelect: (val) => setState(() => userAnswers[currentIndex] = val),
//             ),
//           ],
//         );
//
//       case QuestionType.inputField:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               q.subTitle ?? "Điền vào chỗ trống",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: theme.textTheme.bodyLarge?.color,
//               ),
//             ),
//             const SizedBox(height: 20),
//             InputFieldWidget(
//               controller: inputController,
//               enabled: !isSubmitting,
//             ),
//           ],
//         );
//     }
//   }
//
//   Widget _buildNextBottom() {
//     final bool isLastQuestion = currentIndex == questions.length - 1;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: ElevatedButton(
//             onPressed: isSubmitting ? null : _handleNext,
//             child: Text(isSubmitting
//                 ? "Đang gửi..."
//                 : (isLastQuestion ? "Finish" : "Next")),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, mode, child) {
//         final theme = Theme.of(context);
//
//         if (isLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (errorMessage != null) {
//           return Scaffold(
//             body: Center(child: Text(errorMessage!)),
//           );
//         }
//
//         final int totalQuestions = questions.length;
//         final double progressValue =
//         totalQuestions == 0 ? 0 : (currentIndex + 1) / totalQuestions;
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: const Color(0xFF4B00D1),
//             leading: IconButton(
//               icon: const Icon(
//                 Icons.arrow_back_ios_new,
//                 color: Colors.white,
//                 size: 20,
//               ),
//               onPressed: _goBack,
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//             title: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 10),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.6,
//                     height: 10,
//                     child: LinearProgressIndicator(
//                       value: progressValue,
//                       backgroundColor: Colors.white24,
//                       valueColor:
//                       const AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "${currentIndex + 1}/$totalQuestions",
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentIndex = index;
//                       inputController.text = userAnswers[index] ?? "";
//                     });
//                   },
//                   itemCount: totalQuestions,
//                   itemBuilder: (context, index) {
//                     final q = questions[index];
//                     return SingleChildScrollView(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             q.title,
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: theme.textTheme.titleLarge?.color,
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//                           _buildExerciseContent(q, theme),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               _buildNextBottom(),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }



//bản có time
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/exercise_service.dart';
import '../models/question_model.dart';
import 'widgets/word_choice_widget.dart';
import 'widgets/input_field_widget.dart';
import 'lesson_completed_page.dart';
import '../homepage/homepagesetting/theme_notifier.dart';
import '../services/study_log_service.dart';

class QuizProgressPage extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final int lessonDurationMinutes;

  const QuizProgressPage({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.lessonDurationMinutes,
  });

  @override
  State<QuizProgressPage> createState() => _QuizProgressPageState();
}

class _QuizProgressPageState extends State<QuizProgressPage> {
  final PageController _pageController = PageController();
  final TextEditingController inputController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int currentIndex = 0;
  bool isLoading = true;
  bool isSubmitting = false;
  bool isCompletingLesson = false;
  String? errorMessage;
  DateTime? startTime;

  List<Question> questions = [];
  final Map<int, String> userAnswers = {};

  int backendTotalLessonScore = 0;
  int totalLessonPoints = 0;

  Timer? _lessonTimer;
  int remainingLessonSeconds = 0;
  bool _hasLoggedStudy = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _lessonTimer?.cancel();
    _pageController.dispose();
    inputController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ExerciseService.getExercises(
        widget.courseId,
        widget.lessonId,
      );

      if (!mounted) return;

      setState(() {
        questions = data;
        totalLessonPoints = data.fold<int>(0, (sum, q) => sum + q.points);
        startTime = DateTime.now();
        isLoading = false;

        if (questions.isEmpty) {
          errorMessage = "Bài học này chưa có bài tập.";
        }
      });

      if (questions.isNotEmpty) {
        _startLessonTimer();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = "Lỗi tải bài tập: $e";
      });
    }
  }

  void _startLessonTimer() {
    _lessonTimer?.cancel();

    final totalSeconds = widget.lessonDurationMinutes * 60;
    if (totalSeconds <= 0) {
      setState(() => remainingLessonSeconds = 0);
      return;
    }

    setState(() {
      remainingLessonSeconds = totalSeconds;
    });

    _lessonTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted || isCompletingLesson) {
        timer.cancel();
        return;
      }

      if (remainingLessonSeconds <= 1) {
        timer.cancel();
        setState(() {
          remainingLessonSeconds = 0;
        });
        await _handleTimeout();
      } else {
        setState(() {
          remainingLessonSeconds--;
        });
      }
    });
  }

  Future<void> _handleTimeout() async {
    if (isSubmitting || isCompletingLesson || questions.isEmpty) return;

    final q = questions[currentIndex];
    final answer = _buildAutoSubmitAnswer(q);

    await _submitQuestion(
      q: q,
      answer: answer,
      finishLessonAfterSubmit: true,
      triggeredByTimeout: true,
    );
  }

  void _goBack() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _playAudio(String text) async {
    debugPrint("Playing audio for: $text");
  }

  String? _buildAnswerForBackend(Question q) {
    if (q.type == QuestionType.wordChoice ||
        q.type == QuestionType.imageChoice) {
      final selectedText = userAnswers[currentIndex] ?? "";
      if (selectedText.isEmpty) {
        return null;
      }

      final selectedIndex = q.options.indexOf(selectedText);
      if (selectedIndex == -1) {
        return null;
      }

      return selectedIndex.toString();
    }

    final typedAnswer = inputController.text.trim();
    if (typedAnswer.isEmpty) {
      return null;
    }
    return typedAnswer;
  }

  String _buildAutoSubmitAnswer(Question q) {
    final answer = _buildAnswerForBackend(q);
    if (answer != null) return answer;

    if (q.type == QuestionType.wordChoice ||
        q.type == QuestionType.imageChoice) {
      return "-1";
    }

    return "__AUTO_TIMEOUT__";
  }

  Future<void> _handleNext() async {
    if (isSubmitting || isCompletingLesson || questions.isEmpty) return;

    final q = questions[currentIndex];
    final answer = _buildAnswerForBackend(q);

    if (answer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            q.type == QuestionType.inputField
                ? "Vui lòng nhập đáp án"
                : "Vui lòng chọn đáp án",
          ),
        ),
      );
      return;
    }

    final bool isLastQuestion = currentIndex == questions.length - 1;

    await _submitQuestion(
      q: q,
      answer: answer,
      finishLessonAfterSubmit: isLastQuestion,
      triggeredByTimeout: false,
    );
  }

  Future<void> _submitQuestion({
    required Question q,
    required String answer,
    required bool finishLessonAfterSubmit,
    required bool triggeredByTimeout,
  }) async {
    if (isSubmitting || isCompletingLesson) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final nowMillis = DateTime.now().millisecondsSinceEpoch;
      final lessonStartMillis =
          (startTime ?? DateTime.now()).millisecondsSinceEpoch;

      final result = await ExerciseService.submitSingle(
        widget.courseId,
        widget.lessonId,
        q.id,
        answer,
        clientStartTime: lessonStartMillis,
        clientSubmitTime: nowMillis,
      );

      if (!mounted) return;

      setState(() {
        backendTotalLessonScore = result.totalLessonScore;
      });

      if (finishLessonAfterSubmit) {
        await _completeLesson(showTimeoutMessage: triggeredByTimeout);
        return;
      }

      if (currentIndex < questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      if (!mounted) return;

      if (finishLessonAfterSubmit) {
        await _completeLesson(showTimeoutMessage: true);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi khi nộp bài: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<void> _completeLesson({bool showTimeoutMessage = false}) async {
    if (isCompletingLesson) return;

    isCompletingLesson = true;
    _lessonTimer?.cancel();

    final durationSeconds = startTime == null
        ? 0
        : DateTime.now().difference(startTime!).inSeconds;

    final int finalPercent = totalLessonPoints > 0
        ? ((backendTotalLessonScore / totalLessonPoints) * 100).round()
        : 0;

    if (!_hasLoggedStudy) {
      await StudyLogService.logStudySession(
        lessonId: widget.lessonId,
        durationSeconds: durationSeconds,
        score: finalPercent,
        activityType: "EXERCISE_SUBMIT",
      );
      _hasLoggedStudy = true;
    }

    if (!mounted) return;

    if (showTimeoutMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hết thời gian, bài đã được tự động nộp."),
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 350));
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
    );
  }

  String _formatTime(int seconds) {
    final int mm = seconds ~/ 60;
    final int ss = seconds % 60;
    final String m = mm.toString().padLeft(2, '0');
    final String s = ss.toString().padLeft(2, '0');
    return "$m:$s";
  }

  Color _timerColor() {
    if (remainingLessonSeconds <= 30) return Colors.redAccent;
    if (remainingLessonSeconds <= 60) return Colors.orangeAccent;
    return Colors.white;
  }

  Widget _buildTimerChip() {
    if (widget.lessonDurationMinutes <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: _timerColor(),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _formatTime(remainingLessonSeconds),
            style: TextStyle(
              color: _timerColor(),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(Question q, ThemeData theme) {
    switch (q.type) {
      case QuestionType.wordChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.subTitle ?? "Chọn đáp án đúng",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            WordChoiceWidget(
              options: q.options,
              selectedOption: userAnswers[currentIndex],
              onSelect: (val) => setState(() => userAnswers[currentIndex] = val),
            ),
          ],
        );

      case QuestionType.imageChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.subTitle ?? "Nghe và chọn đáp án",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            if (q.audioText != null && q.audioText!.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.volume_up,
                  size: 40,
                  color: Color(0xFF5F2EFF),
                ),
                onPressed: () => _playAudio(q.audioText!),
              ),
            WordChoiceWidget(
              options: q.options,
              selectedOption: userAnswers[currentIndex],
              onSelect: (val) => setState(() => userAnswers[currentIndex] = val),
            ),
          ],
        );

      case QuestionType.inputField:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.subTitle ?? "Điền vào chỗ trống",
              style: TextStyle(
                fontSize: 18,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            InputFieldWidget(
              controller: inputController,
              enabled: !isSubmitting && !isCompletingLesson,
            ),
          ],
        );
    }
  }

  Widget _buildNextBottom() {
    final bool isLastQuestion = currentIndex == questions.length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed:
            (isSubmitting || isCompletingLesson) ? null : _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5F2EFF),
              foregroundColor: Colors.white,
            ),
            child: Text(
              isSubmitting
                  ? "Đang gửi..."
                  : (isLastQuestion ? "Finish" : "Next"),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (errorMessage != null) {
          return Scaffold(
            body: Center(child: Text(errorMessage!)),
          );
        }

        final int totalQuestions = questions.length;
        final double progressValue =
        totalQuestions == 0 ? 0 : (currentIndex + 1) / totalQuestions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF4B00D1),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _goBack,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 10,
                          child: LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.white24,
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${currentIndex + 1}/$totalQuestions",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _buildTimerChip(),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                      inputController.text = userAnswers[index] ?? "";
                    });
                  },
                  itemCount: totalQuestions,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildExerciseContent(q, theme),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildNextBottom(),
            ],
          ),
        );
      },
    );
  }
}