import 'package:flutter/material.dart';
import 'password_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailController = TextEditingController();

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
                "Create an Account",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _label("First Name"),
              _input(firstName, hint: "John"),
              const SizedBox(height: 16),
              _label("Last Name"),
              _input(lastName, hint: "Doe"),
              const SizedBox(height: 16),
              _label("Email Address"),
              _input(emailController, hint: "example@mail.com", isEmail: true),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PasswordPage(
                          email: emailController.text,
                          name: firstName.text, // TRUYỀN TÊN SANG ĐÂY
                        ),
                      ),
                    );
                  }
                },
                child: _button("Continue"),
              ),
              const SizedBox(height: 25),
              _loginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _input(TextEditingController controller, {required String hint, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFE9EAF0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Vui lòng không để trống";
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) return "Email không hợp lệ";
        } else if (value.length < 2) {
          return "Tên quá ngắn";
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
        boxShadow: [BoxShadow(color: const Color(0xFF5F2EFF).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
    );
  }

  Widget _loginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
        child: const Text.rich(TextSpan(
          text: "Already a member? ",
          style: TextStyle(color: Colors.grey),
          children: [TextSpan(text: "Login", style: TextStyle(color: Color(0xFF5F2EFF), fontWeight: FontWeight.bold))],
        )),
      ),
    );
  }
}