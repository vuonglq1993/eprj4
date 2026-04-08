class LearningPathStepModel {
  final String stepId;
  final int stepOrder;
  final String courseId;
  final String courseTitle;
  final String courseLevel;
  final String? thumbnailUrl;
  final int totalLessons;
  final String? note;
  final bool isRequired;
  final int courseProgressPercent;
  final bool isUnlocked;

  LearningPathStepModel({
    required this.stepId,
    required this.stepOrder,
    required this.courseId,
    required this.courseTitle,
    required this.courseLevel,
    required this.thumbnailUrl,
    required this.totalLessons,
    required this.note,
    required this.isRequired,
    required this.courseProgressPercent,
    required this.isUnlocked,
  });

  factory LearningPathStepModel.fromJson(Map<String, dynamic> json) {
    return LearningPathStepModel(
      stepId: json['stepId']?.toString() ?? '',
      stepOrder: json['stepOrder'] ?? 0,
      courseId: json['courseId']?.toString() ?? '',
      courseTitle: json['courseTitle']?.toString() ?? '',
      courseLevel: json['courseLevel']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      totalLessons: json['totalLessons'] ?? 0,
      note: json['note']?.toString(),
      isRequired: json['isRequired'] ?? false,
      courseProgressPercent: json['courseProgressPercent'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

class LearningPathModel {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String languageCode;
  final String languageName;
  final String targetLevel;
  final String? goal;
  final int estimatedHours;
  final bool isPublished;
  final bool isOfficial;
  final int totalSteps;
  final String? createdByName;
  final String? createdAt;
  final int? progressPercent;
  final int? currentStep;
  final String? enrollStatus;
  final List<LearningPathStepModel> steps;

  LearningPathModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.languageCode,
    required this.languageName,
    required this.targetLevel,
    required this.goal,
    required this.estimatedHours,
    required this.isPublished,
    required this.isOfficial,
    required this.totalSteps,
    required this.createdByName,
    required this.createdAt,
    required this.progressPercent,
    required this.currentStep,
    required this.enrollStatus,
    required this.steps,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    return LearningPathModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      languageCode: json['languageCode']?.toString() ?? '',
      languageName: json['languageName']?.toString() ?? '',
      targetLevel: json['targetLevel']?.toString() ?? '',
      goal: json['goal']?.toString(),
      estimatedHours: json['estimatedHours'] ?? 0,
      isPublished: json['isPublished'] ?? false,
      isOfficial: json['isOfficial'] ?? false,
      totalSteps: json['totalSteps'] ?? 0,
      createdByName: json['createdByName']?.toString(),
      createdAt: json['createdAt']?.toString(),
      progressPercent: json['progressPercent'],
      currentStep: json['currentStep'],
      enrollStatus: json['enrollStatus']?.toString(),
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => LearningPathStepModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}