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

  // --- Quản lý trạng thái câu hỏi hiện tại ---
  bool isChecked = false;
  bool? isCorrect;
  final TextEditingController inputController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // --- Dữ liệu ---
  List<dynamic> rawExercises = [];
  Map<int, String> userAnswers = {}; // Lưu câu trả lời của user theo index câu hỏi
  List<Map<String, dynamic>> submitAnswers = []; // Dữ liệu để submit lên backend

  @override
  void initState() {
    super.initState();
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
          rawExercises = data;
          isLoading = false;
          if (rawExercises.isEmpty) {
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

  void _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  // Giải mã JSON questionData từ DB
  Map<String, dynamic> _getQuestionData(dynamic exercise) {
    var data = exercise['questionData'];
    if (data is String) return jsonDecode(data);
    return data;
  }

  // --- 3. Logic Check đúng sai & Lưu câu trả lời ---
  void _handleCheck() {
    final exercise = rawExercises[currentIndex];
    final qData = _getQuestionData(exercise);
    final type = exercise['type'];

    String userAnswer = "";
    String correctAnswer = "";

    if (type == 'MULTIPLE_CHOICE' || type == 'LISTENING_CHOICE') {
      userAnswer = userAnswers[currentIndex] ?? "";
      correctAnswer = qData['options'][qData['correctIndex']].toString();
    } else if (type == 'FILL_IN_BLANK' || type == 'TRANSLATION') {
      userAnswer = inputController.text.trim();
      correctAnswer = qData['answer'].toString();
    }

    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn hoặc điền đáp án!")),
      );
      return;
    }

    bool correct = userAnswer.toLowerCase() == correctAnswer.toLowerCase();

    setState(() {
      isChecked = true;
      isCorrect = correct;

      // Lưu lại answer cho UI
      userAnswers[currentIndex] = userAnswer;
    });
  }

  // --- 4. Logic Next / Hoàn thành ---
  void _handleNext() async {
    final exercise = rawExercises[currentIndex];
    final qData = _getQuestionData(exercise);
    final type = exercise['type'];

    String answer = "";

    // 👉 convert answer đúng format backend
    if (type == 'MULTIPLE_CHOICE' || type == 'LISTENING_CHOICE') {
      int index = qData['options'].indexOf(userAnswers[currentIndex]);
      answer = index.toString(); // ⚠️ backend cần index
    } else {
      answer = userAnswers[currentIndex] ?? inputController.text.trim();
    }

    // 👉 CALL API MỖI CÂU
    bool success = await ExerciseService.submitSingle(
      widget.courseId,
      widget.lessonId,
      exercise['id'],
      answer,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi nộp câu hỏi")),
      );
      return;
    }

    // 👉 sang câu tiếp theo
    // if (currentIndex < rawExercises.length - 1) {
    //   _pageController.nextPage(
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // } else {
    //   // 👉 HOÀN THÀNH
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => const LessonCompletedPage(),
    //     ),
    //   );
    // }


    if (currentIndex < rawExercises.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // 👉 KHI BẤM FINISH: Gọi API ghi nhận phiên học
      await StudyLogService.logStudySession(
        lessonId: widget.lessonId,
        durationSeconds: 300, // Bạn có thể tính thời gian thật nếu muốn
        score: 100,
        activityType: "EXERCISE_SUBMIT",
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
        );
      }
    }
  }

  // --- 5. Biểu diễn Widget Bài tập dựa theo Type ---
  Widget _buildExerciseContent(dynamic exercise, ThemeData theme) {
    final qData = _getQuestionData(exercise);
    final type = exercise['type'];

    // Lấy tiêu đề câu hỏi từ JSON
    String questionText = qData['question'] ?? "Chọn đáp án đúng";

    switch (type) {
      case 'MULTIPLE_CHOICE':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),

            WordChoiceWidget(
              options: List<String>.from(qData['options']),
              selectedOption: userAnswers[currentIndex],
              onSelect: isChecked
                  ? null
                  : (val) => setState(() => userAnswers[currentIndex] = val),
            ),
          ],
        );

      case 'LISTENING_CHOICE':
        String? audioUrl = qData['audioUrl'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),

            if (audioUrl != null)
              IconButton(
                icon: const Icon(Icons.volume_up, size: 40),
                onPressed: () => _playAudio(audioUrl),
              ),

            WordChoiceWidget(
              options: List<String>.from(qData['options']),
              selectedOption: userAnswers[currentIndex],
              onSelect: isChecked
                  ? null
                  : (val) => setState(() => userAnswers[currentIndex] = val),
            ),
          ],
        );

      case 'FILL_IN_BLANK':
      case 'TRANSLATION':
      // Điền từ thì hiện câu hỏi dạng "T____ student" hoặc "Dịch câu..."
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(questionText, style: TextStyle(fontSize: 18, color: theme.textTheme.bodyLarge?.color)),
            const SizedBox(height: 20),
            InputFieldWidget(
              controller: inputController,
              enabled: !isChecked, // Khóa nếu đã check
            ),
          ],
        );

      default:
        return Text("Loại bài tập $type chưa được hỗ trợ giao diện.");
    }
  }

  // --- 6. Build Main UI ---
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));

        final totalQuestions = rawExercises.length;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF4B00D1),
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20), onPressed: _goBack),
            actions: [
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ],
            // Progress Bar đẹp trai trên AppBar
            title: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / totalQuestions,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text("${currentIndex + 1}/$totalQuestions", style: const TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // --- Phần nội dung câu hỏi (PageView) ---
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Khóa không cho vuốt tay, bắt bấm nút
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                      isChecked = false;
                      isCorrect = null;
                      // Load lại câu trả lời cũ nếu có (cho Fill blank)
                      inputController.text = userAnswers[index] ?? "";
                    });
                  },
                  itemCount: totalQuestions,
                  itemBuilder: (context, index) {
                    final exercise = rawExercises[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề lớn (Ví dụ: "Translate", "Listening MCQ")
                          Text(
                            exercise['title'] ?? "Exercise",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color),
                          ),
                          const SizedBox(height: 30),
                          // Nội dung bài tập thật
                          _buildExerciseContent(exercise, theme),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // --- Phần Bottom (Nút bấm & Kết quả) ---
              isChecked
                  ? _buildResultBottom(theme) // Hiện kết quả đúng/sai
                  : _buildCheckBottom(), // Hiện nút Check
            ],
          ),
        );
      },
    );
  }

  // Widget hiển thị nút Check
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

  // Widget hiển thị kết quả Correct/Wrong (Bê nguyên màu fake sang)
  Widget _buildResultBottom(ThemeData theme) {
    bool correct = isCorrect == true;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: correct ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60), // Xanh dương cho đúng, Hồng cho sai
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
                onPressed: correct ? _handleNext : () => setState(() => isChecked = false), // Sai thì cho chọn lại
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: correct ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  correct ? (currentIndex == rawExercises.length - 1 ? "Finish" : "Continue") : "Try again",
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