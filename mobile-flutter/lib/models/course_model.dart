class Course {
  final String id;
  final String title;
  final String description;
  final String languageCode;
  final String languageName;
  final String level;
  final String thumbnailUrl;
  final bool isPublished;
  final int totalLessons;
  final int progressPercent;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.languageCode,
    required this.languageName,
    required this.level,
    required this.thumbnailUrl,
    required this.isPublished,
    required this.totalLessons,
    required this.progressPercent,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      languageCode: json['languageCode'],
      languageName: json['languageName'],
      level: json['level'],
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      isPublished: json['isPublished'],
      totalLessons: json['totalLessons'],
      progressPercent: json['progressPercent'] ?? 0,
    );
  }
}