// import 'package:flutter/material.dart';
// import '../services/exercise_service.dart';
// import '../homepage/home3/LessonListPage.dart';
// import 'lesson_completed_page.dart';
//
// class QuizProgressPage extends StatefulWidget {
//   final String courseId;
//   final String lessonId;
//
//
//   const QuizProgressPage({super.key, required this.courseId, required this.lessonId});
//
//   @override
//   State<QuizProgressPage> createState() => _QuizProgressPageState();
// }
//
// class _QuizProgressPageState extends State<QuizProgressPage> {
//   late Future<List<dynamic>> _exercisesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _exercisesFuture = ExerciseService.getExercises(widget.courseId, widget.lessonId);
//   }
//
//   void _finishQuiz() async {
//     // Gọi API nộp bài lên Backend
//     // Ở đây mình giả định nộp list rỗng hoặc list câu trả lời để kích hoạt lưu tiến độ
//     bool success = await ExerciseService.submitQuiz(widget.courseId, widget.lessonId, []);
//
//     if (success && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LessonCompletedPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Đang làm bài tập")),
//       body: FutureBuilder<List<dynamic>>(
//         future: _exercisesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
//           if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Không có câu hỏi"));
//
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) => ListTile(
//                     title: Text(snapshot.data![index]['title']),
//                     subtitle: Text(snapshot.data![index]['type']),
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: _finishQuiz,
//                 child: const Text("Hoàn thành & Lưu tiến độ"),
//               ),
//               const SizedBox(height: 30),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart'; // Nhớ cài package này
import '../services/exercise_service.dart';
import '../models/question_model.dart'; // Đảm bảo QuestionType enum nằm đây
import 'widgets/image_choice_widget.dart';
import 'widgets/word_choice_widget.dart';
import 'widgets/input_field_widget.dart';
import 'lesson_completed_page.dart';
import '../homepage/homepagesetting/theme_notifier.dart';
import '../services/study_log_service.dart';

class QuizProgressPage extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const QuizProgressPage({
    super.key,
    required this.courseId,
    required this.lessonId
  });

  @override
  State<QuizProgressPage> createState() => _QuizProgressPageState();
}

class _QuizProgressPageState extends State<QuizProgressPage> {
  // --- Quản lý trạng thái PageView ---
  final PageController _pageController = PageController();
  int currentIndex = 0;
  bool isLoading = true;
  String? errorMessage;
  DateTime? startTime;
  bool isSubmitting = false;

  // --- Quản lý trạng thái câu hỏi hiện tại ---
  bool isChecked = false;
  bool? isCorrect;
  final TextEditingController inputController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // --- Dữ liệu ---
  List<Question> questions = [];
  Map<int, String> userAnswers = {}; // Lưu câu trả lời của user theo index câu hỏi

