// // class StatsResponse {
// //   final int totalStudyMinutes;
// //   final int lessonsCompleted;
// //   final double averageScore;
// //   final List<DailyStudy> daily;
// //
// //   StatsResponse({
// //     required this.totalStudyMinutes,
// //     required this.lessonsCompleted,
// //     required this.averageScore,
// //     required this.daily,
// //   });
// //
// //   factory StatsResponse.fromJson(Map<String, dynamic> json) {
// //     return StatsResponse(
// //       totalStudyMinutes: json['totalStudyMinutes'] ?? 0,
// //       lessonsCompleted: json['lessonsCompleted'] ?? 0,
// //       averageScore: (json['averageScore'] ?? 0).toDouble(),
// //       daily: (json['daily'] as List? ?? []).map((i) => DailyStudy.fromJson(i)).toList(),
// //     );
// //   }
// // }
//
//
//
// class StatsResponse {
//   final int totalMinutes;
//   final int totalLessons;
//   final double averageScore;
//
//   StatsResponse({
//     required this.totalMinutes,
//     required this.totalLessons,
//     required this.averageScore,
//   });
//
//   factory StatsResponse.fromJson(Map<String, dynamic> json) {
//     return StatsResponse(
//       totalMinutes: json['totalMinutes'] ?? 0,
//       totalLessons: json['totalLessons'] ?? 0,
//       averageScore: (json['averageScore'] ?? 0).toDouble(),
//     );
//   }
// }
//
// class DailyStudy {
//   final String day; // "Mon", "Tue"...
//   final int minutes;
//
//   DailyStudy({required this.day, required this.minutes});
//
//   factory DailyStudy.fromJson(Map<String, dynamic> json) {
//     return DailyStudy(
//       day: json['day'] ?? '',
//       minutes: json['minutes'] ?? 0,
//     );
//   }
// }




class StatsResponse {
  final String period;
  final int totalMinutes;
  final int totalLessons;
  final double averageScore;
  final List<PeriodStat> data;

  StatsResponse({
    required this.period,
    required this.totalMinutes,
    required this.totalLessons,
    required this.averageScore,
    required this.data,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      period: (json['period'] ?? 'WEEK').toString(),
      totalMinutes: json['totalMinutes'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PeriodStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PeriodStat {
  final String date;
  final String label;
  final int studyMinutes;
  final int lessonsCompleted;

  PeriodStat({
    required this.date,
    required this.label,
    required this.studyMinutes,
    required this.lessonsCompleted,
  });

  factory PeriodStat.fromJson(Map<String, dynamic> json) {
    return PeriodStat(
      date: (json['date'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      studyMinutes: json['studyMinutes'] ?? 0,
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
    );
  }
}