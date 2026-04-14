class LessonSummaryModel {
  final String id;
  final String title;
  final String skill;
  final String cefrLevel;
  final int estimatedMinutes;

  LessonSummaryModel({
    required this.id,
    required this.title,
    required this.skill,
    required this.cefrLevel,
    required this.estimatedMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "skill": skill,
      "cefrLevel": cefrLevel,
      "estimatedMinutes": estimatedMinutes,
    };
  }
}

class RecommendRequestModel {
  final double avgScore;
  final List<String> weakSkills;
  final String learningPace;
  final List<String> completedLessonIds;
  final List<LessonSummaryModel> availableLessons;

  RecommendRequestModel({
    required this.avgScore,
    required this.weakSkills,
    required this.learningPace,
    required this.completedLessonIds,
    required this.availableLessons,
  });

  Map<String, dynamic> toJson() {
    return {
      "avgScore": avgScore,
      "weakSkills": weakSkills,
      "learningPace": learningPace,
      "completedLessonIds": completedLessonIds,
      "availableLessons": availableLessons.map((e) => e.toJson()).toList(),
    };
  }
}