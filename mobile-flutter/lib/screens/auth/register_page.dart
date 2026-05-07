import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../core/ai_button_controller.dart';
import '../../services/notification_service.dart';
import '../../services/api_service.dart';
import '../home/home_placeholder.dart';
import '../onboarding/onboarding_flow.dart';
import 'login_page.dart';
import '../../l10n/l10n_ext.dart';

enum _CheckStatus { idle, checking, available, taken, error }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  _CheckStatus _emailStatus = _CheckStatus.idle;
  _CheckStatus _phoneStatus = _CheckStatus.idle;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // ─── Check email ─────────────────────────────────────────────────────────

  Future<void> _checkEmail() async {
    final email = _email.text.trim();
    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(email)) return;
    setState(() => _emailStatus = _CheckStatus.checking);
    final exists = await ApiService.checkEmail(email);
    if (!mounted) return;
    setState(() {
      if (exists == null) {
        _emailStatus = _CheckStatus.error;
      } else {
        _emailStatus = exists ? _CheckStatus.taken : _CheckStatus.available;
      }
    });
    _formKey.currentState?.validate();
  }

  // ─── Check phone ─────────────────────────────────────────────────────────

  Future<void> _checkPhone() async {
    final phone = _phone.text.trim();
    if (!RegExp(r'^[0-9]{9,15}$').hasMatch(phone)) return;
    setState(() => _phoneStatus = _CheckStatus.checking);
    final exists = await ApiService.checkPhone(phone);
    if (!mounted) return;
    setState(() {
      if (exists == null) {
        _phoneStatus = _CheckStatus.error;
      } else {
        _phoneStatus = exists ? _CheckStatus.taken : _CheckStatus.available;
      }
    });
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────────

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: '579961382537-hfli270fo9pvfhb51d8fe1birvu1s113.apps.googleusercontent.com',
      );
      final account = await googleSignIn.signIn();
      if (account == null) {
        setState(() => _isGoogleLoading = false);
        return;
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        if (!mounted) return;
        setState(() => _isGoogleLoading = false);
        _snack(context.l10n.googleIdTokenError);
        return;
      }
      final user = await ApiService.loginWithGoogle(idToken);
      if (!mounted) return;
      setState(() => _isGoogleLoading = false);
      if (user != null) {
        final onboardingDone = await ApiService.isOnboardingCompleted();
        if (!mounted) return;
        AiButtonController.onLogin();
        NotificationService.instance.registerToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => onboardingDone ? const HomePlaceholder() : const OnboardingFlow(),
          ),
          (r) => false,
        );
      } else {
        _snack(context.l10n.googleBackendRejected);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGoogleLoading = false);
      _snack(context.l10n.googleSignInError(e.toString()));
    }
  }

  // ─── Register ─────────────────────────────────────────────────────────────

  Future<void> _register() async {
    // Reset check statuses to idle so validator skips "taken" state
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      _snack(context.l10n.agreeToTermsError);
      return;
    }
    if (_emailStatus == _CheckStatus.taken) {
      _snack(context.l10n.emailAlreadyRegistered);
      return;
    }
    if (_phoneStatus == _CheckStatus.taken) {
      _snack(context.l10n.phoneAlreadyRegistered);
      return;
    }

    setState(() => _isLoading = true);

    final error = await ApiService.register(
      email: _email.text.trim(),
      password: _password.text.trim(),
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: _phone.text.trim(),
    );

    if (!mounted) return;

    if (error == 'email_exists') {
      setState(() {
        _isLoading = false;
        _emailStatus = _CheckStatus.taken;
      });
      _formKey.currentState!.validate();
      return;
    }

    if (error != null) {
      setState(() => _isLoading = false);
      _snack(error == 'network_error'
          ? context.l10n.noNetworkConnection
          : context.l10n.registerFailed);
      return;
    }

    setState(() => _isLoading = false);

    // Tokens are already saved by register (201 response)
    if (!mounted) return;
    AiButtonController.onLogin();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingFlow()),
      (r) => false,
    );
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 220,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.bgTop),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                Text(
                  context.l10n.createAccount,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.freeNoCard,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),

                const SizedBox(height: 32),

                _googleButton(),
                const SizedBox(height: 24),
                _divider(context.l10n.orUseEmail),
                const SizedBox(height: 24),

                // Họ + Tên
                Row(
                  children: [
                    Expanded(
                      child: _input(
                        controller: _firstName,
                        hint: context.l10n.lastName,
                        icon: Icons.person_outline_rounded,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return context.l10n.enterLastName;
                          if (v.trim().length < 2) return context.l10n.tooShort;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _input(
                        controller: _lastName,
                        hint: context.l10n.firstName,
                        icon: Icons.person_outline_rounded,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return context.l10n.enterFirstName;
                          if (v.trim().length < 2) return context.l10n.tooShort;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Email + check button
                _inputWithCheck(
                  controller: _email,
                  hint: context.l10n.email,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  status: _emailStatus,
                  onCheck: _checkEmail,
                  onChanged: (_) => setState(() => _emailStatus = _CheckStatus.idle),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return context.l10n.enterEmail;
                    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(v.trim())) {
                      return context.l10n.invalidEmail;
                    }
                    if (_emailStatus == _CheckStatus.taken) return context.l10n.emailAlreadyRegistered;
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Phone + check button
                _inputWithCheck(
                  controller: _phone,
                  hint: context.l10n.phone,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  status: _phoneStatus,
                  onCheck: _checkPhone,
                  onChanged: (_) => setState(() => _phoneStatus = _CheckStatus.idle),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return context.l10n.enterPhone;
                    if (!RegExp(r'^[0-9]{9,15}$').hasMatch(v.trim())) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    if (_phoneStatus == _CheckStatus.taken) return 'Số điện thoại đã được dùng';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Password
                _input(
                  controller: _password,
                  hint: context.l10n.password,
                  icon: Icons.lock_outline_rounded,
                  obscure: !_showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return context.l10n.enterPassword;
                    if (v.length < 8) return 'Ít nhất 8 ký tự';
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(v)) {
                      return context.l10n.passwordNeedsLetterNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Confirm password
                _input(
                  controller: _confirmPassword,
                  hint: context.l10n.confirmPassword,
                  icon: Icons.lock_outline_rounded,
                  obscure: !_showConfirm,
                  suffix: IconButton(
                    icon: Icon(
                      _showConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _showConfirm = !_showConfirm),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return context.l10n.confirmPassword;
                    if (v != _password.text) return 'Mật khẩu không khớp';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Terms checkbox
                GestureDetector(
                  onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _checkbox(_agreedToTerms),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: context.l10n.agreeToTerms,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: context.l10n.termsOfService,
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(text: ' & '),
                              TextSpan(
                                text: context.l10n.privacyPolicy,
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : _primaryButton(context.l10n.createAccount, _register),

                const SizedBox(height: 24),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: context.l10n.alreadyHaveAccount,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: context.l10n.login,
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: _isGoogleLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              )
            : const Text('G',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        label: Text(
          _isGoogleLoading ? context.l10n.processing : context.l10n.continueWithGoogle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: _isGoogleLoading ? null : _signInWithGoogle,
      ),
    );
  }

  Widget _divider(String label) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  /// Input field cơ bản (không có check button)
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: _inputDecoration(hint: hint, icon: icon, suffix: suffix),
      validator: validator,
    );
  }

  /// Input field có nút check ở suffix
  Widget _inputWithCheck({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required _CheckStatus status,
    required VoidCallback onCheck,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    Widget suffixWidget;
    switch (status) {
      case _CheckStatus.checking:
        suffixWidget = const Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: AppColors.primary, strokeWidth: 2),
          ),
        );
      case _CheckStatus.available:
        suffixWidget = const Icon(Icons.check_circle_rounded,
            color: AppColors.success, size: 22);
      case _CheckStatus.taken:
        suffixWidget = const Icon(Icons.cancel_rounded,
            color: AppColors.error, size: 22);
      case _CheckStatus.error:
        suffixWidget = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: TextButton(
            onPressed: onCheck,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
            ),
            child: Text(context.l10n.retry,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
        );
      case _CheckStatus.idle:
        suffixWidget = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: TextButton(
            onPressed: onCheck,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
            ),
            child: Text(context.l10n.check,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      onChanged: onChanged,
      decoration: _inputDecoration(hint: hint, icon: icon, suffix: suffixWidget),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Widget _checkbox(bool value) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: value ? AppColors.primary : AppColors.border,
          width: 1.5,
        ),
      ),
      child: value ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return GradientButton(label: label, onTap: onTap);
  }
}
