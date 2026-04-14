// import 'package:flutter/material.dart';
//
// class LanguageService {
//
//   // danh sách ngôn ngữ dùng chung toàn app
//   static const List<Map<String, String>> languages = [
//     {"name": "English", "flag": "🇺🇸"},
//     {"name": "Vietnamese", "flag": "🇻🇳"},
//     {"name": "French", "flag": "🇫🇷"},
//     {"name": "German", "flag": "🇩🇪"},
//     {"name": "Spanish", "flag": "🇪🇸"},
//     {"name": "Japanese", "flag": "🇯🇵"},
//     {"name": "Korean", "flag": "🇰🇷"},
//     {"name": "Chinese", "flag": "🇨🇳"},
//     {"name": "Russian", "flag": "🇷🇺"},
//     {"name": "Italian", "flag": "🇮🇹"},
//   ];
//
//   // lưu index ngôn ngữ đã chọn
//   static ValueNotifier<int?> selectedLanguage = ValueNotifier(null);
//
// }






import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language_model.dart';
import '../config/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class LanguageService {

  static String get baseUrl => "${AppConfig.apiBaseUrl}/languages";

  static List<Language> cachedLanguages = [];

  static ValueNotifier<Language?> selectedLanguage = ValueNotifier(null);

  /// 🔥 LOAD từ local
  // static Future<void> loadSelectedLanguage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? code = prefs.getString("language_code");
  //
  //   if (code != null && cachedLanguages.isNotEmpty) {
  //     try {
  //       selectedLanguage.value =
  //           cachedLanguages.firstWhere((l) => l.code == code);
  //     } catch (e) {
  //       selectedLanguage.value = null;
  //     }
  //   }
  // }

  static Future<void> loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("language_code");

    if (code == null) return;

    try {
      selectedLanguage.value =
          cachedLanguages.firstWhere((l) => l.code == code);
    } catch (e) {
      selectedLanguage.value = cachedLanguages.isNotEmpty
          ? cachedLanguages.first
          : null;
    }
  }

  /// 🔥 SAVE
  static Future<void> saveSelectedLanguage(Language lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language_code", lang.code);

    selectedLanguage.value = lang;
  }

  static Future<List<Language>> fetchLanguages() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      cachedLanguages = data.map((e) => Language.fromJson(e)).toList();

      /// 🔥 load lại sau khi fetch
      await loadSelectedLanguage();

      return cachedLanguages;
    } else {
      throw Exception("Failed to load languages");
    }
  }
}