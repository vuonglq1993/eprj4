// class SubscriptionPlanModel {
//   final String id;
//   final String name;
//   final String? description;
//   final int price;
//   final int durationDays;
//   final bool isActive;
//
//   SubscriptionPlanModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.durationDays,
//     required this.isActive,
//   });
//
//   factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
//     return SubscriptionPlanModel(
//       id: json['id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       description: json['description']?.toString(),
//       price: json['price'] is int
//           ? json['price']
//           : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
//       durationDays: json['durationDays'] is int
//           ? json['durationDays']
//           : int.tryParse(json['durationDays']?.toString() ?? '0') ?? 0,
//       isActive: json['isActive'] == true,
//     );
//   }
// }
//
// class SubscriptionStatusModel {
//   final String plan;
//   final String status;
//   final String? startDate;
//   final String? endDate;
//   final bool autoRenew;
//   final bool isPremium;
//   final int daysRemaining;
//
//   SubscriptionStatusModel({
//     required this.plan,
//     required this.status,
//     required this.startDate,
//     required this.endDate,
//     required this.autoRenew,
//     required this.isPremium,
//     required this.daysRemaining,
//   });
//
//   factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
//     return SubscriptionStatusModel(
//       plan: json['plan']?.toString() ?? 'FREE',
//       status: json['status']?.toString() ?? 'ACTIVE',
//       startDate: json['startDate']?.toString(),
//       endDate: json['endDate']?.toString(),
//       autoRenew: json['autoRenew'] == true,
//       isPremium: json['isPremium'] == true,
//       daysRemaining: json['daysRemaining'] is int
//           ? json['daysRemaining']
//           : int.tryParse(json['daysRemaining']?.toString() ?? '0') ?? 0,
//     );
//   }
// }
//
// class CreatePaymentResponseModel {
//   final String transactionId;
//   final String paymentUrl;
//   final String gateway;
//   final num amount;
//   final String currency;
//   final String plan;
//   final String? expiredAt;
//
//   CreatePaymentResponseModel({
//     required this.transactionId,
//     required this.paymentUrl,
//     required this.gateway,
//     required this.amount,
//     required this.currency,
//     required this.plan,
//     required this.expiredAt,
//   });
//
//   factory CreatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
//     return CreatePaymentResponseModel(
//       transactionId: json['transactionId']?.toString() ?? '',
//       paymentUrl: json['paymentUrl']?.toString() ?? '',
//       gateway: json['gateway']?.toString() ?? '',
//       amount: json['amount'] ?? 0,
//       currency: json['currency']?.toString() ?? '',
//       plan: json['plan']?.toString() ?? '',
//       expiredAt: json['expiredAt']?.toString(),
//     );
//   }
// }




class SubscriptionPlanModel {
  final String id;
  final String name;
  final String? description;
  final int price;
  final int durationDays;
  final bool isActive;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.isActive,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      durationDays: json['durationDays'] is int
          ? json['durationDays']
          : int.tryParse(json['durationDays']?.toString() ?? '0') ?? 0,
      isActive: json['isActive'] == true,
    );
  }
}

class SubscriptionStatusModel {
  final String plan;
  final String status;
  final String? startDate;
  final String? endDate;
  final bool autoRenew;
  final bool isPremium;
  final int daysRemaining;

  SubscriptionStatusModel({
    required this.plan,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.autoRenew,
    required this.isPremium,
    required this.daysRemaining,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusModel(
      plan: json['plan']?.toString() ?? 'FREE',
      status: json['status']?.toString() ?? 'ACTIVE',
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      autoRenew: json['autoRenew'] == true,
      isPremium: json['isPremium'] == true,
      daysRemaining: json['daysRemaining'] is int
          ? json['daysRemaining']
          : int.tryParse(json['daysRemaining']?.toString() ?? '0') ?? 0,
    );
  }
}

class CreatePaymentResponseModel {
  final String transactionId;
  final String paymentUrl;
  final String gateway;
  final num amount;
  final String currency;
  final String plan;
  final String? expiredAt;

  CreatePaymentResponseModel({
    required this.transactionId,
    required this.paymentUrl,
    required this.gateway,
    required this.amount,
    required this.currency,
    required this.plan,
    required this.expiredAt,
  });

  factory CreatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePaymentResponseModel(
      transactionId: json['transactionId']?.toString() ?? '',
      paymentUrl: json['paymentUrl']?.toString() ?? '',
      gateway: json['gateway']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency']?.toString() ?? '',
      plan: json['plan']?.toString() ?? '',
      expiredAt: json['expiredAt']?.toString(),
    );
  }
}

class PaymentHistoryItemModel {
  final String id;
  final String gateway;
  final String plan;
  final String status;
  final String currency;
  final num amount;
  final String? gatewayRef;
  final String? createdAt;
  final String? paidAt;

  PaymentHistoryItemModel({
    required this.id,
    required this.gateway,
    required this.plan,
    required this.status,
    required this.currency,
    required this.amount,
    required this.gatewayRef,
    required this.createdAt,
    required this.paidAt,
  });

  factory PaymentHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryItemModel(
      id: json['id']?.toString() ?? '',
      gateway: json['gateway']?.toString() ?? '',
      plan: json['plan']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      gatewayRef: json['gatewayRef']?.toString(),
      createdAt: json['createdAt']?.toString(),
      paidAt: json['paidAt']?.toString(),
    );
  }
}