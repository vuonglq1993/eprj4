import '../models/questionfake_model.dart';

List<Question> questions = [

  Question(
    title: "Select the correct image",
    subTitle: "jongen",
    type: QuestionType.imageChoice,
    options: ["Men", "Women", "Boy", "Girl"],
    correctAnswer: "Boy",
  ),

  Question(
    title: "Select the correct word",
    subTitle: "Hoi",
    type: QuestionType.wordChoice,
    options: ["Goedemorgen", "Hoi", "Tot ziens"],
    correctAnswer: "Hoi",
  ),

  Question(
    title: "Guess its meaning...",
    subTitle: "👋",
    type: QuestionType.wordChoice,
    options: ["Good morning", "Hello", "Good bye"],
    correctAnswer: "Hello",
  ),

  Question(
    title: "Convert this text into Dutch",
    subTitle: "The boy",
    type: QuestionType.inputField,
    options: [],
    correctAnswer: "De jongen",
  ),
];