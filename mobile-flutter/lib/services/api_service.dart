import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language_learning/services/token_service.dart';

class ApiService {

  static const String baseUrl = "http://10.0.2.2:8080/api/v1";

  static Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone, // ✅ thêm dòng này
  }) async {

    final url = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone, // ✅ thêm dòng này
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return response.statusCode == 201;
  }

  static Future<String?> login({
    required String email,
    required String password,
  }) async {

    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String token = data["accessToken"];

      // 🔥 BẮT BUỘC PHẢI CÓ
      await TokenService.saveToken(token);

      return token;
    }

    return null;
  }

  // GET PROFILE
  static Future<Map<String, dynamic>?> getProfile() async {

    final token = await TokenService.getToken();

    if (token == null) return null; // 🔥 thêm dòng này

    final response = await http.get(
      Uri.parse("$baseUrl/users/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }


// UPDATE PROFILE
  static Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? avatarUrl,
  }) async {

    final token = await TokenService.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/users/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "avatarUrl": avatarUrl,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {

    final token = await TokenService.getToken();

    final res = await http.patch(
      Uri.parse("$baseUrl/users/me/password"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );

    return res.statusCode == 200;
  }
}