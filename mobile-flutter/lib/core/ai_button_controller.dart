import 'package:flutter/foundation.dart';

/// Controls global visibility of the floating AI button.
/// Call [show] / [hide] in each screen's initState / dispose.
class AiButtonController {
  AiButtonController._();

  static final ValueNotifier<bool> visible = ValueNotifier(false);

  static void show() => visible.value = true;
  static void hide() => visible.value = false;
}
