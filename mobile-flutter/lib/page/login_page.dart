import 'package:flutter/material.dart';
import 'signup_page.dart';
import '../services/fake_auth.dart';
import '../logincomplete/login_complete_flow.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        centerTitle: true,
        title: const Text("Login"),
      ),
      body: Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20), // Trái 24, Trên 0, Phải 24, Dưới 60
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),

              const Center(
                child: Icon(Icons.menu_book_rounded,
                    size: 70, color: Color(0xFF6C8CFF)),
              ),

              const SizedBox(height: 20),

              const Text(
                "For free, join now and\nstart learning",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 30),

              const Text("Email Address"),
              const SizedBox(height: 6),
              _input(emailController, false),

              const SizedBox(height: 16),

              const Text("Password"),
              const SizedBox(height: 6),
              _input(passwordController, true),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    bool success = FakeAuth.login(
                      emailController.text,
                      passwordController.text,
                    );

                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginCompleteFlow(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid email or password"),
                        ),
                      );
                    }
                  }
                },
                child: _button("Login"),
              ),

              const SizedBox(height: 25),
              _divider(),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _social(Icons.facebook, Colors.blue)),
                  const SizedBox(width: 15),
                  Expanded(child: _social(Icons.g_mobiledata, Colors.red)),
                ],
              ),

              const SizedBox(height: 25),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Not you member? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Signup",
                          style: TextStyle(
                            color: Color(0xFF5F2EFF),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _input(TextEditingController controller, bool isPassword) {
  //   return TextFormField(
  //     controller: controller,
  //     obscureText: isPassword,
  //     decoration: InputDecoration(
  //       hintText: "Placeholder text",
  //       filled: true,
  //       fillColor: const Color(0xFFE9EAF0),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(14),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //     validator: (value) =>
  //     value == null || value.isEmpty ? "Required" : null,
  //   );
  // }


  Widget _input(TextEditingController controller, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: isPassword ? "••••••••" : "example@mail.com",
        filled: true,
        fillColor: const Color(0xFFE9EAF0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng không bỏ trống";
        }
        if (!isPassword) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return "Email không hợp lệ";
          }
        }
        return null;
      },
    );
  }

  Widget _button(String text) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _divider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Or", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _social(IconData icon, Color color) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EAF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}