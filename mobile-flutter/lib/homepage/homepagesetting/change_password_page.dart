// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
//
// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});
//
//   @override
//   State<ChangePasswordPage> createState() =>
//       _ChangePasswordPageState();
// }
//
// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final currentController = TextEditingController();
//   final newController = TextEditingController();
//   final confirmController = TextEditingController();
//
//   bool isLoading = false;
//
//   void handleUpdate() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     final success = await ApiService.changePassword(
//       currentPassword: currentController.text.trim(),
//       newPassword: newController.text.trim(),
//     );
//
//     if (!mounted) return;
//
//     setState(() => isLoading = false);
//
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Đổi mật khẩu thành công!")));
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Sai mật khẩu cũ")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         title: const Text("Đổi mật khẩu",
//             style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             _inputField("Mật khẩu hiện tại", currentController),
//             const SizedBox(height: 15),
//             _inputField("Mật khẩu mới", newController),
//             const SizedBox(height: 15),
//             _inputField("Xác nhận mật khẩu", confirmController, isConfirm: true),
//             const SizedBox(height: 30),
//
//             GestureDetector(
//               onTap: isLoading ? null : handleUpdate,
//               child: Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Center(
//                   child: Text(
//                     isLoading ? "Đang xử lý..." : "Cập nhật mật khẩu",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _inputField(String label, TextEditingController controller,
//       {bool isConfirm = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller,
//           obscureText: true,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty)
//               return "Không được để trống";
//
//             if (value.length < 8)
//               return "Tối thiểu 8 ký tự";
//
//             if (isConfirm && value != newController.text)
//               return "Không khớp";
//
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../homepagesetting/theme_notifier.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;

  void handleUpdate() async {
    FocusScope.of(context).unfocus(); // 👈 ẩn keyboard

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await ApiService.changePassword(
      currentPassword: currentController.text.trim(),
      newPassword: newController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đổi mật khẩu thành công!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu cũ không chính xác")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF5F2EFF),
            title: const Text(
              "Đổi mật khẩu",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _inputField("Mật khẩu hiện tại", currentController, theme),
                  const SizedBox(height: 16),
                  _inputField("Mật khẩu mới", newController, theme),
                  const SizedBox(height: 16),
                  _inputField("Xác nhận mật khẩu", confirmController, theme,
                      isConfirm: true),
                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: isLoading ? null : handleUpdate,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          isLoading ? "Đang xử lý..." : "Cập nhật mật khẩu",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputField(
      String label,
      TextEditingController controller,
      ThemeData theme, {
        bool isConfirm = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: true,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "Không được để trống";
            if (value.length < 8) return "Tối thiểu 8 ký tự";
            if (isConfirm && value != newController.text) return "Không khớp";
            return null;
          },
        ),
      ],
    );
  }
}