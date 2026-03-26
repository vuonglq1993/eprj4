class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final String type;
  final String? videoUrl;
  final String? audioUrl;
  final int durationMinutes;
  final String progressStatus;
  final int score;

  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.type,
    this.videoUrl,
    this.audioUrl,
    required this.durationMinutes,
    required this.progressStatus,
    required this.score,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      content: json['content'] ?? '',
      type: json['type'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      durationMinutes: json['durationMinutes'] ?? 0,
      progressStatus: json['progressStatus'],
      score: json['score'] ?? 0,
    );
  }
}