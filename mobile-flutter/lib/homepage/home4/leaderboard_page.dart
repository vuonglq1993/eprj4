// import 'package:flutter/material.dart';
// import '../../services/gamification_service.dart';
// import '../../models/leaderboard_model.dart';
//
// class LeaderboardPage extends StatefulWidget {
//   const LeaderboardPage({super.key});
//
//   @override
//   State<LeaderboardPage> createState() => _LeaderboardPageState();
// }
//
// class _LeaderboardPageState extends State<LeaderboardPage> {
//
//   Leaderboard? leaderboard;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final data = await GamificationService.getLeaderboard();
//     if (!mounted) return;
//
//     setState(() {
//       leaderboard = data;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (leaderboard == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Leaderboard"),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Weekly"),
//               Tab(text: "All Time"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildList(leaderboard!.weekly),
//             _buildList(leaderboard!.allTime),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildList(List<LeaderboardEntry> list) {
//     return ListView.builder(
//       itemCount: list.length,
//       itemBuilder: (_, i) {
//         final item = list[i];
//
//         return ListTile(
//           leading: Text("#${item.rank}"),
//           title: Text(item.userName),
//           trailing: Text("${item.xp} XP"),
//         );
//       },
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../../services/gamification_service.dart';
import '../../models/leaderboard_model.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Leaderboard? leaderboard;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await GamificationService.getLeaderboard();
    if (!mounted) return;

    setState(() {
      leaderboard = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF5F2EFF);
    const headerBg = Color(0xFF6A11FF);
    const pageBg = Color(0xFFF5F6FA);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: pageBg,
        appBar: AppBar(
          backgroundColor: headerBg,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Leaderboard",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: Colors.black54,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Weekly"),
                  Tab(text: "All Time"),
                ],
              ),
            ),
          ),
        ),
        body: leaderboard == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildLeaderboardTab(
              title: "This Week's Ranking",
              subtitle: "Keep learning to climb higher",
              list: leaderboard!.weekly,
            ),
            _buildLeaderboardTab(
              title: "All Time Ranking",
              subtitle: "Your total learning XP",
              list: leaderboard!.allTime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab({
    required String title,
    required String subtitle,
    required List<LeaderboardEntry> list,
  }) {
    const primary = Color(0xFF5F2EFF);
    const gold = Color(0xFFFFC107);
    const silver = Color(0xFFB0BEC5);
    const bronze = Color(0xFFFFA26B);

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A11FF), Color(0xFF8E54FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const Center(
            child: Text(
              "No leaderboard data yet",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final item = list[i];

              Color badgeColor = primary;
              IconData badgeIcon = Icons.emoji_events_outlined;

              if (item.rank == 1) {
                badgeColor = gold;
                badgeIcon = Icons.workspace_premium;
              } else if (item.rank == 2) {
                badgeColor = silver;
                badgeIcon = Icons.workspace_premium;
              } else if (item.rank == 3) {
                badgeColor = bronze;
                badgeIcon = Icons.workspace_premium;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badgeIcon,
                        color: badgeColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rank #${item.rank}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${item.xp} XP",
                        style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}