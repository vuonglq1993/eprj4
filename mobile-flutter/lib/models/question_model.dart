enum QuestionType { imageChoice, wordChoice, inputField }

class Question {
  final String title;
  final String? subTitle; // Ví dụ: "jongen" hoặc "Hoi"
  final QuestionType type;
  final List<String> options; // Danh sách các lựa chọn
  final String correctAnswer;
  final String? audioText; // Văn bản để đọc giả lập

  Question({
    required this.title,
    this.subTitle,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.audioText,
  });

  // factory Question.fromExercise(Map<String, dynamic> json) {
  //   // Parse questionData từ String sang JSON Map
  //   final Map<String, dynamic> qData = jsonDecode(json['questionData']);
  //
  //   // Ánh xạ Type từ DB sang QuestionType trong Flutter
  //   QuestionType qType;
  //   switch (json['type']) {
  //     case 'MULTIPLE_CHOICE': qType = QuestionType.wordChoice; break;
  //     case 'LISTENING_CHOICE': qType = QuestionType.imageChoice; break;
  //     case 'FILL_IN_BLANK': qType = QuestionType.inputField; break;
  //     default: qType = QuestionType.wordChoice;
  //   }
  //
  //   return Question(
  //     title: json['title'] ?? "Bài tập",
  //     subTitle: qData['question'] ?? "",
  //     type: qType,
  //     options: List<String>.from(qData['options'] ?? []),
  //     // Nếu là Multiple choice thì lấy correctIndex, nếu là điền từ thì lấy answer
  //     correctAnswer: qData['correctIndex']?.toString() ?? qData['answer'] ?? "",
  //   );
  // }
}