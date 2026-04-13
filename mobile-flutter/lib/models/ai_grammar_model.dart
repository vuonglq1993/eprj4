class GrammarCheckRequestModel {
  final String text;
  final String cefrLevel;

  GrammarCheckRequestModel({
    required this.text,
    this.cefrLevel = "B1",
  });

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "cefrLevel": cefrLevel,
    };
  }
}

class GrammarErrorModel {
  final String type;
  final String wrong;
  final String correct;
  final String explanation;
  final String rule;

  GrammarErrorModel({
    required this.type,
    required this.wrong,
    required this.correct,
    required this.explanation,
    required this.rule,
  });

  factory GrammarErrorModel.fromJson(Map<String, dynamic> json) {
    return GrammarErrorModel(
      type: json["type"]?.toString() ?? "",
      wrong: json["wrong"]?.toString() ?? "",
      correct: json["correct"]?.toString() ?? "",
      explanation: json["explanation"]?.toString() ?? "",
      rule: json["rule"]?.toString() ?? "",
    );
  }
}

class GrammarCheckResponseModel {
  final String original;
  final String corrected;
  final bool isCorrect;
  final List<GrammarErrorModel> errors;
  final String betterExpression;
  final String tip;

  GrammarCheckResponseModel({
    required this.original,
    required this.corrected,
    required this.isCorrect,
    required this.errors,
    required this.betterExpression,
    required this.tip,
  });

  factory GrammarCheckResponseModel.fromJson(Map<String, dynamic> json) {
    final rawErrors = json["errors"];
    return GrammarCheckResponseModel(
      original: json["original"]?.toString() ?? "",
      corrected: json["corrected"]?.toString() ?? "",
      isCorrect: json["isCorrect"] == true,
      errors: rawErrors is List
          ? rawErrors
          .map((e) => GrammarErrorModel.fromJson(
        Map<String, dynamic>.from(e as Map),
      ))
          .toList()
          : [],
      betterExpression: json["betterExpression"]?.toString() ?? "",
      tip: json["tip"]?.toString() ?? "",
    );
  }
}