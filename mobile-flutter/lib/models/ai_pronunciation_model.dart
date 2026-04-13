class PronunciationRequestModel {
  final String targetText;
  final String recognizedText;
  final String cefrLevel;

  PronunciationRequestModel({
    required this.targetText,
    required this.recognizedText,
    this.cefrLevel = "B1",
  });

  Map<String, dynamic> toJson() {
    return {
      "targetText": targetText,
      "recognizedText": recognizedText,
      "cefrLevel": cefrLevel,
    };
  }
}

class PronunciationResponseModel {
  final int score;
  final String cefrLevel;
  final String feedback;
  final String phonemeErrors;
  final String improvement;

  PronunciationResponseModel({
    required this.score,
    required this.cefrLevel,
    required this.feedback,
    required this.phonemeErrors,
    required this.improvement,
  });

  factory PronunciationResponseModel.fromJson(Map<String, dynamic> json) {
    return PronunciationResponseModel(
      score: json["score"] ?? 0,
      cefrLevel: json["cefrLevel"]?.toString() ?? "",
      feedback: json["feedback"]?.toString() ?? "",
      phonemeErrors: json["phonemeErrors"]?.toString() ?? "",
      improvement: json["improvement"]?.toString() ?? "",
    );
  }
}