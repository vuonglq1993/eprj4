import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../l10n/l10n_ext.dart';
import '../../core/app_widgets.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';
import '../splash/splash_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification prefs (local)
  bool _studyReminder = true;
  bool _streakReminder = true;
  bool _weeklyReport = false;
  bool _twoFA = false;

  // Learning prefs
  String _uiLanguage = 'vi';
  int _xpGoal = 200;
  String _learningStyle = 'Visual';

  bool _loading = true;

  static const _kStudyReminder = 'pref_study_reminder';
  static const _kStreakReminder = 'pref_streak_reminder';
  static const _kWeeklyReport = 'pref_weekly_report';
  static const _kXpGoal = 'pref_xp_goal';
  static const _kLearningStyle = 'pref_learning_style';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await ApiService.getProfile();
    if (mounted) {
      setState(() {
        _studyReminder = prefs.getBool(_kStudyReminder) ?? true;
        _streakReminder = prefs.getBool(_kStreakReminder) ?? true;
        _weeklyReport = prefs.getBool(_kWeeklyReport) ?? false;
        _xpGoal = prefs.getInt(_kXpGoal) ?? 200;
        _learningStyle = prefs.getString(_kLearningStyle) ?? 'Visual';
        _uiLanguage = user?['uiLanguage'] as String? ?? 'en';
        _loading = false;
      });
    }
  }

  Future<void> _saveNotifPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(context.l10n.logout, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(context.l10n.logoutConfirm,
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.confirm, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ApiService.logout();
    await TokenService.clearTokens();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 180,
              child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop))),
          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topBar(),
                        const SizedBox(height: 16),
                        _sectionLabel(context.l10n.settingsLearning),
                        const SizedBox(height: 8),
                        _learningSection(),
                        const SizedBox(height: 20),
                        _sectionLabel(context.l10n.settingsNotifications),
                        const SizedBox(height: 8),
                        _notifSection(),
                        const SizedBox(height: 20),
                        _sectionLabel(context.l10n.settingsSecurity),
                        const SizedBox(height: 8),
                        _securitySection(),
                        const SizedBox(height: 24),
                        _logoutButton(),
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
          Text(context.l10n.settings,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 4),
    child: Text(label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
            color: AppColors.textSecondary, letterSpacing: 0.8)),
  );

  Widget _learningSection() {
    return _card([
      _rowItem(
        label: 'Ngôn ngữ giao diện',
        subtitle: _uiLanguage == 'vi' ? 'Tiếng Việt' : _uiLanguage == 'ja' ? '日本語' : 'English',
        onTap: () => _pickLanguage(),
      ),
      _divider(),
      _rowItem(
        label: 'Mục tiêu XP mỗi ngày',
        subtitle: '$_xpGoal XP',
        onTap: () => _pickXpGoal(),
      ),
      _divider(),
      _rowItem(
        label: 'Phong cách học',
        subtitle: _learningStyle,
        onTap: () => _pickLearningStyle(),
      ),
    ]);
  }

  Widget _notifSection() {
    return _card([
      _toggleItem(
        label: 'Nhắc nhở học',
        subtitle: 'Mỗi ngày lúc 20:00',
        value: _studyReminder,
        onChanged: (v) {
          setState(() => _studyReminder = v);
          _saveNotifPref(_kStudyReminder, v);
        },
      ),
      _divider(),
      _toggleItem(
        label: 'Streak reminder',
        subtitle: 'Khi sắp mất streak',
        value: _streakReminder,
        onChanged: (v) {
          setState(() => _streakReminder = v);
          _saveNotifPref(_kStreakReminder, v);
        },
      ),
      _divider(),
      _toggleItem(
        label: 'Weekly Report',
        subtitle: 'Email thứ 2 hàng tuần',
        value: _weeklyReport,
        onChanged: (v) {
          setState(() => _weeklyReport = v);
          _saveNotifPref(_kWeeklyReport, v);
        },
      ),
    ]);
  }

  Widget _securitySection() {
    return _card([
      _toggleItem(
        label: 'Xác thực 2 lớp (2FA)',
        subtitle: _twoFA ? 'Đang bật' : 'Đang tắt',
        value: _twoFA,
        onChanged: (v) {
          setState(() => _twoFA = v);
          if (v) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tính năng 2FA sẽ ra mắt trong bản cập nhật tới')),
            );
            setState(() => _twoFA = false);
          }
        },
      ),
      _divider(),
      _rowItem(
        label: 'Đổi mật khẩu',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
        ),
      ),
    ]);
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _rowItem({required String label, String? subtitle, required VoidCallback onTap}) {
    return TappableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                  if (subtitle != null)
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.border);

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: AppColors.error,
        ),
        icon: const Icon(Icons.logout_rounded),
        label: Text(context.l10n.logout, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        onPressed: _logout,
      ),
    );
  }

  // ── Pickers ────────────────────────────────────────────────
  Future<void> _pickLanguage() async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text('Ngôn ngữ giao diện',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Tiếng Việt', style: TextStyle(color: AppColors.textPrimary)),
            trailing: const Text('vi'),
            onTap: () => Navigator.pop(context, 'vi'),
          ),
          ListTile(
            title: const Text('English', style: TextStyle(color: AppColors.textPrimary)),
            trailing: const Text('en'),
            onTap: () => Navigator.pop(context, 'en'),
          ),
          ListTile(
            title: const Text('日本語', style: TextStyle(color: AppColors.textPrimary)),
            trailing: const Text('ja'),
            onTap: () => Navigator.pop(context, 'ja'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
    if (chosen != null && chosen != _uiLanguage) {
      await ApiService.updateProfile(uiLanguage: chosen);
      if (!mounted) return;
      setState(() => _uiLanguage = chosen);
      appStateKey.currentState?.setLocale(Locale(chosen));
    }
  }

  Future<void> _pickXpGoal() async {
    final options = [50, 100, 200, 300, 500];
    final chosen = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text('Mục tiêu XP mỗi ngày',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...options.map((xp) => ListTile(
            title: Text('$xp XP / ngày', style: const TextStyle(color: AppColors.textPrimary)),
            trailing: xp == _xpGoal
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () => Navigator.pop(context, xp),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
    if (chosen != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kXpGoal, chosen);
      if (mounted) setState(() => _xpGoal = chosen);
    }
  }

  Future<void> _pickLearningStyle() async {
    final styles = ['Visual', 'Auditory', 'Reading', 'Kinesthetic'];
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text('Phong cách học',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...styles.map((s) => ListTile(
            title: Text(s, style: const TextStyle(color: AppColors.textPrimary)),
            trailing: s == _learningStyle
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () => Navigator.pop(context, s),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
    if (chosen != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLearningStyle, chosen);
      if (mounted) setState(() => _learningStyle = chosen);
    }
  }
}
