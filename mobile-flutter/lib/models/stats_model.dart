class StatsResponse {
  final int totalStudyMinutes;
  final int lessonsCompleted;
  final double averageScore;
  final List<DailyStudy> daily;

  StatsResponse({
    required this.totalStudyMinutes,
    required this.lessonsCompleted,
    required this.averageScore,
    required this.daily,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      totalStudyMinutes: json['totalStudyMinutes'] ?? 0,
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      daily: (json['daily'] as List).map((i) => DailyStudy.fromJson(i)).toList(),
    );
  }
}

class DailyStudy {
  final String day; // "Mon", "Tue"...
  final int minutes;

  DailyStudy({required this.day, required this.minutes});

  factory DailyStudy.fromJson(Map<String, dynamic> json) {
    return DailyStudy(
      day: json['day'] ?? '',
      minutes: json['minutes'] ?? 0,
    );
  }
}