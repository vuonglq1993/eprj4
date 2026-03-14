import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'dot_indicator.dart';
import '../page/login_page.dart'; // Đường dẫn chính xác từ homescreen ra page
import '../page/signup_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {"title": "Confidence in your words", "subtitle": "With conversation-based learning, you'll be talking from lesson one"},
    {"title": "Take your time to learn", "subtitle": "Develop a habit of learning and make it a part of your daily routine"},
    {"title": "The lessons you need to learn", "subtitle": "Using a variety of learning styles to learn and retain"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemBuilder: (context, index) => OnboardingPage(
                  title: pages[index]["title"]!,
                  subtitle: pages[index]["subtitle"]!,
                ),
              ),
            ),
            DotIndicator(currentIndex: currentIndex, total: pages.length),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6380FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            _) => const SignupPage()), // Chuyển đến trang Đăng ký
                      );
                    },
                  child: const Text("Register an account"),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // XÓA const ở đây để hết lỗi "Not a constant expression"
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: const Text.rich(
                TextSpan(
                  text: "You already have an account? ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(text: "Log in", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}