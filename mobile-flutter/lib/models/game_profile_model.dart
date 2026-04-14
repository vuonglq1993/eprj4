class GameProfile {
  final int level;
  final int totalXp;
  final int weeklyXp;
  final String levelTitle;
  final int progressPercent;
  final int xpToNextLevel;
  final int xpCurrentLevel;

  GameProfile({
    required this.level,
    required this.totalXp,
    required this.weeklyXp,
    required this.levelTitle,
    required this.progressPercent,
    required this.xpToNextLevel,
    required this.xpCurrentLevel,
  });

  factory GameProfile.fromJson(Map<String, dynamic> json) {
    return GameProfile(
      level: (json['level'] ?? 1) as int,
      totalXp: (json['totalXp'] ?? 0) as int,
      weeklyXp: (json['weeklyXp'] ?? 0) as int,
      levelTitle: (json['levelTitle'] ?? '') as String,
      progressPercent: (json['progressPercent'] ?? 0) as int,
      xpToNextLevel: (json['xpToNextLevel'] ?? 0) as int,
      xpCurrentLevel: (json['xpCurrentLevel'] ?? 0) as int,
    );
  }

  @override
  String toString() {
    return 'GameProfile(level: $level, totalXp: $totalXp, weeklyXp: $weeklyXp, levelTitle: $levelTitle, progressPercent: $progressPercent)';
  }
}