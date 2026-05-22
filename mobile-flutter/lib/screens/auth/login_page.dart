import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../core/ai_button_controller.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';
import '../onboarding/onboarding_flow.dart';
import '../home/home_placeholder.dart';
import 'register_page.dart';
import 'otp_verification_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../l10n/l10n_ext.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _enable2FA = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = await ApiService.login(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );

    if (!mounted) return;

    if (user != null && user['_error'] == 'email_not_verified') {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
            email: user['_email'] as String? ?? _email.text.trim(),
            password: _password.text.trim(),
          ),
        ),
      );
      return;
    }

    if (user == null) {
      setState(() => _isLoading = false);
      _snack(context.l10n.wrongCredentials);
      return;
    }

    final onboardingDone = await ApiService.isOnboardingCompleted();
    if (!mounted) return;
    setState(() => _isLoading = false);

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
            top: 0,
            left: 0,
            right: 0,
            height: 220,
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

                // Logo chip
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryIcon,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppShadows.primaryGlow,
                  ),
                  child: const Icon(Icons.layers_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(height: 20),

                // Header
                Text(
                  context.l10n.welcomeBack,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.loginToContinue,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Google button
                _googleButton(),
                const SizedBox(height: 24),

                // Divider
                _divider(context.l10n.orEmail),
                const SizedBox(height: 24),

                // Email
                _input(
                  controller: _email,
                  hint: context.l10n.email,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return context.l10n.enterEmail;
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(v.trim())) return context.l10n.invalidEmail;
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
                      _showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return context.l10n.enterPassword;
                    return null;
                  },
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _snack(context.l10n.featureInDevelopment),
                    child: Text(
                      context.l10n.forgotPassword,
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Login button
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary))
                    : _primaryButton(context.l10n.login, _login),

                const SizedBox(height: 20),

                // 2FA toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.twoFaTitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Switch(
                        value: _enable2FA,
                        onChanged: (v) {
                          setState(() => _enable2FA = v);
                          if (v) _snack(context.l10n.twoFaActivated);
                        },
                        activeColor: AppColors.primary,
                        trackColor: WidgetStateProperty.all(AppColors.border),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Register link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: context.l10n.noAccount,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: context.l10n.register,
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

                const SizedBox(height: 32),
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


Future<void> _signInWithGoogle() async {
  setState(() => _isGoogleLoading = true);

  try {
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    );

    await googleSignIn.signOut();
    final account = await googleSignIn.signIn();

    if (account == null) {
      setState(() => _isGoogleLoading = false);
      return;
    }

    final auth = await account.authentication;

    final idToken = auth.idToken;

    if (idToken == null) {
      setState(() => _isGoogleLoading = false);
      _snack(context.l10n.googleIdTokenError);
      return;
    }

    // 🔥 Gửi lên backend Spring Boot
    final user = await ApiService.loginWithGoogle(idToken);

    if (!mounted) return;

    setState(() => _isGoogleLoading = false);

    if (user != null) {
      final onboardingDone =
          await ApiService.isOnboardingCompleted();

      if (!mounted) return;

      AiButtonController.onLogin();
      NotificationService.instance.registerToken();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => onboardingDone
              ? const HomePlaceholder()
              : const OnboardingFlow(),
        ),
        (r) => false,
      );
    } else {
      _snack(context.l10n.googleBackendRejected);
    }
  } catch (e) {
    setState(() => _isGoogleLoading = false);


    final msg = e.toString();

    if (msg.contains('10')) {
      _snack(context.l10n.googleSha1Error);
    } else if (msg.contains('12500')) {
      _snack(context.l10n.googleOAuthError);
    } else if (msg.contains('7')) {
      _snack(context.l10n.googleNetworkError);
    } else {
      _snack(context.l10n.googleSignInError(msg));
    }
  }
}

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: _isGoogleLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              )
            : const Text('G',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
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
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

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
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      ),
      validator: validator,
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return GradientButton(label: label, onTap: onTap);
  }
}
