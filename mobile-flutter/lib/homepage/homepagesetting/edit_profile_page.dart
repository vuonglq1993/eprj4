import 'package:flutter/material.dart';
import '../../services/fake_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final nameController =
  TextEditingController(text: FakeAuth.userName);

  final phoneController =
  TextEditingController(text: FakeAuth.phone);

  final addressController =
  TextEditingController(text: FakeAuth.address);

  File? avatarImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    avatarImage = FakeAuth.avatar;
  }

  Future<void> pickAvatar() async {

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      final image = File(picked.path);

      setState(() {
        avatarImage = image;
      });

      FakeAuth.avatar = image;
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// Avatar
            Center(
              child: GestureDetector(
                onTap: pickAvatar,
                child: Stack(
                  children: [

                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.cardColor,
                      backgroundImage:
                      avatarImage != null
                          ? FileImage(avatarImage!)
                          : null,
                      child: avatarImage == null
                          ? Icon(
                        Icons.person,
                        size: 50,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF5F2EFF),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Name
            _input(context, "Name", nameController),

            const SizedBox(height: 15),

            /// Email
            _readonly(context, "Email", FakeAuth.email ?? ""),

            const SizedBox(height: 15),

            /// Phone
            _input(context, "Phone", phoneController),

            const SizedBox(height: 15),

            /// Address
            _input(context, "Address", addressController),

            const SizedBox(height: 30),

            /// Save Button
            GestureDetector(
              onTap: () {

                FakeAuth.updateProfile(
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  userAddress: addressController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated")),
                );

                Navigator.pop(context);
              },

              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6C8CFF),
                      Color(0xFF5F2EFF)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
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
  }

  Widget _input(BuildContext context, String label, TextEditingController controller) {

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        TextField(
          controller: controller,

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

  Widget _readonly(BuildContext context, String label, String value) {

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
          ),

          child: Text(value),
        )
      ],
    );
  }
}