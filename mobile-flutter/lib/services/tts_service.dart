import 'package:flutter_tts/flutter_tts.dart';

/// Singleton wrapper around FlutterTts.
/// Usage: TtsService.instance.speak("Hello world")
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);   // slightly slower = easier to follow
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _tts.setCompletionHandler(() => _speaking = false);
    _tts.setCancelHandler(() => _speaking = false);
    _initialized = true;
  }

  bool get isSpeaking => _speaking;

  /// Speak [text] in English. Stops any current speech first.
  Future<void> speak(String text) async {
    await _init();
    if (_speaking) await stop();
    _speaking = true;
    await _tts.speak(text);
  }

  /// Speak [text] slowly (useful for pronunciation practice).
  Future<void> speakSlow(String text) async {
    await _init();
    if (_speaking) await stop();
    await _tts.setSpeechRate(0.28);
    _speaking = true;
    await _tts.speak(text);
    await _tts.setSpeechRate(0.45); // restore
  }

  Future<void> stop() async {
    _speaking = false;
    await _tts.stop();
  }
}
