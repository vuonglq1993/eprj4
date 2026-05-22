import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../l10n/l10n_ext.dart';
import '../../core/app_widgets.dart';
import '../../main.dart';
import '../../core/ai_button_controller.dart';
import '../../services/api_service.dart';
import '../../services/token_service.dart';
import '../../services/learning_service.dart';
import '../splash/splash_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Reminder settings (from backend)
  bool _reminderEnabled = false;
  int _reminderHour = 20;
  int _reminderMinute = 0;
  bool _reminderSaving = false;

  bool _twoFA = false;

  // Learning prefs
  String _uiLanguage = 'vi';
  int _xpGoal = 200;
  String _learningStyle = 'Visual';

  bool _loading = true;

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
    final reminder = await ApiService.getReminderSettings();
    if (mounted) {
      setState(() {
        _xpGoal = prefs.getInt(_kXpGoal) ?? 200;
        _learningStyle = prefs.getString(_kLearningStyle) ?? 'Visual';
        _uiLanguage = user?['uiLanguage'] as String? ?? 'vi';
        LearningService.setUiLanguage(_uiLanguage);
        if (reminder != null) {
          _reminderEnabled = reminder['enabled'] as bool? ?? false;
          _reminderHour = reminder['hour'] as int? ?? 20;
          _reminderMinute = reminder['minute'] as int? ?? 0;
        }
        _loading = false;
      });
    }
  }

  Future<void> _saveReminder() async {
    setState(() => _reminderSaving = true);
    await ApiService.updateReminderSettings(
      enabled: _reminderEnabled,
      hour: _reminderHour,
      minute: _reminderMinute,
    );
    if (mounted) setState(() => _reminderSaving = false);
  }

  Future<void> _pickReminderTime() async {
    int hour   = _reminderHour;
    int minute = _reminderMinute;

    final hourCtrl   = FixedExtentScrollController(initialItem: hour);
    final minuteCtrl = FixedExtentScrollController(initialItem: minute);

    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D2540),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => SizedBox(
          height: 300,
          child: Column(
            children: [
              // drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Giờ nhắc học',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _reminderHour   = hour;
                          _reminderMinute = minute;
                        });
                        Navigator.pop(context);
                        _saveReminder();
                      },
                      child: const Text('Xong',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // selection highlight
                    Center(
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hours
                        SizedBox(
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            controller: hourCtrl,
                            itemExtent: 48,
                            perspective: 0.003,
                            diameterRatio: 1.6,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (i) => setLocal(() => hour = i),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 24,
                              builder: (_, i) => Center(
                                child: Text(
                                  i.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: i == hour ? 22 : 17,
                                    fontWeight: i == hour
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: i == hour
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(':',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        // Minutes
                        SizedBox(
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            controller: minuteCtrl,
                            itemExtent: 48,
                            perspective: 0.003,
                            diameterRatio: 1.6,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (i) => setLocal(() => minute = i),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (_, i) => Center(
                                child: Text(
                                  i.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: i == minute ? 22 : 17,
                                    fontWeight: i == minute
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: i == minute
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    hourCtrl.dispose();
    minuteCtrl.dispose();
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0D2540),
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
    await GoogleSignIn().signOut();
    AiButtonController.onLogout();
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
        label: context.l10n.interfaceLanguage,
        subtitle: _uiLanguage == 'vi' ? context.l10n.vietnamese : _uiLanguage == 'ja' ? context.l10n.japanese : context.l10n.english,
        onTap: () => _pickLanguage(),
      ),
      _divider(),
      _rowItem(
        label: context.l10n.dailyXpGoal,
        subtitle: '$_xpGoal XP',
        onTap: () => _pickXpGoal(),
      ),
      _divider(),
      _rowItem(
        label: context.l10n.learningStyle,
        subtitle: _learningStyle,
        onTap: () => _pickLearningStyle(),
      ),
    ]);
  }

  Widget _notifSection() {
    final timeStr =
        '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}';
    return _card([
      _toggleItem(
        label: context.l10n.dailyReminder,
        subtitle: _reminderEnabled ? '$timeStr' : context.l10n.disabled,
        value: _reminderEnabled,
        onChanged: (v) {
          setState(() => _reminderEnabled = v);
          _saveReminder();
        },
      ),
      if (_reminderEnabled) ...[
        _divider(),
        _rowItem(
          label: context.l10n.reminderTime,
          subtitle: timeStr,
          onTap: _pickReminderTime,
        ),
      ],
      _divider(),
      _rowItem(
        label: context.l10n.sendTestNotification,
        subtitle: _reminderSaving ? context.l10n.saving : context.l10n.sendTestNotification,
        onTap: _reminderSaving
            ? () {}
            : () async {
                await ApiService.sendTestNotification();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.testNotificationSent)),
                  );
                }
              },
      ),
    ]);
  }

  Widget _securitySection() {
    return _card([
      _toggleItem(
        label: context.l10n.twoFactorAuth,
        subtitle: _twoFA ? context.l10n.enabled : context.l10n.disabled,
        value: _twoFA,
        onChanged: (v) {
          setState(() => _twoFA = v);
          if (v) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.twoFaComingSoon)),
            );
            setState(() => _twoFA = false);
          }
        },
      ),
      _divider(),
      _rowItem(
        label: context.l10n.changePassword,
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
      backgroundColor: const Color(0xFF0D2540),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(context.l10n.interfaceLanguage,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ListTile(
            title: Text(context.l10n.vietnamese, style: const TextStyle(color: AppColors.textPrimary)),
            trailing: const Text('vi'),
            onTap: () => Navigator.pop(context, 'vi'),
          ),
          ListTile(
            title: Text(context.l10n.english, style: const TextStyle(color: AppColors.textPrimary)),
            trailing: const Text('en'),
            onTap: () => Navigator.pop(context, 'en'),
          ),
          ListTile(
            title: Text(context.l10n.japanese, style: const TextStyle(color: AppColors.textPrimary)),
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
      LearningService.setUiLanguage(chosen);
      appStateKey.currentState?.setLocale(Locale(chosen));
    }
  }

  Future<void> _pickXpGoal() async {
    final options = [50, 100, 200, 300, 500];
    final chosen = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: const Color(0xFF0D2540),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(context.l10n.dailyXpGoal,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...options.map((xp) => ListTile(
            title: Text('$xp XP', style: const TextStyle(color: AppColors.textPrimary)),
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
      backgroundColor: const Color(0xFF0D2540),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(context.l10n.learningStyle,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
