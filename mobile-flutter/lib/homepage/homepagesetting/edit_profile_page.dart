// import 'package:flutter/material.dart';
// import '../../services/fake_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//
//   final nameController =
//   TextEditingController(text: FakeAuth.userName);
//
//   final phoneController =
//   TextEditingController(text: FakeAuth.phone);
//
//   final addressController =
//   TextEditingController(text: FakeAuth.address);
//
//   File? avatarImage;
//
//   final ImagePicker picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//
//     avatarImage = FakeAuth.avatar;
//   }
//
//   Future<void> pickAvatar() async {
//
//     final picked = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//
//     if (picked != null) {
//
//       final image = File(picked.path);
//
//       setState(() {
//         avatarImage = image;
//       });
//
//       FakeAuth.avatar = image;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: ListView(
//           children: [
//
//             /// Avatar
//             Center(
//               child: GestureDetector(
//                 onTap: pickAvatar,
//                 child: Stack(
//                   children: [
//
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: theme.cardColor,
//                       backgroundImage:
//                       avatarImage != null
//                           ? FileImage(avatarImage!)
//                           : null,
//                       child: avatarImage == null
//                           ? Icon(
//                         Icons.person,
//                         size: 50,
//                         color: theme.colorScheme.primary,
//                       )
//                           : null,
//                     ),
//
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Color(0xFF5F2EFF),
//                           shape: BoxShape.circle,
//                         ),
//                         padding: const EdgeInsets.all(6),
//                         child: const Icon(
//                           Icons.camera_alt,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             /// Name
//             _input(context, "Name", nameController),
//
//             const SizedBox(height: 15),
//
//             /// Email
//             _readonly(context, "Email", FakeAuth.email ?? ""),
//
//             const SizedBox(height: 15),
//
//             /// Phone
//             _input(context, "Phone", phoneController),
//
//             const SizedBox(height: 15),
//
//             /// Address
//             _input(context, "Address", addressController),
//
//             const SizedBox(height: 30),
//
//             /// Save Button
//             GestureDetector(
//               onTap: () {
//
//                 FakeAuth.updateProfile(
//                   name: nameController.text,
//                   phoneNumber: phoneController.text,
//                   userAddress: addressController.text,
//                 );
//
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Profile Updated")),
//                 );
//
//                 Navigator.pop(context);
//               },
//
//               child: Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color(0xFF6C8CFF),
//                       Color(0xFF5F2EFF)
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Save",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _input(BuildContext context, String label, TextEditingController controller) {
//
//     final theme = Theme.of(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         const SizedBox(height: 6),
//
//         TextField(
//           controller: controller,
//
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: theme.cardColor,
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _readonly(BuildContext context, String label, String value) {
//
//     final theme = Theme.of(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         const SizedBox(height: 6),
//
//         Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//
//           decoration: BoxDecoration(
//             color: theme.cardColor,
//             borderRadius: BorderRadius.circular(14),
//           ),
//
//           child: Text(value),
//         )
//       ],
//     );
//   }
// }




//
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
//   final phoneController = TextEditingController();
//
//   bool isLoading = true;
//   bool isSaving = false;
//   String? email; // Email chỉ để hiển thị (Read-only)
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   // Lấy dữ liệu từ Backend đổ vào Controller
//   Future<void> _loadUserData() async {
//     final data = await ApiService.getProfile();
//     if (data != null) {
//       setState(() {
//         firstNameController.text = data['firstName'] ?? '';
//         lastNameController.text = data['lastName'] ?? '';
//         phoneController.text = data['phone'] ?? '';
//         email = data['email'];
//         isLoading = false;
//       });
//     }
//   }
//
//   // Gọi API PUT /api/v1/users/me
//   void handleSave() async {
//     setState(() => isSaving = true);
//
//     final success = await ApiService.updateProfile(
//       firstName: firstNameController.text,
//       lastName: lastNameController.text,
//       // avatarUrl: Hiện tại Backend đang để String, tạm thời giữ nguyên avatar cũ
//     );
//
//     setState(() => isSaving = false);
//
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Cập nhật thành công!")),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Lỗi hệ thống, vui lòng thử lại")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Chỉnh sửa hồ sơ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Giữ giao diện Avatar cũ của bạn
//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.person, size: 50, color: Color(0xFF5F2EFF)),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       decoration: const BoxDecoration(color: Color(0xFF5F2EFF), shape: BoxShape.circle),
//                       padding: const EdgeInsets.all(6),
//                       child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             _readonly("Email (Không thể sửa)", email ?? ""),
//             const SizedBox(height: 15),
//             _input("Họ", firstNameController),
//             const SizedBox(height: 15),
//             _input("Tên", lastNameController),
//             const SizedBox(height: 15),
//             _input("Số điện thoại", phoneController),
//             const SizedBox(height: 30),
//
//             GestureDetector(
//               onTap: isSaving ? null : handleSave,
//               child: Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Center(
//                   child: Text(
//                     isSaving ? "Đang lưu..." : "Lưu thay đổi",
//                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
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
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 6),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(color: const Color(0xFFE9EAF0), borderRadius: BorderRadius.circular(14)),
//           child: Text(value, style: const TextStyle(color: Colors.black54)),
//         )
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController(); // Backend của ông có phone

  bool isLoading = true;
  bool isSaving = false;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final data = await ApiService.getProfile();
    if (data != null && mounted) {
      setState(() {
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['lastName'] ?? '';
        phoneController.text = data['phone'] ?? '';
        userEmail = data['email'];
        isLoading = false;
      });
    }
  }

  void handleSave() async {
    setState(() => isSaving = true);

    final success = await ApiService.updateProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      // Nếu có avatarUrl thì thêm ở đây
    );

    if (mounted) setState(() => isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cập nhật thành công!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi khi cập nhật")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _readonly("Email", userEmail ?? ""),
            const SizedBox(height: 15),
            _input("First Name", firstNameController),
            const SizedBox(height: 15),
            _input("Last Name", lastNameController),
            const SizedBox(height: 15),
            _input("Phone", phoneController),
            const SizedBox(height: 30),

            GestureDetector(
              onTap: isSaving ? null : handleSave,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    isSaving ? "Saving..." : "Save",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _readonly(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFE9EAF0), borderRadius: BorderRadius.circular(14)),
          child: Text(value, style: const TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}