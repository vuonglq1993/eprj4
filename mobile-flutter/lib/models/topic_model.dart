class TopicModel {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final bool isActive;
  final int orderIndex;
  final int totalCourses;

  TopicModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.isActive,
    required this.orderIndex,
    required this.totalCourses,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      iconUrl: json['iconUrl']?.toString(),
      isActive: json['isActive'] ?? false,
      orderIndex: json['orderIndex'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
    );
  }
}