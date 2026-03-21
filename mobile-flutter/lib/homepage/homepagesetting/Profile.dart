// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import 'edit_profile_page.dart';
// import 'change_password_page.dart';
//
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   Map<String, dynamic>? user;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//   Future<void> _fetchData() async {
//     final data = await ApiService.getProfile();
//     setState(() {
//       user = data;
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//         centerTitle: true,
//         title: const Text("Hồ sơ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 60, color: Color(0xFF5F2EFF)),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               "${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             Text(user?['email'] ?? '', style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 30),
//
//             _menuItem(Icons.person_outline, "Chỉnh sửa thông tin", () async {
//               await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
//               _fetchData();
//             }),
//             _menuItem(Icons.lock_outline, "Đổi mật khẩu", () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//       child: ListTile(
//         leading: Icon(icon, color: const Color(0xFF5F2EFF)),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//         onTap: onTap,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await ApiService.getProfile();
    if (mounted) {
      setState(() {
        user = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        elevation: 0,
        centerTitle: true,
        title: const Text("Hồ sơ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: Color(0xFF5F2EFF)),
            ),
            const SizedBox(height: 15),
            Text(
              "${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(user?['email'] ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            _menuItem(Icons.person_outline, "Chỉnh sửa thông tin", () async {
              // Chuyển sang trang Edit
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
              _fetchData(); // Khi quay lại thì load lại data mới
            }),
            _menuItem(Icons.lock_outline, "Đổi mật khẩu", () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF5F2EFF)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}