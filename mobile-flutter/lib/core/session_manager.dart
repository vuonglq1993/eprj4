import 'dart:async';

/// Phát sự kiện khi session hết hạn (401).
/// ApiService gọi [notifyExpired], LinguaNextApp lắng nghe và redirect về login.
class SessionManager {
  static final SessionManager instance = SessionManager._();
  SessionManager._();

  final _controller = StreamController<void>.broadcast();
  Stream<void> get onSessionExpired => _controller.stream;

  void notifyExpired() => _controller.add(null);
}
