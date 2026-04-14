// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:language_learning/services/token_service.dart';
// import 'package:language_learning/models/subscription_models.dart';
//
// class SubscriptionApiService {
//   static const String baseUrl = "http://10.0.2.2:8080/api/v1";
//
//   static Future<List<SubscriptionPlanModel>> getPlans() async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/subscription-plans"),
//       headers: {
//         "Content-Type": "application/json",
//       },
//     );
//
//     print("GET PLANS STATUS: ${response.statusCode}");
//     print("GET PLANS BODY: ${response.body}");
//
//     if (response.statusCode != 200) {
//       throw Exception(
//         "Failed to load plans: status=${response.statusCode}, body=${response.body}",
//       );
//     }
//
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
//   }
//
//   static Future<SubscriptionStatusModel> getStatus() async {
//     final token = await TokenService.getToken();
//
//     if (token == null || token.isEmpty) {
//       throw Exception("Token is missing");
//     }
//
//     final response = await http.get(
//       Uri.parse("$baseUrl/subscriptions/status"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     print("GET STATUS CODE: ${response.statusCode}");
//     print("GET STATUS BODY: ${response.body}");
//
//     if (response.statusCode != 200) {
//       throw Exception(
//         "Failed to load subscription status: status=${response.statusCode}, body=${response.body}",
//       );
//     }
//
//     return SubscriptionStatusModel.fromJson(jsonDecode(response.body));
//   }
//
//   static Future<bool> cancelSubscription() async {
//     final token = await TokenService.getToken();
//
//     if (token == null || token.isEmpty) {
//       throw Exception("Token is missing");
//     }
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/subscriptions/cancel"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     print("CANCEL STATUS: ${response.statusCode}");
//     print("CANCEL BODY: ${response.body}");
//
//     return response.statusCode == 200;
//   }
//
//   static Future<CreatePaymentResponseModel> createPayment({
//     required String plan,
//     String gateway = "PAYPAL",
//   }) async {
//     final token = await TokenService.getToken();
//
//     if (token == null || token.isEmpty) {
//       throw Exception("Token is missing");
//     }
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/payments/create"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({
//         "plan": plan,
//         "gateway": gateway,
//       }),
//     );
//
//     print("CREATE PAYMENT STATUS: ${response.statusCode}");
//     print("CREATE PAYMENT BODY: ${response.body}");
//
//     if (response.statusCode != 200) {
//       throw Exception(
//         "Failed to create payment: status=${response.statusCode}, body=${response.body}",
//       );
//     }
//
//     return CreatePaymentResponseModel.fromJson(jsonDecode(response.body));
//   }
//
//   static Future<List<dynamic>> getPaymentHistory() async {
//     final token = await TokenService.getToken();
//
//     if (token == null || token.isEmpty) {
//       throw Exception("Token is missing");
//     }
//
//     final response = await http.get(
//       Uri.parse("$baseUrl/payments/history"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     print("PAYMENT HISTORY STATUS: ${response.statusCode}");
//     print("PAYMENT HISTORY BODY: ${response.body}");
//
//     if (response.statusCode != 200) {
//       throw Exception(
//         "Failed to load payment history: status=${response.statusCode}, body=${response.body}",
//       );
//     }
//
//     return jsonDecode(response.body);
//   }
// }






import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language_learning/models/subscription_models.dart';
import 'package:language_learning/services/token_service.dart';
import '../config/app_config.dart';

class SubscriptionApiService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static Future<Map<String, String>> _authHeaders() async {
    final token = await TokenService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token is missing");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<SubscriptionPlanModel>> getPlans() async {
    final response = await http.get(
      Uri.parse("$baseUrl/subscription-plans"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("GET PLANS STATUS: ${response.statusCode}");
    print("GET PLANS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load plans: status=${response.statusCode}, body=${response.body}",
      );
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((e) => SubscriptionPlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<SubscriptionStatusModel> getStatus() async {
    final response = await http.get(
      Uri.parse("$baseUrl/subscriptions/status"),
      headers: await _authHeaders(),
    );

    print("GET STATUS STATUS: ${response.statusCode}");
    print("GET STATUS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load subscription status: status=${response.statusCode}, body=${response.body}",
      );
    }

    return SubscriptionStatusModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  static Future<bool> cancelSubscription() async {
    final response = await http.post(
      Uri.parse("$baseUrl/subscriptions/cancel"),
      headers: await _authHeaders(),
    );

    print("CANCEL STATUS: ${response.statusCode}");
    print("CANCEL BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to cancel subscription: status=${response.statusCode}, body=${response.body}",
      );
    }

    return true;
  }

  static Future<CreatePaymentResponseModel> createPayment({
    required String plan,
    String gateway = "PAYPAL",
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/payments/create"),
      headers: await _authHeaders(),
      body: jsonEncode({
        "plan": plan,
        "gateway": gateway,
      }),
    );

    print("CREATE PAYMENT STATUS: ${response.statusCode}");
    print("CREATE PAYMENT BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to create payment: status=${response.statusCode}, body=${response.body}",
      );
    }

    return CreatePaymentResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  static Future<bool> capturePayment(String orderId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/payments/capture?orderId=$orderId"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("CAPTURE STATUS: ${response.statusCode}");
    print("CAPTURE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to capture payment: status=${response.statusCode}, body=${response.body}",
      );
    }

    return true;
  }

  static Future<List<PaymentHistoryItemModel>> getPaymentHistory() async {
    final response = await http.get(
      Uri.parse("$baseUrl/payments/history"),
      headers: await _authHeaders(),
    );

    print("PAYMENT HISTORY STATUS: ${response.statusCode}");
    print("PAYMENT HISTORY BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load payment history: status=${response.statusCode}, body=${response.body}",
      );
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((e) => PaymentHistoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String? extractPaypalOrderIdFromApprovalUrl(String paymentUrl) {
    try {
      final uri = Uri.parse(paymentUrl);
      return uri.queryParameters['token'];
    } catch (_) {
      return null;
    }
  }
}