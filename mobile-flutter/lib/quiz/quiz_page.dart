import 'package:flutter/material.dart';
import '../models/questionfake_model.dart';
import '../data/question_data.dart';
import '../data/task_question_data.dart';

import 'widgets/image_choice_widget.dart';
import 'widgets/word_choice_widget.dart';
import 'widgets/input_field_widget.dart';

import 'lesson_completed_page.dart';
import '../homepage/home1/homepage.dart';
// 1. Import theme_notifier để lắng nghe trạng thái đổi màu
import '../homepage/homepagesetting/theme_notifier.dart';

class QuizPage extends StatefulWidget {
  final List<Question>? taskQuestions;

  const QuizPage({super.key, this.taskQuestions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  bool isChecked = false;
  bool? isCorrect;

  final TextEditingController inputController = TextEditingController();
  Map<int, String> userAnswers = {};
  late List<Question> quizData;

  @override
  void initState() {
    super.initState();
    quizData = widget.taskQuestions ?? questions;
  }

  void _goBackQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isChecked = false;
        isCorrect = null;
        if (quizData[currentIndex].type == QuestionType.inputField) {
          inputController.text = userAnswers[currentIndex] ?? "";
        }
      });
    }
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }

  void _handleCheck() {
    final q = quizData[currentIndex];
    String answer;

    if (q.type == QuestionType.inputField) {
      answer = inputController.text.trim();
    } else {
      answer = userAnswers[currentIndex] ?? "";
    }

    if (answer.isEmpty) return;

    setState(() {
      isChecked = true;
      isCorrect = answer.toLowerCase() == q.correctAnswer.toLowerCase();
    });
  }

  void _handleNext() {
    if (currentIndex < quizData.length - 1) {
      setState(() {
        currentIndex++;
        isChecked = false;
        isCorrect = null;
        if (quizData[currentIndex].type == QuestionType.inputField) {
          inputController.text = userAnswers[currentIndex] ?? "";
        }
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. Lắng nghe themeNotifier
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;
        final q = quizData[currentIndex];

        return Scaffold(
          // 3. Sử dụng màu nền từ Theme
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF4B00D1), // Giữ màu tím thương hiệu
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: _goBackQuestion,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _goHome,
              ),
            ],
            title: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / quizData.length,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${currentIndex + 1}/${quizData.length}",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            centerTitle: true,
          ),

          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color, // Màu chữ theo theme
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (q.subTitle != null)
                        Row(
                          children: [
                            const Icon(Icons.volume_up, color: Color(0xFF5F2EFF)),
                            const SizedBox(width: 8),
                            Text(
                              q.subTitle!,
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.textTheme.bodyLarge?.color,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dotted,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),

                      // Widgets con cũng cần được cập nhật màu bên trong code của chúng
                      q.type == QuestionType.imageChoice
                          ? ImageChoiceWidget(
                        options: q.options,
                        selectedOption: userAnswers[currentIndex],
                        onSelect: (val) {
                          setState(() {
                            userAnswers[currentIndex] = val;
                          });
                        },
                      )
                          : q.type == QuestionType.wordChoice
                          ? WordChoiceWidget(
                        options: q.options,
                        selectedOption: userAnswers[currentIndex],
                        onSelect: (val) {
                          setState(() {
                            userAnswers[currentIndex] = val;
                          });
                        },
                      )
                          : InputFieldWidget(
                        controller: inputController,
                      ),
                    ],
                  ),
                ),
              ),

              // ================= PHẦN KẾT QUẢ / NÚT BẤM =================
              if (isChecked)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // Màu xanh dương cho đúng, hồng/đỏ cho sai
                    color: isCorrect == true ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isCorrect == true ? "Correct Answer!" : "Wrong Answer!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isCorrect == true
                                ? _handleNext
                                : () {
                              setState(() {
                                isChecked = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: isCorrect == true ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(
                              isCorrect == true ? "Continue" : "Try again",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.transparent, // Không dùng màu trắng cố định
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
                        child: const Text(
                          "Check Answer",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/question_model.dart';
// import '../services/token_service.dart';
// import 'widgets/image_choice_widget.dart';
// import 'widgets/word_choice_widget.dart';
// import 'widgets/input_field_widget.dart';
// import 'lesson_completed_page.dart';
// import '../homepage/home1/homepage.dart';
// import '../homepage/homepagesetting/theme_notifier.dart';
//
// class QuizPage extends StatefulWidget {
//   final String courseId;
//   final String lessonId;
//
//   const QuizPage({
//     super.key,
//     required this.courseId,
//     required this.lessonId
//   });
//
//   @override
//   State<QuizPage> createState() => _QuizPageState();
// }
//
// class _QuizPageState extends State<QuizPage> {
//   int currentIndex = 0;
//   bool isChecked = false;
//   bool? isCorrect;
//   bool isLoading = true;
//
//   final TextEditingController inputController = TextEditingController();
//   Map<int, String> userAnswers = {};
//   List<Map<String, dynamic>> rawExercises = []; // Lưu data gốc từ DB
//   List<Question> quizData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchExercisesFromDB();
//   }
//
//   // Lấy dữ liệu bài tập từ Backend
//   Future<void> fetchExercisesFromDB() async {
//     final String apiUrl =
//         "http://10.0.2.2:8080/api/v1/courses/${widget.courseId}/lessons/${widget.lessonId}/exercises";
//
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
//         final List data = jsonDecode(utf8.decode(response.bodyBytes));
//
//         setState(() {
//           rawExercises = List<Map<String, dynamic>>.from(data);
//           quizData = rawExercises.map((e) {
//             // Giải mã questionData (vốn là 1 String JSON trong DB)
//             final Map<String, dynamic> qJson = jsonDecode(e['questionData']);
//
//             return Question(
//               title: e['title'] ?? "Exercise",
//               subTitle: qJson['question'] ?? "",
//               type: _mapExerciseType(e['type']),
//               options: List<String>.from(qJson['options'] ?? []),
//               // Lấy correctIndex hoặc answer tùy loại bài tập
//               correctAnswer: qJson['correctIndex']?.toString() ?? qJson['answer'] ?? "",
//             );
//           }).toList();
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching exercises: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   // Gửi kết quả nộp bài lên Server để tính Progress
//   Future<void> _submitProgress(String exerciseId, String answer) async {
//     final String submitUrl =
//         "http://10.0.2.2:8080/api/v1/courses/${widget.courseId}/lessons/${widget.lessonId}/exercises/submit";
//
//     try {
//       final token = await TokenService.getToken();
//       await http.post(
//         Uri.parse(submitUrl),
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "exerciseId": exerciseId,
//           "answer": answer,
//         }),
//       );
//     } catch (e) {
//       print("Error submitting progress: $e");
//     }
//   }
//
//   QuestionType _mapExerciseType(String type) {
//     switch (type) {
//       case 'MULTIPLE_CHOICE': return QuestionType.wordChoice;
//       case 'FILL_IN_BLANK': return QuestionType.inputField;
//       case 'LISTENING_CHOICE': return QuestionType.imageChoice;
//       default: return QuestionType.wordChoice;
//     }
//   }
//
//   void _handleCheck() async {
//     final q = quizData[currentIndex];
//     final rawEx = rawExercises[currentIndex];
//     String answer;
//
//     if (q.type == QuestionType.inputField) {
//       answer = inputController.text.trim();
//     } else {
//       // Đối với Multiple Choice, thường là index của option
//       answer = userAnswers[currentIndex] ?? "";
//     }
//
//     if (answer.isEmpty) return;
//
//     bool correct = answer.toLowerCase() == q.correctAnswer.toLowerCase();
//
//     setState(() {
//       isChecked = true;
//       isCorrect = correct;
//     });
//
//     // Nếu đúng thì gửi lên DB để lưu tiến độ
//     if (correct) {
//       await _submitProgress(rawEx['id'], answer);
//     }
//   }
//
//   void _handleNext() {
//     if (currentIndex < quizData.length - 1) {
//       setState(() {
//         currentIndex++;
//         isChecked = false;
//         isCorrect = null;
//         inputController.clear();
//       });
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LessonCompletedPage()),
//       );
//     }
//   }
//
//   void _goHome() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const HomePage()),
//           (route) => false,
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
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//
//         if (quizData.isEmpty) {
//           return Scaffold(
//             appBar: AppBar(backgroundColor: const Color(0xFF4B00D1)),
//             body: const Center(child: Text("No exercises found for this lesson.")),
//           );
//         }
//
//         final q = quizData[currentIndex];
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: const Color(0xFF4B00D1),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//               onPressed: () => Navigator.pop(context),
//             ),
//             actions: [
//               IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _goHome),
//             ],
//             title: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: LinearProgressIndicator(
//                     value: (currentIndex + 1) / quizData.length,
//                     minHeight: 8,
//                     backgroundColor: Colors.white24,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text("${currentIndex + 1}/${quizData.length}",
//                     style: const TextStyle(fontSize: 12, color: Colors.white)),
//               ],
//             ),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(q.title,
//                           style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: theme.textTheme.titleLarge?.color)),
//                       const SizedBox(height: 15),
//                       if (q.subTitle != null && q.subTitle!.isNotEmpty)
//                         Row(
//                           children: [
//                             const Icon(Icons.volume_up, color: Color(0xFF5F2EFF)),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(q.subTitle!,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: theme.textTheme.bodyLarge?.color,
//                                     decoration: TextDecoration.underline,
//                                     decorationStyle: TextDecorationStyle.dotted,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(height: 30),
//                       _buildQuestionWidget(q),
//                     ],
//                   ),
//                 ),
//               ),
//               _buildBottomButton(theme),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildQuestionWidget(Question q) {
//     if (q.type == QuestionType.imageChoice) {
//       return ImageChoiceWidget(
//         options: q.options,
//         selectedOption: userAnswers[currentIndex],
//         onSelect: (val) => setState(() => userAnswers[currentIndex] = val),
//       );
//     } else if (q.type == QuestionType.wordChoice) {
//       return WordChoiceWidget(
//         options: q.options,
//         selectedOption: userAnswers[currentIndex],
//         onSelect: (val) {
//           // Lưu index dưới dạng String để so sánh với correctIndex từ DB
//           int idx = q.options.indexOf(val);
//           setState(() => userAnswers[currentIndex] = idx.toString());
//         },
//       );
//     } else {
//       return InputFieldWidget(controller: inputController);
//     }
//   }
//
//   Widget _buildBottomButton(ThemeData theme) {
//     if (isChecked) {
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         color: isCorrect == true ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(isCorrect == true ? "Correct Answer!" : "Wrong Answer!",
//                   style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: isCorrect == true ? _handleNext : () => setState(() => isChecked = false),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: isCorrect == true ? const Color(0xFF5B6EFF) : const Color(0xFFD81B60),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   ),
//                   child: Text(isCorrect == true ? "Continue" : "Try again",
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: ElevatedButton(
//             onPressed: _handleCheck,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF5F2EFF),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             ),
//             child: const Text("Check Answer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           ),
//         ),
//       ),
//     );
//   }
// }