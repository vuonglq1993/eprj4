class LeaderboardEntry {
  final int rank;
  final String userName;
  final int xp;

  LeaderboardEntry({
    required this.rank,
    required this.userName,
    required this.xp,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] ?? 0,
      userName: json['userName'] ?? "",
      xp: json['xp'] ?? 0,
    );
  }
}

class Leaderboard {
  final List<LeaderboardEntry> weekly;
  final List<LeaderboardEntry> allTime;

  Leaderboard({
    required this.weekly,
    required this.allTime,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      weekly: (json['weekly'] as List? ?? [])
          .map((e) => LeaderboardEntry.fromJson(e))
          .toList(),
      allTime: (json['allTime'] as List? ?? [])
          .map((e) => LeaderboardEntry.fromJson(e))
          .toList(),
    );
  }
}