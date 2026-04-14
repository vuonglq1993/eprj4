// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:language_learning/services/token_service.dart';
//
// class OnboardingService {
//   static const String baseUrl = "http://10.0.2.2:8080/api/v1/onboarding";
//
//   static Future<Map<String, dynamic>?> getStatus() async {
//     try {
//       final token = await TokenService.getToken();
//       if (token == null) return null;
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/status"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("ONBOARDING STATUS CODE: ${response.statusCode}");
//       print("ONBOARDING STATUS BODY: ${response.body}");
//
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//
//       return null;
//     } catch (e) {
//       print("getStatus error: $e");
//       return null;
//     }
//   }
//
//   static Future<Map<String, dynamic>?> submit({
//     required String targetLanguageId,
//     required String nativeLanguageCode,
//     required String selfLevel,
//     required String goal,
//     required String dailyTime,
//     required String ageGroup,
//     required String heardFrom,
//   }) async {
//     try {
//       final token = await TokenService.getToken();
//       if (token == null) return null;
//
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "targetLanguageId": targetLanguageId,
//           "nativeLanguageCode": nativeLanguageCode,
//           "selfLevel": selfLevel,
//           "goal": goal,
//           "dailyTime": dailyTime,
//           "ageGroup": ageGroup,
//           "heardFrom": heardFrom,
//         }),
//       );
//
//       print("ONBOARDING SUBMIT CODE: ${response.statusCode}");
//       print("ONBOARDING SUBMIT BODY: ${response.body}");
//
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//
//       return null;
//     } catch (e) {
//       print("submit onboarding error: $e");
//       return null;
//     }
//   }
//
//   static Future<Map<String, dynamic>?> getMyOnboarding() async {
//     try {
//       final token = await TokenService.getToken();
//       if (token == null) return null;
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/me"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("GET MY ONBOARDING CODE: ${response.statusCode}");
//       print("GET MY ONBOARDING BODY: ${response.body}");
//
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//
//       return null;
//     } catch (e) {
//       print("getMyOnboarding error: $e");
//       return null;
//     }
//   }
// }



//bản mới nối learingpath
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language_learning/services/token_service.dart';
import '../config/app_config.dart';

class OnboardingService {
  static String get baseUrl => "${AppConfig.apiBaseUrl}/onboarding";

  static Future<Map<String, dynamic>?> getStatus() async {
    try {
      final token = await TokenService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/status"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("ONBOARDING STATUS CODE: ${response.statusCode}");
      print("ONBOARDING STATUS BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }

      return null;
    } catch (e) {
      print("getStatus error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> submit({
    required String targetLanguageId,
    required String nativeLanguageCode,
    required String selfLevel,
    required String goal,
    required String dailyTime,
    required String ageGroup,
    required String heardFrom,
    String? learningPathId,
  }) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "targetLanguageId": targetLanguageId,
          "nativeLanguageCode": nativeLanguageCode,
          "selfLevel": selfLevel,
          "goal": goal,
          "dailyTime": dailyTime,
          "ageGroup": ageGroup,
          "heardFrom": heardFrom,
          "learningPathId": learningPathId,
        }),
      );

      print("ONBOARDING SUBMIT CODE: ${response.statusCode}");
      print("ONBOARDING SUBMIT BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }

      return null;
    } catch (e) {
      print("submit onboarding error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getMyOnboarding() async {
    try {
      final token = await TokenService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("GET MY ONBOARDING CODE: ${response.statusCode}");
      print("GET MY ONBOARDING BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }

      return null;
    } catch (e) {
      print("getMyOnboarding error: $e");
      return null;
    }
  }
}