class VocabRequestModel {
  final String word;
  final String cefrLevel;

  VocabRequestModel({
    required this.word,
    this.cefrLevel = "B1",
  });

  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "cefrLevel": cefrLevel,
    };
  }
}

class VocabGameRequestModel {
  final String word;
  final String gameType;
  final String cefrLevel;

  VocabGameRequestModel({
    required this.word,
    this.gameType = "MULTIPLE_CHOICE",
    this.cefrLevel = "B1",
  });

  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "gameType": gameType,
      "cefrLevel": cefrLevel,
    };
  }
}