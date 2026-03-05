import 'package:flutter/material.dart';
import 'congratulations_page.dart';

class LoginCompleteFlow extends StatefulWidget {
  const LoginCompleteFlow({super.key});

  @override
  State<LoginCompleteFlow> createState() => _LoginCompleteFlowState();
}

class _LoginCompleteFlowState extends State<LoginCompleteFlow> {
  int step = 0;
  int? selectedIndex;

  final List<Map<String, dynamic>> steps = [
    {
      "title": "What Is Your Mother Language?",
      "options": [
        "English",
        "French",
        "German",
        "Hindi",
        "Korean",
        "Bengali",
        "Italian",
      ]
    },
    {
      "title": "What Is The Main Reason to Learn English?",
      "options": [
        "Travel",
        "School",
        "Work",
        "Family/Friends",
        "Skill Improvement",
        "Others",
      ]
    },
    {
      "title": "How much you know about English?",
      "options": [
        "Not Much",
        "Medium",
        "Expert",
      ]
    },
    {
      "title": "How old are you?",
      "options": [
        "Under 18",
        "18 - 24",
        "25 - 34",
        "35 - 44",
        "45 - 54",
        "55 - 64",
        "65 or older",
      ]
    },
    {
      "title": "How much time do you want to learn german?",
      "options": [
        "5min/Day",
        "15min/Day",
        "30min/Day",
        "60min/Day",
      ]
    },
    {
      "title": "How did you hear about Language App?",
      "options": [
        "Friends/Family",
        "Play Store",
        "Youtube",
        "TV",
        "Podcast",
        "Website Ad",
      ]
    },
    {
      "title": "Course Overview",
      "isOverview": true
    }
  ];

  void next() {
    if (step == steps.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CongratulationsPage(),
        ),
      );
      return;
    }

    if (selectedIndex == null) return;

    setState(() {
      step++;
      selectedIndex = null;
    });
  }

  void back() {
    if (step > 0) {
      setState(() {
        step--;
        selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var current = steps[step];
    bool isOverview = current["isOverview"] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: back,
        ),
        centerTitle: true,
        title: Text(
          "Completed ${step + 1}/${steps.length}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 25),

            Text(
              current["title"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            if (!isOverview)
              Expanded(
                child: ListView.builder(
                  itemCount: current["options"].length,
                  itemBuilder: (_, index) {
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF17A398)
                              : const Color(0xFFE9EAF0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          current["options"][index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (isOverview)
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Learn listening, speaking, reading and writing in spanish",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        overviewCard("9000+", "Words"),
                        const SizedBox(width: 20),
                        overviewCard("2100+", "Sentences"),
                      ],
                    )
                  ],
                ),
              ),

            GestureDetector(
              onTap: (selectedIndex != null || isOverview) ? next : null,
              child: Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget overviewCard(String title, String subtitle) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EAF0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.description, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}