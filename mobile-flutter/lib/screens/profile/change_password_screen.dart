import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/api_service.dart';

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

    if (current.isEmpty || newPw.isEmpty || confirm.isEmpty) {
      _snack('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (newPw.length < 6) {
      _snack('Mật khẩu mới phải có ít nhất 6 ký tự');
      return;
    }
    if (newPw != confirm) {
      _snack('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _saving = true);
    final error = await ApiService.changePassword(currentPassword: current, newPassword: newPw);
    if (!mounted) return;
    setState(() => _saving = false);

    if (error == null) {
      _snack('Đổi mật khẩu thành công');
      Navigator.pop(context);
    } else {
      _snack(error.contains('incorrect') || error.contains('wrong')
          ? 'Mật khẩu hiện tại không đúng'
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
          Positioned(top: 0, left: 0, right: 0, height: 180,
              child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  const SizedBox(height: 28),
                  _pwField('Mật khẩu hiện tại', _currentCtrl, _showCurrent,
                      () => setState(() => _showCurrent = !_showCurrent)),
                  const SizedBox(height: 16),
                  _pwField('Mật khẩu mới', _newCtrl, _showNew,
                      () => setState(() => _showNew = !_showNew)),
                  const SizedBox(height: 16),
                  _pwField('Xác nhận mật khẩu mới', _confirmCtrl, _showConfirm,
                      () => setState(() => _showConfirm = !_showConfirm)),
                  const SizedBox(height: 8),
                  const Text(
                    'Mật khẩu tối thiểu 6 ký tự',
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
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
                        _saving ? 'Đang lưu...' : 'Đổi mật khẩu',
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
          const Text('Đổi mật khẩu',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
              icon: Icon(show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
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
