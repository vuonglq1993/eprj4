import 'package:flutter/material.dart';

class LanguageService {

  // danh sách ngôn ngữ dùng chung toàn app
  static const List<Map<String, String>> languages = [
    {"name": "English", "flag": "🇺🇸"},
    {"name": "Vietnamese", "flag": "🇻🇳"},
    {"name": "French", "flag": "🇫🇷"},
    {"name": "German", "flag": "🇩🇪"},
    {"name": "Spanish", "flag": "🇪🇸"},
    {"name": "Japanese", "flag": "🇯🇵"},
    {"name": "Korean", "flag": "🇰🇷"},
    {"name": "Chinese", "flag": "🇨🇳"},
    {"name": "Russian", "flag": "🇷🇺"},
    {"name": "Italian", "flag": "🇮🇹"},
  ];

  // lưu index ngôn ngữ đã chọn
  static ValueNotifier<int?> selectedLanguage = ValueNotifier(null);

}