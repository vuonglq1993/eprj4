import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../data/question_data.dart';
import 'widgets/image_choice_widget.dart';
import 'widgets/word_choice_widget.dart';
import 'widgets/input_field_widget.dart';
import 'lesson_completed_page.dart';
import '../homepage/homepage.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  bool isChecked = false;
  bool? isCorrect;

  final TextEditingController inputController = TextEditingController();

  // Lưu đáp án từng câu
  Map<int, String> userAnswers = {};

  // ================= BACK =================
  void _goBackQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isChecked = false;
        isCorrect = null;

        if (questions[currentIndex].type ==
            QuestionType.inputField) {
          inputController.text =
              userAnswers[currentIndex] ?? "";
        }
      });
    }
  }

  // ================= CLOSE =================
  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }

  // ================= CHECK =================
  void _handleCheck() {
    final q = questions[currentIndex];

    String answer;

    if (q.type == QuestionType.inputField) {
      answer = inputController.text.trim();
    } else {
      answer = userAnswers[currentIndex] ?? "";
    }

    if (answer.isEmpty) return;

    setState(() {
      isChecked = true;
      isCorrect =
          answer.toLowerCase() == q.correctAnswer.toLowerCase();
    });
  }

  // ================= NEXT =================
  void _handleNext() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isChecked = false;
        isCorrect = null;

        if (questions[currentIndex].type ==
            QuestionType.inputField) {
          inputController.text =
              userAnswers[currentIndex] ?? "";
        }
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const LessonCompletedPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5F2EFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white),
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
                value: (currentIndex + 1) / questions.length,
                minHeight: 8,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${currentIndex + 1}/${questions.length}",
              style: const TextStyle(
                  fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: Column(
        children: [

          // ===== QUESTION CONTENT =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    q.title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  if (q.subTitle != null)
                    Row(
                      children: [
                        const Icon(Icons.volume_up,
                            color: Color(0xFF5F2EFF)),
                        const SizedBox(width: 8),
                        Text(
                          q.subTitle!,
                          style: const TextStyle(
                            fontSize: 18,
                            decoration:
                            TextDecoration.underline,
                            decorationStyle:
                            TextDecorationStyle.dotted,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),

                  q.type == QuestionType.imageChoice
                      ? ImageChoiceWidget(
                    options: q.options,
                    selectedOption:
                    userAnswers[currentIndex],
                    onSelect: (val) {
                      setState(() {
                        userAnswers[currentIndex] =
                            val;
                      });
                    },
                  )
                      : q.type == QuestionType.wordChoice
                      ? WordChoiceWidget(
                    options: q.options,
                    selectedOption:
                    userAnswers[currentIndex],
                    onSelect: (val) {
                      setState(() {
                        userAnswers[currentIndex] =
                            val;
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

          // ===== RESULT PANEL (giống hình bạn gửi) =====
          if (isChecked)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCorrect == true
                    ? const Color(0xFF5B6EFF)
                    : const Color(0xFFD81B60),
              ),
              child: Column(
                children: [
                  Text(
                    isCorrect == true
                        ? "Correct Answer!"
                        : "Wrong Answer!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isCorrect == true
                            ? "Next"
                            : "Try again",
                      ),
                    ),
                  ),
                ],
              ),
            )

          // ===== SUBMIT BUTTON =====
          else
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF5F2EFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}