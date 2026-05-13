import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/api_service.dart';
import '../../l10n/l10n_ext.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;

  // Profile info
  bool _loadingProfile = true;
  bool _hasPassword = true;   // default true để tránh flash UI
  String _provider = 'LOCAL';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ApiService.getProfile();
    if (!mounted) return;
    setState(() {
      _hasPassword = profile?['hasPassword'] as bool? ?? true;
      _provider = profile?['provider'] as String? ?? 'LOCAL';
      _loadingProfile = false;
    });
  }

  bool get _isGoogleNoPassword => _provider == 'GOOGLE' && !_hasPassword;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final current = _currentCtrl.text;
    final newPw = _newCtrl.text;
    final confirm = _confirmCtrl.text;

    // Google user chưa có password không cần nhập current
    if (!_isGoogleNoPassword && current.isEmpty) {
      _snack(context.l10n.fillAllFields);
      return;
    }
    if (newPw.isEmpty || confirm.isEmpty) {
      _snack(context.l10n.fillAllFields);
      return;
    }
    if (newPw.length < 8) {
      _snack(context.l10n.newPasswordMinLength);
      return;
    }
    if (newPw != confirm) {
      _snack(context.l10n.passwordsDoNotMatch);
      return;
    }

    setState(() => _saving = true);
    final error = await ApiService.changePassword(
      currentPassword: _isGoogleNoPassword ? null : current,
      newPassword: newPw,
    );
    if (!mounted) return;
    setState(() => _saving = false);

    if (error == null) {
      _snack(_isGoogleNoPassword
          ? context.l10n.passwordSetSuccess
          : context.l10n.passwordChangedSuccess);
      // Cập nhật state: giờ đã có password
      setState(() => _hasPassword = true);
      Navigator.pop(context);
    } else {
      _snack(error.contains('incorrect') || error.contains('wrong')
          ? context.l10n.currentPasswordWrong
          : error.contains('last')
              ? context.l10n.passwordRecentlyUsed
              : error);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 180,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: _loadingProfile
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topBar(),
                        const SizedBox(height: 12),

                        // Banner Google user
                        if (_isGoogleNoPassword) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    size: 18, color: AppColors.primaryLight),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    context.l10n.googleSetPasswordInfo,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primaryLight,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ] else
                          const SizedBox(height: 16),

                        // Field mật khẩu hiện tại — ẩn nếu Google user chưa có password
                        if (!_isGoogleNoPassword) ...[
                          _pwField(context.l10n.currentPassword, _currentCtrl, _showCurrent,
                              () => setState(() => _showCurrent = !_showCurrent)),
                          const SizedBox(height: 16),
                        ],

                        _pwField(context.l10n.newPassword, _newCtrl, _showNew,
                            () => setState(() => _showNew = !_showNew)),
                        const SizedBox(height: 16),
                        _pwField(context.l10n.confirmNewPassword, _confirmCtrl, _showConfirm,
                            () => setState(() => _showConfirm = !_showConfirm)),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.passwordMinLength,
                          style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                        ),
                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            onPressed: _saving ? null : _save,
                            child: Text(
                              _saving
                                  ? context.l10n.saving
                                  : (_isGoogleNoPassword
                                      ? context.l10n.setPassword
                                      : context.l10n.save),
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            _isGoogleNoPassword
                ? context.l10n.setPassword
                : context.l10n.changePassword,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _pwField(String label, TextEditingController ctrl, bool show, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: !show,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppColors.inputBg,
            suffixIcon: IconButton(
              icon: Icon(
                  show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 20, color: AppColors.textHint),
              onPressed: toggle,
            ),
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
