import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'dot_indicator.dart';
import '../page/login_page.dart'; // Đảm bảo đường dẫn này chính xác
import '../page/signup_page.dart'; // Đảm bảo đường dẫn này chính xác

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Confidence in your words",
      "subtitle": "With conversation-based learning, you'll be talking from lesson one",
      "image": "assets/images/onboarding_1.png", // Đường dẫn ảnh 1
    },
    {
      "title": "Take your time to learn",
      "subtitle": "Develop a habit of learning and make it a part of your daily routine",
      "image": "assets/images/onboarding_2.png", // Đường dẫn ảnh 2
    },
    {
      "title": "Lessons you need to learn",
      "subtitle": "Using a variety of learning styles to learn and retain",
      "image": "assets/images/onboarding_3.png", // Đường dẫn ảnh 3
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Bọc Column trong SingleChildScrollView để sửa lỗi tràn
          child: ConstrainedBox( // Đảm bảo nội dung chiếm toàn bộ chiều cao tối thiểu
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Phân bổ khoảng cách giữa các phần tử
              children: [
                // Container chứa PageView
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65, // Đặt chiều cao cho PageView (ví dụ: 65% chiều cao màn hình)
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) => setState(() => currentIndex = index),
                    itemBuilder: (context, index) => OnboardingPage(
                      title: pages[index]["title"]!,
                      subtitle: pages[index]["subtitle"]!,
                      imagePath: pages[index]["image"]!,
                    ),
                  ),
                ),
                // Phần tử chấm tròn chỉ số trang
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DotIndicator(currentIndex: currentIndex, total: pages.length),
                ),
                // Phần còn lại của giao diện (nút, text)
                Column(
                  children: [
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
                            if (currentIndex < pages.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupPage()),
                              );
                            }
                          },
                          child: Text(currentIndex == pages.length - 1 ? "Choose a language" : "Choose a language"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Already a fillolearn user? ", // Cập nhật text cho đúng
                          style: TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(text: "Log in", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold)), // Cập nhật màu text Log in
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}