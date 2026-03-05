import 'package:flutter/material.dart';
import '../services/fake_auth.dart';
import '../logincomplete/login_complete_flow.dart';

class PasswordPage extends StatefulWidget {
  final String email;
  final String name; // Thêm biến name nhận từ SignupPage
  const PasswordPage({super.key, required this.email, required this.name});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        elevation: 0,
        centerTitle: true,
        title: const Text("Signup"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Choose a Password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              _input(passwordController),
              const SizedBox(height: 16),
              const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              _input(confirmController, isConfirm: true),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Truyền cả email và name vào register
                    FakeAuth.register(
                      widget.email,
                      passwordController.text,
                      name: widget.name,
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginCompleteFlow()),
                          (route) => false,
                    );
                  }
                },
                child: _button("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "••••••••",
        filled: true,
        fillColor: const Color(0xFFE9EAF0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Vui lòng nhập mật khẩu";
        if (value.length < 8) return "Mật khẩu phải có ít nhất 8 ký tự";
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
          return "Mật khẩu cần cả chữ và số";
        }
        if (isConfirm && value != passwordController.text) {
          return "Mật khẩu xác nhận không khớp";
        }
        return null;
      },
    );
  }

  Widget _button(String text) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
      ),
    );
  }
}