  @override
  void initState() {
    super.initState();
    // startTime = DateTime.now(); // ⏱ bắt đầu học
    _fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    inputController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- 1. Lấy dữ liệu thật từ DB ---
  Future<void> _fetchData() async {
    try {
      final data = await ExerciseService.getExercises(widget.courseId, widget.lessonId);
      if (mounted) {
        setState(() {
          questions = data;
          isLoading = false;
          startTime = DateTime.now();
          if (questions.isEmpty) {
            errorMessage = "Bài học này chưa có bài tập.";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Lỗi tải bài tập: $e";
        });
      }
    }
  }

  // --- 2. Logic xử lý giao diện ---

  void _goBack() {
    if (currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  void _playAudio(String text) async {
    // Backend chưa gửi URL thật, đây là text-to-speech giả lập
    // Nếu có URL audio thật thì dùng UrlSource(url)
    // await _audioPlayer.play(UrlSource(url));
    print("Playing audio for: $text");
  }

  // --- 3. Logic Check đúng sai & Lưu câu trả lời ---
  void _handleCheck() {
    final q = questions[currentIndex];
    String userAnswer = "";

    if (q.type == QuestionType.inputField) {
      userAnswer = inputController.text.trim();
    } else {
      userAnswer = userAnswers[currentIndex] ?? "";
    }

    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn hoặc điền đáp án!")),
      );
      return;
    }

    final correct = userAnswer.toLowerCase() == q.correctAnswer.toLowerCase();

    setState(() {
      isChecked = true;
      isCorrect = correct;
      userAnswers[currentIndex] = userAnswer;
    });
  }

  // --- 4. Logic Next / Hoàn thành ---
  Future<void> _handleNext() async {
    if (isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    final q = questions[currentIndex];
    String answer = "";

    // ✅ Mapping đúng backend format
    if (q.type == QuestionType.imageChoice || q.type == QuestionType.wordChoice) {
      // Backend cần index của đáp án trong list options
      // int index = q.options.indexOf(userAnswers[currentIndex] ?? "");
      // answer = index.toString();

      int index = q.options.indexOf(userAnswers[currentIndex] ?? "");

      if (index == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi chọn đáp án")),
        );
        return;
      }

      answer = index.toString();
    } else {
      answer = userAnswers[currentIndex] ?? "";
    }

    try {
      // ✅ Submit backend từng câu một
      await ExerciseService.submitSingle(
        widget.courseId,
        widget.lessonId,
        q.id,
        answer,
      );

      if (currentIndex < questions.length - 1) {
        // Chuyển sang câu tiếp theo
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // 👉 KHI HOÀN THÀNH CÂU CUỐI: Gọi API ghi nhận phiên học (Study Log)
        int durationSeconds = DateTime.now().difference(startTime!).inSeconds;
        await StudyLogService.logStudySession(
          lessonId: widget.lessonId,
          durationSeconds: durationSeconds,
          score: 1000000, // Có thể tính điểm thực tế nếu muốn
          activityType: "EXERCISE_SUBMIT",
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi submit: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  // --- 5. Biểu diễn Widget Bài tập dựa theo Type ---
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
              onSelect: isChecked
                  ? null
                  : (val) => setState(() => userAnswers[currentIndex] = val),
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
            if (q.audioText != null)
              IconButton(
                icon: const Icon(Icons.volume_up, size: 40, color: Color(0xFF5F2EFF)),
                onPressed: () => _playAudio(q.audioText!),
              ),
            WordChoiceWidget(
              options: q.options,
              selectedOption: userAnswers[currentIndex],
              onSelect: isChecked
                  ? null
                  : (val) => setState(() => userAnswers[currentIndex] = val),
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
              enabled: !isChecked,
            ),
          ],
        );

      default:
        return Text("Loại bài tập chưa được hỗ trợ giao diện.");
    }
  }

  // --- 6. Build Main UI ---
  // @override
  // Widget build(BuildContext context) {
  //   return ValueListenableBuilder<ThemeMode>(
  //     valueListenable: themeNotifier,
  //     builder: (context, mode, child) {
  //       final theme = Theme.of(context);
  //
  //       if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
  //       if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));
  //
  //       final totalQuestions = questions.length;
  //
  //       return Scaffold(
  //         backgroundColor: theme.scaffoldBackgroundColor,
  //         appBar: AppBar(
  //           elevation: 0,
  //           backgroundColor: const Color(0xFF4B00D1),
  //           leading: IconButton(
  //             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
  //             onPressed: _goBack,
  //           ),
  //           actions: [
  //             IconButton(
  //               icon: const Icon(Icons.close, color: Colors.white),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //           ],
  //           title: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   SizedBox(
  //                     width: 40,
  //                     height: 40,
  //                     child: CircularProgressIndicator(
  //                       value: (currentIndex + 1) / totalQuestions,
  //                       strokeWidth: 4,
  //                       backgroundColor: Colors.white24,
  //                       valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
  //                     ),
  //                   ),
  //                   Text(
  //                     "${((currentIndex + 1) / totalQuestions * 100).toInt()}%",
  //                     style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(width: 12),
  //               Text(
  //                 "Question ${currentIndex + 1}/$totalQuestions",
  //                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  //               ),
  //             ],
  //           ),
  //           centerTitle: true,
  //         ),
  //         body: Column(
  //           children: [
  //             Expanded(
  //               child: PageView.builder(
  //                 controller: _pageController,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 onPageChanged: (index) {
  //                   setState(() {
  //                     currentIndex = index;
  //                     isChecked = false;
  //                     isCorrect = null;
  //                     inputController.text = userAnswers[index] ?? "";
  //                   });
  //                 },
  //                 itemCount: totalQuestions,
  //                 itemBuilder: (context, index) {
  //                   final q = questions[index];
  //                   return SingleChildScrollView(
  //                     padding: const EdgeInsets.all(24),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           q.title,
  //                           style: TextStyle(
  //                             fontSize: 24,
  //                             fontWeight: FontWeight.bold,
  //                             color: theme.textTheme.titleLarge?.color,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 30),
  //                         _buildExerciseContent(q, theme),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             isChecked
  //                 ? _buildResultBottom(theme)
  //                 : _buildCheckBottom(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));

        final totalQuestions = questions.length;
        // Tính toán tỉ lệ hoàn thành cho thanh progress ngang
        double progressValue = (currentIndex + 1) / totalQuestions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF4B00D1),
            // Nút quay lại (mũi tên)
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: _goBack,
            ),
            // Nút X để thoát
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            // Phần tiêu đề chứa thanh Progress ngang và số câu
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // Thanh progress ngang với bo góc
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6, // Độ dài thanh
                    height: 10, // Độ dày thanh
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.white24,
                      // Màu của thanh chạy (màu trắng hoặc xanh nhạt cho nổi)
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Hiển thị số câu ngay bên dưới thanh progress
                Text(
                  "${currentIndex + 1}/$totalQuestions",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Phần nội dung câu hỏi (PageView)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                      isChecked = false;
                      isCorrect = null;
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
              // Phần nút Check hoặc Kết quả đúng/sai ở dưới cùng
              isChecked
                  ? _buildResultBottom(theme)
                  : _buildCheckBottom(),
            ],
          ),
        );
      },
    );
  }







  Widget _buildCheckBottom() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.transparent,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _handleCheck,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5F2EFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Check Answer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildResultBottom(ThemeData theme) {
    bool correct = isCorrect == true;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: correct ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(correct ? Icons.check_circle : Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  correct ? "Correct Answer!" : "Wrong Answer!",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: correct ? _handleNext : () => setState(() => isChecked = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: correct ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  correct ? (currentIndex == questions.length - 1 ? "Finish" : "Continue") : "Try again",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}