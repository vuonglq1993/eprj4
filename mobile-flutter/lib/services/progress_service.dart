// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/stats_model.dart';
// import 'token_service.dart';
//
// class ProgressApiService {
//   static const String baseUrl = "http://10.0.2.2:8080/api/v1";
//
//   static Future<StatsResponse?> getStats(String period) async {
//     final token = await TokenService.getToken();
//
//     // Quan trọng: Chuyển sang viết hoa để khớp với Backend (WEEK, MONTH, DAILY)
//     String formattedPeriod = period.toUpperCase();
//     if (formattedPeriod == 'WEEKLY') formattedPeriod = 'WEEK';
//     if (formattedPeriod == 'MONTHLY') formattedPeriod = 'MONTH';
//     if (formattedPeriod == 'DAILY') formattedPeriod = 'DAY';
//
//     final response = await http.get(
//       Uri.parse("$baseUrl/progress/stats?period=$formattedPeriod"),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // Sử dụng utf8.decode để tránh lỗi font chữ tiếng Việt
//       return StatsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
//     }
//     return null;
//   }
//
//   static Future<Map<String, dynamic>?> getDashboard() async {
//     final token = await TokenService.getToken();
//     final response = await http.get(
//       Uri.parse("$baseUrl/dashboard"),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(utf8.decode(response.bodyBytes));
//     }
//     return null;
//   }
// }





import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stats_model.dart';
import 'token_service.dart';

class ProgressApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  static Future<StatsResponse> getStats(String period) async {
    final token = await TokenService.getToken();

    String formattedPeriod = period.toUpperCase();

    // map text UI sang backend
    if (formattedPeriod == 'DAILY') formattedPeriod = 'WEEK';
    if (formattedPeriod == 'WEEKLY') formattedPeriod = 'MONTH';
    if (formattedPeriod == 'MONTHLY') formattedPeriod = 'YEAR';

    // nếu gọi trực tiếp đúng chuẩn backend thì giữ nguyên
    if (formattedPeriod != 'WEEK' &&
        formattedPeriod != 'MONTH' &&
        formattedPeriod != 'YEAR') {
      formattedPeriod = 'WEEK';
    }

    final response = await http.get(
      Uri.parse("$baseUrl/progress/stats?period=$formattedPeriod"),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StatsResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    }

    throw Exception("Không thể tải stats: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> getDashboard() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }

    throw Exception("Không thể tải dashboard: ${response.statusCode}");
  }
}