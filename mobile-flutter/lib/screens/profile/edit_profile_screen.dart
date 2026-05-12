import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
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
  late final TextEditingController _phone;
  late final TextEditingController _country;
  late final TextEditingController _bio;

  String? _gender;
  DateTime? _dateOfBirth;
  String? _timezone;
  bool _saving = false;
  bool _uploadingAvatar = false;
  File? _pickedImage;
  String? _newAvatarUrl;

  static const _genders = [
    ('MALE',   'Nam'),
    ('FEMALE', 'Nữ'),
    ('OTHER',  'Khác'),
  ];

  static const _timezones = [
    ('Asia/Ho_Chi_Minh', 'Việt Nam (GMT+7)'),
    ('Asia/Tokyo',       'Nhật Bản (GMT+9)'),
    ('Asia/Seoul',       'Hàn Quốc (GMT+9)'),
    ('Asia/Shanghai',    'Trung Quốc (GMT+8)'),
    ('America/New_York', 'New York (GMT-5)'),
    ('Europe/London',    'London (GMT+0)'),
    ('Europe/Paris',     'Paris (GMT+1)'),
  ];

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _firstName = TextEditingController(text: u['firstName'] as String? ?? '');
    _lastName  = TextEditingController(text: u['lastName']  as String? ?? '');
    _phone     = TextEditingController(text: u['phone']     as String? ?? '');
    _country   = TextEditingController(text: u['country']   as String? ?? '');
    _bio       = TextEditingController(text: u['bio']       as String? ?? '');
    _gender    = u['gender'] as String?;
    _timezone  = u['timezone'] as String?;
    final dob  = u['dateOfBirth'] as String?;
    if (dob != null) _dateOfBirth = DateTime.tryParse(dob);
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _country.dispose();
    _bio.dispose();
    super.dispose();
  }

  String get _initials {
    final f = _firstName.text.trim();
    final l = _lastName.text.trim();
    return '${f.isNotEmpty ? f[0] : 'U'}${l.isNotEmpty ? l[0] : ''}'.toUpperCase();
  }

  Future<void> _pickAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              title: Text(context.l10n.takePhoto, style: const TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
              title: Text(context.l10n.selectFromLibrary, style: const TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _pickedImage = File(picked.path);
      _uploadingAvatar = true;
    });

    final url = await ApiService.uploadAvatar(_pickedImage!);
    if (!mounted) return;
    if (url != null) {
      setState(() {
        _newAvatarUrl = url;
        _uploadingAvatar = false;
      });
    } else {
      setState(() => _uploadingAvatar = false);
      _snack(context.l10n.uploadPhotoFailed);
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 20),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 5),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onSurface: AppColors.textPrimary,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _save() async {
    final first = _firstName.text.trim();
    if (first.isEmpty) {
      _snack(context.l10n.lastNameRequired);
      return;
    }
    setState(() => _saving = true);

    String? dobStr;
    if (_dateOfBirth != null) {
      dobStr =
          '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}';
    }

    final result = await ApiService.updateProfile(
      firstName:   first,
      lastName:    _lastName.text.trim().isEmpty ? null : _lastName.text.trim(),
      phone:       _phone.text.trim().isEmpty    ? null : _phone.text.trim(),
      gender:      _gender,
      dateOfBirth: dobStr,
      country:     _country.text.trim().isEmpty  ? null : _country.text.trim(),
      timezone:    _timezone,
      bio:         _bio.text.trim().isEmpty       ? null : _bio.text.trim(),
    );

    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      _snack(context.l10n.profileUpdated);
      Navigator.pop(context, true);
    } else {
      _snack(context.l10n.updateFailed);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final email  = widget.user['email'] as String? ?? '';
    final avatar = _newAvatarUrl ?? widget.user['avatarUrl'] as String?;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 180,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Avatar ──────────────────────────────────
                        Center(
                          child: TappableScale(
                            onTap: _uploadingAvatar ? () {} : _pickAvatar,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 88, height: 88,
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.primaryIcon,
                                    shape: BoxShape.circle,
                                    boxShadow: AppShadows.primaryGlowSoft,
                                  ),
                                  child: _uploadingAvatar
                                      ? const Center(child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                      : _pickedImage != null
                                          ? ClipOval(child: Image.file(_pickedImage!, fit: BoxFit.cover))
                                          : avatar != null
                                              ? ClipOval(child: Image.network(avatar, fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => _avatarText()))
                                              : _avatarText(),
                                ),
                                Positioned(
                                  right: 0, bottom: 0,
                                  child: Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.bg, width: 2),
                                    ),
                                    child: const Icon(Icons.camera_alt_rounded,
                                        size: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Thông tin cơ bản ────────────────────────
                        _sectionLabel(context.l10n.basicInfo.toUpperCase()),
                        const SizedBox(height: 10),
                        _card([
                          _fieldTile('${context.l10n.lastName} *', _firstName, hint: 'Nguyễn'),
                          _divider(),
                          _fieldTile(context.l10n.firstName, _lastName, hint: 'Văn A'),
                          _divider(),
                          _readonlyTile(context.l10n.email, email, Icons.lock_outline_rounded),
                        ]),

                        const SizedBox(height: 20),

                        // ── Liên hệ ─────────────────────────────────
                        _sectionLabel(context.l10n.contactLocation.toUpperCase()),
                        const SizedBox(height: 10),
                        _card([
                          _fieldTile(context.l10n.phone, _phone,
                              hint: context.l10n.phoneHint,
                              keyboardType: TextInputType.phone),
                          _divider(),
                          _fieldTile(context.l10n.country, _country, hint: 'Việt Nam'),
                          _divider(),
                          _dropdownTile(
                            label: context.l10n.timezone,
                            value: _timezone,
                            hint: context.l10n.selectTimezone,
                            items: _timezones.map((t) => DropdownMenuItem(
                              value: t.$1,
                              child: Text(t.$2,
                                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                            )).toList(),
                            onChanged: (v) => setState(() => _timezone = v),
                          ),
                        ]),

                        const SizedBox(height: 20),

                        // ── Cá nhân ─────────────────────────────────
                        _sectionLabel(context.l10n.personalInfo.toUpperCase()),
                        const SizedBox(height: 10),
                        _card([
                          _dropdownTile(
                            label: context.l10n.gender,
                            value: _gender,
                            hint: context.l10n.selectGender,
                            items: _genders.map((g) => DropdownMenuItem(
                              value: g.$1,
                              child: Text(g.$2,
                                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                            )).toList(),
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                          _divider(),
                          _dateTile(),
                        ]),

                        const SizedBox(height: 20),

                        // ── Bio ─────────────────────────────────────
                        _sectionLabel(context.l10n.aboutYourself.toUpperCase()),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            controller: _bio,
                            maxLines: 4,
                            maxLength: 300,
                            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: context.l10n.bioHint,
                              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              counterStyle: const TextStyle(color: AppColors.textHint, fontSize: 11),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Save button ─────────────────────────────
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
                            onPressed: (_saving || _uploadingAvatar) ? null : _save,
                            child: _saving
                                ? const SizedBox(
                                    width: 20, height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : Text(context.l10n.save,
                                    style: const TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Widgets ───────────────────────────────────────────────

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(context.l10n.editProfile,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _avatarText() => Center(
        child: Text(_initials,
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
      );

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold,
            color: AppColors.textSecondary, letterSpacing: 0.8),
      );

  Widget _card(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      );

  Widget _divider() =>
      const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border);

  Widget _fieldTile(String label, TextEditingController ctrl,
      {String? hint, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readonlyTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14, color: AppColors.textHint)),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: AppColors.textHint),
        ],
      ),
    );
  }

  Widget _dropdownTile<T>({
    required String label,
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                hint: Text(hint,
                    style: const TextStyle(fontSize: 13, color: AppColors.textHint)),
                isExpanded: true,
                alignment: Alignment.centerRight,
                dropdownColor: AppColors.surface,
                iconEnabledColor: AppColors.textHint,
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTile() {
    final dobStr = _dateOfBirth != null
        ? '${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.year}'
        : null;

    return TappableScale(
      onTap: _pickDob,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(context.l10n.dateOfBirth,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ),
            Expanded(
              child: Text(
                dobStr ?? context.l10n.selectDateOfBirth,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 14,
                    color: dobStr != null ? AppColors.textPrimary : AppColors.textHint),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
