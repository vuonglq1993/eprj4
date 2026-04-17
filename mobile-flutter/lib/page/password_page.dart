// import 'package:flutter/material.dart';
// import '../services/fake_auth.dart';
// import 'login_page.dart';
//
// class PasswordPage extends StatefulWidget {
//   final String email;
//   final String name;
//
//   const PasswordPage({
//     super.key,
//     required this.email,
//     required this.name,
//   });
//
//   @override
//   State<PasswordPage> createState() => _PasswordPageState();
// }
//
// class _PasswordPageState extends State<PasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   final confirmController = TextEditingController();
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
//         title: const Text("Signup"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//
//               const SizedBox(height: 30),
//
//               const Text(
//                 "Choose a Password",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//
//               const SizedBox(height: 30),
//
//               const Text("Password",
//                   style: TextStyle(fontWeight: FontWeight.w500)),
//
//               const SizedBox(height: 6),
//
//               _input(passwordController),
//
//               const SizedBox(height: 16),
//
//               const Text("Confirm Password",
//                   style: TextStyle(fontWeight: FontWeight.w500)),
//
//               const SizedBox(height: 6),
//
//               _input(confirmController, isConfirm: true),
//
//               const SizedBox(height: 40),
//
//               GestureDetector(
//                 onTap: () {
//                   if (_formKey.currentState!.validate()) {
//
//                     FakeAuth.register(
//                       widget.email,
//                       passwordController.text,
//                       name: widget.name,
//                     );
//
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const LoginPage()),
//                           (route) => false,
//                     );
//                   }
//                 },
//                 child: _button("Signup"),
//               ),
//
//               const SizedBox(height: 25),
//
//               _divider(),
//
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
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _input(TextEditingController controller, {bool isConfirm = false}) {
//     return TextFormField(
//       controller: controller,
//       obscureText: true,
//       decoration: InputDecoration(
//         hintText: "••••••••",
//         filled: true,
//         fillColor: const Color(0xFFE9EAF0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) return "Vui lòng nhập mật khẩu";
//         if (value.length < 8) return "Mật khẩu phải có ít nhất 8 ký tự";
//
//         if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
//           return "Mật khẩu cần cả chữ và số";
//         }
//
//         if (isConfirm && value != passwordController.text) {
//           return "Mật khẩu xác nhận không khớp";
//         }
//
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
//             colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: 16),
//         ),
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




//
// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'login_page.dart';
//
// class PasswordPage extends StatefulWidget {
//
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String phone; // ✅ thêm
//
//   const PasswordPage({
//     super.key,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.phone,
//   });
//
//   @override
//   State<PasswordPage> createState() => _PasswordPageState();
// }
//
// class _PasswordPageState extends State<PasswordPage> {
//
//   final _formKey = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   final confirmController = TextEditingController();
//
//   bool _isPasswordVisible = false;      // Cho ô mật khẩu 1
//   bool _isConfirmVisible = false;       // Cho ô xác nhận mật khẩu
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//         title: const Text("Signup"),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//
//               const SizedBox(height: 30),
//
//               const Text(
//                 "Choose a Password",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//
//               const SizedBox(height: 30),
//
//               _label("Password"),
//               _input(passwordController),
//               const SizedBox(height: 16),
//               _label("Confirm Password"),
//               _input(confirmController, isConfirm: true),
//
//               const SizedBox(height: 40),
//
//               GestureDetector(
//                 onTap: isLoading ? null : _register,
//                 child: _button(isLoading ? "Loading..." : "Signup"),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _register() async {
//
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     bool success = await ApiService.register(
//       email: widget.email,
//       password: passwordController.text,
//       firstName: widget.firstName,
//       lastName: widget.lastName,
//       phone: widget.phone, // ✅ gửi lên backend
//     );
//
//     setState(() => isLoading = false);
//
//     if (success) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Đăng ký thành công")),
//       );
//
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//             (route) => false,
//       );
//
//     } else {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Đăng ký thất bại")),
//       );
//
//     }
//   }
//
//   // Widget _input(TextEditingController controller, {bool isConfirm = false}) {
//   //
//   //   return TextFormField(
//   //     controller: controller,
//   //     obscureText: true,
//   //
//   //     decoration: InputDecoration(
//   //       hintText: "••••••••",
//   //       filled: true,
//   //       fillColor: const Color(0xFFE9EAF0),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(14),
//   //         borderSide: BorderSide.none,
//   //       ),
//   //     ),
//   //
//   //     validator: (value) {
//   //
//   //       if (value == null || value.isEmpty)
//   //         return "Nhập mật khẩu";
//   //
//   //       if (value.length < 8)
//   //         return "Ít nhất 8 ký tự";
//   //
//   //       if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value))
//   //         return "Phải có chữ và số";
//   //
//   //       if (isConfirm && value != passwordController.text)
//   //         return "Không khớp";
//   //
//   //       return null;
//   //     },
//   //   );
//   // }
//
//   Widget _label(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//           color: Colors.black87,
//         ),
//       ),
//     );
//   }
//
//   Widget _input(TextEditingController controller, {bool isConfirm = false}) {
//     // Xác định xem ô này đang dùng biến ẩn/hiện nào
//     bool isVisible = isConfirm ? _isConfirmVisible : _isPasswordVisible;
//
//     return TextFormField(
//       controller: controller,
//       obscureText: !isVisible, // Ẩn nếu isVisible là false
//
//       decoration: InputDecoration(
//         hintText: "••••••••",
//         filled: true,
//         fillColor: const Color(0xFFE9EAF0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//         // Nút con mắt
//         suffixIcon: IconButton(
//           icon: Icon(
//             isVisible ? Icons.visibility : Icons.visibility_off,
//             color: Colors.grey,
//           ),
//           onPressed: () {
//             setState(() {
//               // Cập nhật đúng biến cho từng ô
//               if (isConfirm) {
//                 _isConfirmVisible = !_isConfirmVisible;
//               } else {
//                 _isPasswordVisible = !_isPasswordVisible;
//               }
//             });
//           },
//         ),
//       ),
//
//       validator: (value) {
//         if (value == null || value.isEmpty) return "Nhập mật khẩu";
//         if (value.length < 8) return "Ít nhất 8 ký tự";
//         if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) return "Phải có chữ và số";
//         if (isConfirm && value != passwordController.text) return "Không khớp";
//         return null;
//       },
//     );
//   }
//
//
//
//
//   Widget _button(String text) {
//     return Container(
//       height: 55,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//             colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Center(
//         child: Text(text,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }




//nối api lại
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../logincomplete/login_complete_flow.dart';

class PasswordPage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  const PasswordPage({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
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
              _label("Password"),
              _input(passwordController),
              const SizedBox(height: 16),
              _label("Confirm Password"),
              _input(confirmController, isConfirm: true),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: isLoading ? null : _register,
                child: _button(isLoading ? "Loading..." : "Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await ApiService.register(
      email: widget.email.trim(),
      password: passwordController.text.trim(),
      firstName: widget.firstName.trim(),
      lastName: widget.lastName.trim(),
      phone: widget.phone.trim(),
    );

    if (!mounted) return;

    if (!success) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thất bại")),
      );
      return;
    }

    final token = await ApiService.login(
      email: widget.email.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginCompleteFlow(),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng ký thành công nhưng tự đăng nhập thất bại"),
        ),
      );
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, {bool isConfirm = false}) {
    final isVisible = isConfirm ? _isConfirmVisible : _isPasswordVisible;

    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: "••••••••",
        filled: true,
        fillColor: const Color(0xFFE9EAF0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (isConfirm) {
                _isConfirmVisible = !_isConfirmVisible;
              } else {
                _isPasswordVisible = !_isPasswordVisible;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Nhập mật khẩu";
        if (value.length < 8) return "Ít nhất 8 ký tự";
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
          return "Phải có chữ và số";
        }
        if (isConfirm && value != passwordController.text) return "Không khớp";
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
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}