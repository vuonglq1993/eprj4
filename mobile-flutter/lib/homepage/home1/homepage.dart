import 'package:flutter/material.dart';
import '../../services/fake_auth.dart';
import '../../quiz/quiz_page.dart';
import '../home3/progress_page.dart';
import '../home2/task_page.dart';
import '../home4/profile_page.dart';
import '../home4/activity_page.dart';
import '../homepagesetting/settings_page.dart';
import '../homepagesetting/theme_notifier.dart';
import '../../data/task_question_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: _getSelectedPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xFF5F2EFF),
            unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey,
            backgroundColor: theme.cardColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Task"),
              BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: "Stats"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
            ],
          ),
        );
      },
    );
  }

  Widget _getSelectedPage() {
    switch (currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return TaskPage(onBack: () => setState(() => currentIndex = 0));
      case 2:
        return ProgressPage(onBack: () => setState(() => currentIndex = 0));
      case 3:
        return ProfilePage(
          onBack: () => setState(() => currentIndex = 0),
          onOpenActivity: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityPage())),
          onOpenSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
        );
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final theme = Theme.of(context);
    final isDark = themeNotifier.value == ThemeMode.dark;

    return Column(
      children: [
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
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: FakeAuth.avatar != null
                        ? FileImage(FakeAuth.avatar!)
                        : const NetworkImage("https://i.pravatar.cc/150?img=3") as ImageProvider,
                  ),
                  const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hello, ${FakeAuth.userName ?? 'User'}",
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "What would you like to learn today?",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                sectionTitle("Continue Course", theme),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: continueCard(
                        "German\nLanguage",
                        "15/20",
                        0.75,
                        const Color(0xFF5F2EFF),
                        theme,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizPage(
                                taskQuestions: germanQuestions,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: continueCard(
                        "Spanish\nLanguage",
                        "10/30",
                        0.33,
                        Colors.orange,
                        theme,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizPage(
                                taskQuestions: germanQuestions,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                sectionTitle("Featured Courses", theme),
                const SizedBox(height: 15),
                featuredCard("Grammar Quiz", "Business English", "2 hours", theme),
                const SizedBox(height: 15),
                featuredCard("Online Phrases", "Business English", "2 hours", theme),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFEFE3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Set Weekly Goal!\nUsers who set goals stay motivated.",
                          style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
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

  Widget sectionTitle(String text, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.textTheme.titleLarge?.color)),
        const Text("See All", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget continueCard(
      String title,
      String progress,
      double value,
      Color color,
      ThemeData theme,
      VoidCallback? onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
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
                    backgroundColor: theme.disabledColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                  Text(progress, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.textTheme.bodyMedium?.color)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.titleMedium?.color)),
            const SizedBox(height: 5),
            const Text("20 Classes - Easy", style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget featuredCard(String title, String subtitle, String time, ThemeData theme) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(themeNotifier.value == ThemeMode.dark ? 0.3 : 0.05),
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
                color: const Color(0xFF5F2EFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_circle_fill, color: Color(0xFF5F2EFF)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.textTheme.titleMedium?.color)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Text(time, style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}