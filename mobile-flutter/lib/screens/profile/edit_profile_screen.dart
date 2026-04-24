import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/api_service.dart';
import '../../l10n/l10n_ext.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.user['firstName'] as String? ?? '');
    _lastName = TextEditingController(text: widget.user['lastName'] as String? ?? '');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    if (first.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.lastNameRequired)));
      return;
    }
    setState(() => _saving = true);
    final result = await ApiService.updateProfile(firstName: first, lastName: last);
    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profileUpdated)));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.updateFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.user['email'] as String? ?? '';
    final avatar = widget.user['avatarUrl'] as String?;
    final initials = '${(_firstName.text.isNotEmpty ? _firstName.text[0] : 'U')}${(_lastName.text.isNotEmpty ? _lastName.text[0] : '')}'.toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 180,
              child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                children: [
                  _topBar(),
                  const SizedBox(height: 24),
                  // Avatar
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(gradient: AppGradients.primaryIcon, shape: BoxShape.circle),
                    child: avatar != null
                        ? ClipOval(child: Image.network(avatar, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(initials, style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)))))
                        : Center(child: Text(initials,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                  const SizedBox(height: 24),
                  _field('Họ', _firstName, 'Nhập họ'),
                  const SizedBox(height: 14),
                  _field('Tên', _lastName, 'Nhập tên'),
                  const SizedBox(height: 14),
                  // Email (read-only)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.email, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                            const SizedBox(height: 2),
                            Text(email, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textHint),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: _saving ? null : _save,
                      child: Text(
                        _saving ? context.l10n.saving : context.l10n.save,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(context.l10n.editProfile,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppColors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
