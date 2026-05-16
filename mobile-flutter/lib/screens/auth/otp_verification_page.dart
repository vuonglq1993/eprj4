import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/ai_button_controller.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';
import '../home/home_placeholder.dart';
import '../onboarding/onboarding_flow.dart';
import 'login_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String? password; // nếu có → tự động login sau khi verify

  const OtpVerificationPage({super.key, required this.email, this.password});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown <= 0) { t.cancel(); return; }
      setState(() => _countdown--);
    });
  }

  Future<void> _verify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _snack('Vui lòng nhập đủ 6 chữ số');
      return;
    }
    setState(() => _isVerifying = true);

    final error = await ApiService.verifyEmail(widget.email, otp);
    if (!mounted) return;

    if (error != null) {
      setState(() => _isVerifying = false);
      String msg;
      if (error == 'network_error') {
        msg = 'Không có kết nối mạng';
      } else if (error.contains('expired') || error.contains('hết hạn')) {
        msg = 'Mã OTP đã hết hạn, vui lòng gửi lại';
      } else if (error.contains('used') || error.contains('đã dùng')) {
        msg = 'Mã OTP đã được sử dụng rồi';
      } else if (error.contains('not found') || error.contains('không tìm')) {
        msg = 'Không tìm thấy OTP, vui lòng gửi lại';
      } else {
        msg = 'Mã OTP không đúng, vui lòng thử lại';
      }
      _snack(msg);
      return;
    }

    // Verify thành công — tự login nếu có password
    if (widget.password != null) {
      final user = await ApiService.login(
        email: widget.email,
        password: widget.password!,
      );
      if (!mounted) return;
      if (user != null && user['_error'] == null) {
        final onboardingDone = await ApiService.isOnboardingCompleted();
        if (!mounted) return;
        AiButtonController.onLogin();
        NotificationService.instance.registerToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                onboardingDone ? const HomePlaceholder() : const OnboardingFlow(),
          ),
          (r) => false,
        );
        return;
      }
    }

    // Fallback: về login page
    if (!mounted) return;
    _snack('Xác thực thành công! Vui lòng đăng nhập.');
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (r) => false,
    );
  }

  Future<void> _resend() async {
    setState(() => _isResending = true);
    final error = await ApiService.resendOtp(widget.email);
    if (!mounted) return;
    setState(() => _isResending = false);
    if (error == null) {
      _snack('Đã gửi lại mã OTP');
      _otpController.clear();
      _startCountdown();
    } else {
      _snack('Không thể gửi lại, vui lòng thử lại sau');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Xác thực email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Nhập mã 6 chữ số đã gửi đến\n${_maskEmail(widget.email)}',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // OTP input
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.inputBg,
                  hintText: '······',
                  hintStyle: const TextStyle(
                    fontSize: 32,
                    color: AppColors.textHint,
                    letterSpacing: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderFocus, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                onChanged: (v) {
                  if (v.length == 6) _verify();
                },
              ),
              const SizedBox(height: 32),
              // Verify button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDeep],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isVerifying ? null : _verify,
                    child: _isVerifying
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Xác thực',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Resend
              Center(
                child: _countdown > 0
                    ? Text(
                        'Gửi lại sau $_countdown giây',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      )
                    : GestureDetector(
                        onTap: _isResending ? null : _resend,
                        child: _isResending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.accent,
                                ),
                              )
                            : const Text(
                                'Gửi lại mã OTP',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.accent,
                                ),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
