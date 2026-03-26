// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//
//   bool isLoading = true;
//   bool isSaving = false;
//   String? userEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }
//
//   void _loadInitialData() async {
//     final data = await ApiService.getProfile();
//
//     if (data != null && mounted) {
//       setState(() {
//         firstNameController.text = data['firstName'] ?? '';
//         lastNameController.text = data['lastName'] ?? '';
//         userEmail = data['email'];
//         isLoading = false;
//       });
//     }
//   }
//
//   void handleSave() async {
//     setState(() => isSaving = true);
//
//     final success = await ApiService.updateProfile(
//       firstName: firstNameController.text.trim(),
//       lastName: lastNameController.text.trim(),
//     );
//
//     if (!mounted) return;
//
//     setState(() => isSaving = false);
//
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Cập nhật thành công!")));
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Lỗi khi cập nhật")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//           body: Center(child: CircularProgressIndicator()));
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         title: const Text("Edit Profile",
//             style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             _readonly("Email", userEmail ?? ""),
//             const SizedBox(height: 15),
//             _input("First Name", firstNameController),
//             const SizedBox(height: 15),
//             _input("Last Name", lastNameController),
//             const SizedBox(height: 30),
//
//             GestureDetector(
//               onTap: isSaving ? null : handleSave,
//               child: Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Center(
//                   child: Text(
//                     isSaving ? "Saving..." : "Save",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _input(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _readonly(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//               color: const Color(0xFFE9EAF0),
//               borderRadius: BorderRadius.circular(14)),
//           child: Text(value, style: const TextStyle(color: Colors.black54)),
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../homepagesetting/theme_notifier.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  String? email;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // ✅ Load data
  Future<void> _loadInitialData() async {
    final data = await ApiService.getProfile();

    if (!mounted) return;

    if (data != null) {
      setState(() {
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['lastName'] ?? '';
        email = data['email'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // ✅ Save
  void handleSave() async {
    FocusScope.of(context).unfocus(); // ẩn keyboard

    setState(() => isSaving = true);

    final success = await ApiService.updateProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thành công!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi cập nhật")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);

        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF5F2EFF),
            title: const Text(
              "Chỉnh sửa hồ sơ",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _readonly("Email", email ?? '', theme),
                const SizedBox(height: 16),
                _input("Họ", firstNameController, theme),
                const SizedBox(height: 16),
                _input("Tên", lastNameController, theme),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: isSaving ? null : handleSave,
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
                        isSaving ? "Đang lưu..." : "Lưu",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input(
      String label, TextEditingController controller, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _readonly(
      String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.disabledColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}