import 'package:flutter/foundation.dart';
import '../services/token_service.dart';

/// Controls global visibility of the floating AI button.
///
/// Rule: visible ↔ user is logged in.
/// No dependency on widget lifecycle — just call the right method
/// after login/logout events.
class AiButtonController {
  AiButtonController._();

  static final ValueNotifier<bool> visible = ValueNotifier(false);

  /// Call once at app startup to restore state from storage.
  static Future<void> init() async {
    visible.value = await TokenService.hasToken();
  }

  /// Call immediately after a successful login or registration.
  static void onLogin() => visible.value = true;

  /// Call immediately after logout.
  static void onLogout() => visible.value = false;
}
