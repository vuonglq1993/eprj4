import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_service.dart';



class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final int price;
  final int durationDays;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> j) => SubscriptionPlan(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        description: j['description'] ?? '',
        price: j['price'] ?? 0,
        durationDays: j['durationDays'] ?? 30,
      );
}

class SubscriptionStatus {
  final String plan;
  final String status;
  final bool isPremium;
  final bool autoRenew;
  final int daysRemaining;
  final DateTime? endDate;

  SubscriptionStatus({
    required this.plan,
    required this.status,
    required this.isPremium,
    required this.autoRenew,
    required this.daysRemaining,
    this.endDate,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> j) => SubscriptionStatus(
        plan: j['plan'] ?? 'FREE',
        status: j['status'] ?? 'ACTIVE',
        isPremium: j['isPremium'] == true,
        autoRenew: j['autoRenew'] == true,
        daysRemaining: (j['daysRemaining'] as num?)?.toInt() ?? 0,
        endDate: j['endDate'] != null ? DateTime.tryParse(j['endDate']) : null,
      );
}

class CreatePaymentResult {
  final String transactionId;
  final String gatewayRef; // PayPal orderId hoặc VNPay txnRef
  final String paymentUrl;
  final String gateway;
  final double amount;
  final String currency;
  final String plan;

  CreatePaymentResult({
    required this.transactionId,
    required this.gatewayRef,
    required this.paymentUrl,
    required this.gateway,
    required this.amount,
    required this.currency,
    required this.plan,
  });

  factory CreatePaymentResult.fromJson(Map<String, dynamic> j) => CreatePaymentResult(
        transactionId: j['transactionId'] ?? '',
        gatewayRef: j['gatewayRef'] ?? '',
        paymentUrl: j['paymentUrl'] ?? '',
        gateway: j['gateway'] ?? '',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] ?? 'VND',
        plan: j['plan'] ?? '',
      );
}

class PaymentHistoryItem {
  final String id;
  final String gateway;
  final double amount;
  final String currency;
  final String plan;
  final String status;
  final String? gatewayRef;
  final DateTime? createdAt;
  final DateTime? paidAt;

  PaymentHistoryItem({
    required this.id,
    required this.gateway,
    required this.amount,
    required this.currency,
    required this.plan,
    required this.status,
    this.gatewayRef,
    this.createdAt,
    this.paidAt,
  });

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> j) => PaymentHistoryItem(
        id: j['id']?.toString() ?? '',
        gateway: j['gateway'] ?? '',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        currency: j['currency'] ?? 'VND',
        plan: j['plan'] ?? '',
        status: j['status'] ?? '',
        gatewayRef: j['gatewayRef'],
        createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
        paidAt: j['paidAt'] != null ? DateTime.tryParse(j['paidAt']) : null,
      );
}

class PaymentService {
  static String get _base => AppConfig.baseUrl;

  static Future<Map<String, String>> _authHeaders() async {
    final token = await TokenService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<bool> waitForPaymentSuccess(String transactionId) async {
    for (int i = 0; i < 15; i++) {
      try {
        final status = await pollStatus(transactionId);

        if (status == 'SUCCESS') {
          return true;
        }

        if (status == 'FAILED') {
          return false;
        }
      } catch (_) {}

      await Future.delayed(const Duration(seconds: 1));
    }

    return false;
  }

  static Future<List<SubscriptionPlan>> getPlans() async {
    final res = await http.get(Uri.parse('$_base/subscription-plans'));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => SubscriptionPlan.fromJson(e)).toList();
    }
    throw Exception('Failed to load plans');
  }

  static Future<SubscriptionStatus> getStatus() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$_base/subscriptions/status'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return SubscriptionStatus.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to load subscription status');
  }

  static Future<CreatePaymentResult> createPayment({
    required String plan,   // MONTHLY | THREE_MONTHS | YEARLY
    required String gateway, // VNPAY | PAYPAL
  }) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$_base/payments/create'),
      headers: headers,
      body: jsonEncode({'plan': plan, 'gateway': gateway}),
    );
    if (res.statusCode == 200) {
      return CreatePaymentResult.fromJson(jsonDecode(res.body));
    }
    final msg = jsonDecode(res.body)['message'] ?? 'Payment creation failed';
    throw Exception(msg);
  }

  static Future<void> capturePayPal(String orderId) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$_base/payments/capture?orderId=$orderId'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      final msg = jsonDecode(res.body)['message'] ?? 'PayPal capture failed';
      throw Exception(msg);
    }
  }

  static Future<String> pollStatus(String transactionId) async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$_base/payments/status/$transactionId'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['status'] as String;
    }
    throw Exception('Failed to get status');
  }

  static Future<List<PaymentHistoryItem>> getHistory() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$_base/payments/history'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => PaymentHistoryItem.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> cancelAutoRenew() async {
    final headers = await _authHeaders();
    await http.post(
      Uri.parse('$_base/subscriptions/cancel'),
      headers: headers,
    );
  }
}
