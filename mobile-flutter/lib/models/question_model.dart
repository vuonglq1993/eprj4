// enum QuestionType { imageChoice, wordChoice, inputField }
//
// class Question {
//   final String title;
//   final String? subTitle; // Ví dụ: "jongen" hoặc "Hoi"
//   final QuestionType type;
//   final List<String> options; // Danh sách các lựa chọn
//   final String correctAnswer;
//   final String? audioText; // Văn bản để đọc giả lập
//
//   Question({
//     required this.title,
//     this.subTitle,
//     required this.type,
//     required this.options,
//     required this.correctAnswer,
//     this.audioText,
//   });
//
//   // factory Question.fromExercise(Map<String, dynamic> json) {
//   //   // Parse questionData từ String sang JSON Map
//   //   final Map<String, dynamic> qData = jsonDecode(json['questionData']);
//   //
//   //   // Ánh xạ Type từ DB sang QuestionType trong Flutter
//   //   QuestionType qType;
//   //   switch (json['type']) {
//   //     case 'MULTIPLE_CHOICE': qType = QuestionType.wordChoice; break;
//   //     case 'LISTENING_CHOICE': qType = QuestionType.imageChoice; break;
//   //     case 'FILL_IN_BLANK': qType = QuestionType.inputField; break;
//   //     default: qType = QuestionType.wordChoice;
//   //   }
//   //
//   //   return Question(
//   //     title: json['title'] ?? "Bài tập",
//   //     subTitle: qData['question'] ?? "",
//   //     type: qType,
//   //     options: List<String>.from(qData['options'] ?? []),
//   //     // Nếu là Multiple choice thì lấy correctIndex, nếu là điền từ thì lấy answer
//   //     correctAnswer: qData['correctIndex']?.toString() ?? qData['answer'] ?? "",
//   //   );
//   // }
// }



//bản mới nhất
import 'dart:convert';

enum QuestionType { imageChoice, wordChoice, inputField }

class Question {
  final String id;
  final String title;
  final String? subTitle;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final String? audioText;

  Question({
    required this.id,
    required this.title,
    this.subTitle,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.audioText,
  });

  // factory Question.fromExercise(Map<String, dynamic> json) {
  //   // Parse questionData từ chuỗi JSON backend gửi về
  //   final Map<String, dynamic> qData = jsonDecode(json['questionData'] ?? '{}');
  //
  //   QuestionType qType;
  //   String typeFromDb = json['type'] ?? '';
  //
  //   if (typeFromDb == 'LISTENING_CHOICE') {
  //     qType = QuestionType.imageChoice;
  //   } else if (typeFromDb == 'FILL_IN_BLANK' || typeFromDb == 'TRANSLATION') {
  //     qType = QuestionType.inputField;
  //   } else {
  //     qType = QuestionType.wordChoice;
  //   }
  //
  //   return Question(
  //     id: json['id'] ?? '',
  //     title: json['title'] ?? "Bài tập",
  //     subTitle: qData['question'] ?? "",
  //     type: qType,
  //     options: qData['options'] != null ? List<String>.from(qData['options']) : [],
  //     correctAnswer: qData['answer']?.toString() ??
  //         (qData['correctIndex'] != null ? qData['options'][qData['correctIndex']].toString() : ""),
  //     audioText: qData['targetText'],
  //   );
  // }

  factory Question.fromExercise(Map<String, dynamic> json) {
    dynamic rawData = json['questionData'];

    Map<String, dynamic> qData = {};

    // 🔥 Fix: handle cả String và Object
    if (rawData is String) {
      qData = jsonDecode(rawData);
    } else if (rawData is Map<String, dynamic>) {
      qData = rawData;
    }

    QuestionType qType;
    String typeFromDb = json['type'] ?? '';

    if (typeFromDb == 'LISTENING_CHOICE') {
      qType = QuestionType.imageChoice;
    } else if (typeFromDb == 'FILL_IN_BLANK' || typeFromDb == 'TRANSLATION') {
      qType = QuestionType.inputField;
    } else {
      qType = QuestionType.wordChoice;
    }

    List<String> options =
    qData['options'] != null ? List<String>.from(qData['options']) : [];

    // 🔥 Fix correct answer
    String correctAnswer = "";

    if (qData['answer'] != null) {
      correctAnswer = qData['answer'].toString();
    } else if (qData['correctIndex'] != null && options.isNotEmpty) {
      int idx = qData['correctIndex'];
      if (idx >= 0 && idx < options.length) {
        correctAnswer = options[idx];
      }
    }

    return Question(
      id: json['id'] ?? '',
      title: json['title'] ?? "Bài tập",
      subTitle: qData['question'] ?? "",
      type: qType,
      options: options,
      correctAnswer: correctAnswer,
      audioText: qData['targetText'],
    );
  }
}