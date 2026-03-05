import 'package:flutter/material.dart';
import '../services/fake_auth.dart';
import '../quiz/quiz_page.dart';
import 'progress_page.dart';
import 'task_page.dart';
import 'profile_page.dart';
import 'activity_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),

      // ================= BODY =================
      body: _getSelectedPage(),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF5F2EFF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Task",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return TaskPage(
          onBack: () {
            setState(() {
              currentIndex = 0;
            });
          },
        );
      case 2:
        return ProgressPage(
          onBack: () {
            setState(() {
              currentIndex = 0;
            });
          },
        );
      case 3:
        return ProfilePage(
          // NÚT BACK: Nhảy về tab đầu tiên (Home)
          onBack: () {
            setState(() {
              currentIndex = 0;
            });
          },
          onOpenActivity: () =>
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ActivityPage())),
          onOpenSettings: () =>
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsPage())),
        );
      default:
        return _buildHomeContent();
    }
  }

  // ================= HOME CONTENT =================
  Widget _buildHomeContent() {
    return Column(
      children: [

        // ================= HEADER =================
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
          decoration: const BoxDecoration(
            color: Color(0xFF5F2EFF),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  const Icon(Icons.notifications_none,
                      color: Colors.white, size: 26),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Hello, ${FakeAuth.userName ?? 'User'}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "What would you like to learn today?",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),

        // ================= BODY SCROLL =================
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 25),

                sectionTitle("Continue Course"),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: continueCard(
                        "German\nLanguage",
                        "15/20",
                        0.75,
                        const Color(0xFF5F2EFF),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: continueCard(
                        "Spanish\nLanguage",
                        "10/30",
                        0.33,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                sectionTitle("Featured Courses"),

                const SizedBox(height: 15),

                featuredCard(
                  "Grammar Quiz",
                  "Business English",
                  "2 hours",
                ),

                const SizedBox(height: 15),

                featuredCard(
                  "Online Phrases",
                  "Business English",
                  "2 hours",
                ),

                const SizedBox(height: 20),

                // ================= WEEKLY GOAL =================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFE3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          color: Colors.orange),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Set Weekly Goal!\nUsers who set goals stay motivated.",
                          style: TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= SECTION TITLE =================
  Widget sectionTitle(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Text(
          "See All",
          style: TextStyle(
              color: Color(0xFF5F2EFF),
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  // ================= CONTINUE CARD =================
  Widget continueCard(
      String title, String progress, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 65,
            height: 65,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
                Text(
                  progress,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          const SizedBox(height: 5),
          const Text(
            "20 Classes - Easy",
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ================= FEATURED CARD =================
  Widget featuredCard(
      String title, String subtitle, String time) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const QuizPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF5F2EFF)
                    .withOpacity(0.1),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_circle_fill,
                color: Color(0xFF5F2EFF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}