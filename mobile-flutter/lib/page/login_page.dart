// import 'package:flutter/material.dart';
// import 'signup_page.dart';
// import '../services/fake_auth.dart';
// import '../logincomplete/login_complete_flow.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0, // Thêm elevation = 0 để phẳng và đẹp hơn
//         centerTitle: true,
//
//         // 1. Đổi màu icon (nút back, các icon khác trên AppBar) sang trắng
//         iconTheme: const IconThemeData(color: Colors.white),
//
//         // 2. Đổi màu và style cho chữ tiêu đề "Login" sang trắng
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//
//         title: const Text("Login"),
//       ),
//       body: Padding(
//         // padding: const EdgeInsets.symmetric(horizontal: 24),
//         padding: const EdgeInsets.fromLTRB(24, 0, 24, 20), // Trái 24, Trên 0, Phải 24, Dưới 60
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 30),
//
//               const Center(
//                 child: Icon(Icons.menu_book_rounded,
//                     size: 70, color: Color(0xFF6C8CFF)),
//               ),
//
//               const SizedBox(height: 20),
//
//               const Text(
//                 "For free, join now and\nstart learning",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//
//               const SizedBox(height: 30),
//
//               const Text("Email Address"),
//               const SizedBox(height: 6),
//               _input(emailController, false),
//
//               const SizedBox(height: 16),
//
//               const Text("Password"),
//               const SizedBox(height: 6),
//               _input(passwordController, true),
//
//               const SizedBox(height: 25),
//
//               GestureDetector(
//                 onTap: () {
//                   if (_formKey.currentState!.validate()) {
//                     bool success = FakeAuth.login(
//                       emailController.text,
//                       passwordController.text,
//                     );
//
//                     if (success) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const LoginCompleteFlow(),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Invalid email or password"),
//                         ),
//                       );
//                     }
//                   }
//                 },
//                 child: _button("Login"),
//               ),
//
//               const SizedBox(height: 25),
//               _divider(),
//               const SizedBox(height: 20),
//
//               Row(
//                 children: [
//                   Expanded(child: _social(Icons.facebook, Colors.blue)),
//                   const SizedBox(width: 15),
//                   Expanded(child: _social(Icons.g_mobiledata, Colors.red)),
//                 ],
//               ),
//
//               const SizedBox(height: 25),
//
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const SignupPage(),
//                       ),
//                     );
//                   },
//                   child: const Text.rich(
//                     TextSpan(
//                       text: "Register an account? ",
//                       style: TextStyle(color: Colors.grey),
//                       children: [
//                         TextSpan(
//                           text: "Signup",
//                           style: TextStyle(
//                             color: Color(0xFF5F2EFF),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget _input(TextEditingController controller, bool isPassword) {
//   //   return TextFormField(
//   //     controller: controller,
//   //     obscureText: isPassword,
//   //     decoration: InputDecoration(
//   //       hintText: "Placeholder text",
//   //       filled: true,
//   //       fillColor: const Color(0xFFE9EAF0),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(14),
//   //         borderSide: BorderSide.none,
//   //       ),
//   //     ),
//   //     validator: (value) =>
//   //     value == null || value.isEmpty ? "Required" : null,
//   //   );
//   // }
//
//
//   Widget _input(TextEditingController controller, bool isPassword) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: isPassword ? "••••••••" : "example@mail.com",
//         filled: true,
//         fillColor: const Color(0xFFE9EAF0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "Vui lòng không bỏ trống";
//         }
//         if (!isPassword) {
//           final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//           if (!emailRegex.hasMatch(value)) {
//             return "Email không hợp lệ";
//           }
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _button(String text) {
//     return Container(
//       height: 55,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
//         ),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Center(
//         child: Text(text,
//             style: const TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
//
//   Widget _divider() {
//     return const Row(
//       children: [
//         Expanded(child: Divider()),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: Text("Or", style: TextStyle(color: Colors.grey)),
//         ),
//         Expanded(child: Divider()),
//       ],
//     );
//   }
//
//   Widget _social(IconData icon, Color color) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9EAF0),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Icon(icon, color: color),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'signup_page.dart';
import '../services/api_service.dart';
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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        title: const Text("Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),

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
                onTap: isLoading ? null : _login,
                child: _button(isLoading ? "Loading..." : "Login"),
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
                      text: "Register an account? ",
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

  // ================= LOGIN =================

  void _login() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final token = await ApiService.login(
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() => isLoading = false);

    if (token != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập thành công")),
      );

      // 👉 TODO: lưu token (bước sau mình làm cho bạn)

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginCompleteFlow(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sai email hoặc mật khẩu")),
      );

    }
  }

  // ================= UI =================

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
          return "Không được để trống";
        }

        if (!isPassword) {
          final emailRegex =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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
}