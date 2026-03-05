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
}