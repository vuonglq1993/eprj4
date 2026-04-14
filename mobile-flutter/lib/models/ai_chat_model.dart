class AiChatRequestModel {
  final String? lessonId;
  final String? lessonTitle;
  final String? lessonContent;
  final String cefrLevel;
  final String message;

  AiChatRequestModel({
    this.lessonId,
    this.lessonTitle,
    this.lessonContent,
    this.cefrLevel = "B1",
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "lessonId": lessonId,
      "lessonTitle": lessonTitle,
      "lessonContent": lessonContent,
      "cefrLevel": cefrLevel,
      "message": message,
    };
  }
}

class AiChatResponseModel {
  final String reply;
  final String? model;
  final int inputTokens;
  final int outputTokens;
  final int remainingToday;

  AiChatResponseModel({
    required this.reply,
    this.model,
    required this.inputTokens,
    required this.outputTokens,
    required this.remainingToday,
  });

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    return AiChatResponseModel(
      reply: json["reply"] ?? "",
      model: json["model"],
      inputTokens: json["inputTokens"] ?? 0,
      outputTokens: json["outputTokens"] ?? 0,
      remainingToday: json["remainingToday"] ?? 0,
    );
  }
}