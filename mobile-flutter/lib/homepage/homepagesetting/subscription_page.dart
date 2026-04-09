// import 'package:flutter/material.dart';
//
// class SubscriptionPage extends StatelessWidget {
//   const SubscriptionPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Subscription",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: width * 0.06,
//             vertical: 20,
//           ),
//           child: Column(
//             children: [
//
//               const SizedBox(height: 10),
//
//               /// ICON
//               const Icon(
//                 Icons.workspace_premium,
//                 size: 70,
//                 color: Colors.amber,
//               ),
//
//               const SizedBox(height: 20),
//
//               /// TITLE
//               Text(
//                 "To continue, please select a subscription",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: theme.textTheme.titleLarge?.color,
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               /// FEATURE 1
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.blue),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       "There are hundreds of lessons from beginner to advanced",
//                       style: TextStyle(
//                         color: theme.textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               /// FEATURE 2
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.blue),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       "The study of culture, travel, and business through special courses",
//                       style: TextStyle(
//                         color: theme.textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//
//               /// MONTHLY PLAN
//               _planCard(
//                 context: context,
//                 title: "Monthly",
//                 price: "\$12.12 / Month",
//                 desc: "then \$12.12 per month cancel anytime",
//                 color: const Color(0xFF5BA78C),
//                 textColor: Colors.white,
//               ),
//
//               const SizedBox(height: 20),
//
//               /// ANNUAL PLAN
//               _planCard(
//                 context: context,
//                 title: "Annually",
//                 price: "\$124.12 / Month",
//                 desc: "then \$124.12 per month cancel anytime",
//                 color: theme.cardColor,
//                 textColor: theme.textTheme.bodyLarge?.color ?? Colors.black,
//               ),
//
//               const SizedBox(height: 40),
//
//               /// BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF5C7CFA),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//
//                   onPressed: () {},
//
//                   child: const Text(
//                     "Update Plan",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// CARD PLAN
//   Widget _planCard({
//     required BuildContext context,
//     required String title,
//     required String price,
//     required String desc,
//     required Color color,
//     required Color textColor,
//   }) {
//
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(18),
//       ),
//
//       child: Row(
//         children: [
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: textColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 const SizedBox(height: 5),
//
//                 Text(
//                   price,
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 Text(
//                   desc,
//                   style: TextStyle(
//                     color: textColor.withOpacity(0.7),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 6,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.orange,
//               borderRadius: BorderRadius.circular(10),
//             ),
//
//             child: const Text(
//               "1 week free trial",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }







//bản mới api
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../models/subscription_models.dart';
// import '../../services/subscription_api_service.dart';
//
// class SubscriptionPage extends StatefulWidget {
//   const SubscriptionPage({super.key});
//
//   @override
//   State<SubscriptionPage> createState() => _SubscriptionPageState();
// }
//
// class _SubscriptionPageState extends State<SubscriptionPage> {
//   bool _isLoading = true;
//   bool _isProcessing = false;
//   String? _error;
//
//   List<SubscriptionPlanModel> _plans = [];
//   SubscriptionStatusModel? _status;
//   String? _selectedPlanName;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     try {
//       final plans = await SubscriptionApiService.getPlans();
//
//       SubscriptionStatusModel? status;
//       try {
//         status = await SubscriptionApiService.getStatus();
//       } catch (e) {
//         debugPrint("Load status failed: $e");
//       }
//
//       String? selectedPlanName;
//       if (status != null) {
//         final current = plans.where(
//               (p) => p.name.toUpperCase() == status!.plan.toUpperCase(),
//         );
//         if (current.isNotEmpty) {
//           selectedPlanName = current.first.name;
//         }
//       }
//
//       setState(() {
//         _plans = plans;
//         _status = status;
//         _selectedPlanName = selectedPlanName;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   Future<void> _handleCreatePayment() async {
//     if (_selectedPlanName == null || _selectedPlanName!.isEmpty) {
//       _showSnackBar("Vui lòng chọn gói");
//       return;
//     }
//
//     if (_selectedPlanName!.toUpperCase() == "FREE") {
//       _showSnackBar("Gói FREE không cần thanh toán");
//       return;
//     }
//
//     setState(() {
//       _isProcessing = true;
//     });
//
//     try {
//       final result = await SubscriptionApiService.createPayment(
//         plan: _selectedPlanName!.toUpperCase(),
//         gateway: "PAYPAL",
//       );
//
//       final uri = Uri.parse(result.paymentUrl);
//
//       if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//         throw Exception("Không mở được link thanh toán");
//       }
//
//       _showSnackBar("Đã tạo thanh toán, vui lòng hoàn tất trên PayPal");
//     } catch (e) {
//       _showSnackBar("Lỗi thanh toán: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });
//       }
//     }
//   }
//
//   Future<void> _handleCancel() async {
//     setState(() {
//       _isProcessing = true;
//     });
//
//     try {
//       final ok = await SubscriptionApiService.cancelSubscription();
//       if (ok) {
//         _showSnackBar("Huỷ auto-renew thành công");
//         await _loadData();
//       } else {
//         _showSnackBar("Huỷ auto-renew thất bại");
//       }
//     } catch (e) {
//       _showSnackBar("Lỗi: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });
//       }
//     }
//   }
//
//   void _showSnackBar(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(text)),
//     );
//   }
//
//   String _formatPrice(int price) {
//     return "$price VNĐ";
//   }
//
//   String _planDisplayName(String name) {
//     switch (name.toUpperCase()) {
//       case "MONTHLY":
//         return "Monthly";
//       case "YEARLY":
//         return "Yearly";
//       case "FREE":
//         return "Free";
//       default:
//         return name;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Subscription",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//           ? _buildErrorView()
//           : RefreshIndicator(
//         onRefresh: _loadData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: width * 0.06,
//               vertical: 20,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 const Center(
//                   child: Icon(
//                     Icons.workspace_premium,
//                     size: 70,
//                     color: Colors.amber,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     "To continue, please select a subscription",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: theme.textTheme.titleLarge?.color,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 if (_status != null) _buildStatusCard(theme),
//
//                 const SizedBox(height: 20),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.check_circle, color: Colors.blue),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         "There are hundreds of lessons from beginner to advanced",
//                         style: TextStyle(
//                           color: theme.textTheme.bodyMedium?.color,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.check_circle, color: Colors.blue),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         "The study of culture, travel, and business through special courses",
//                         style: TextStyle(
//                           color: theme.textTheme.bodyMedium?.color,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//
//                 ..._plans.map((plan) {
//                   final isSelected =
//                       _selectedPlanName?.toUpperCase() ==
//                           plan.name.toUpperCase();
//
//                   final isCurrent =
//                       _status?.plan.toUpperCase() ==
//                           plan.name.toUpperCase();
//
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: _planCard(
//                       context: context,
//                       title: _planDisplayName(plan.name),
//                       price: _formatPrice(plan.price),
//                       desc: plan.description ??
//                           "${plan.durationDays} days",
//                       color: isSelected
//                           ? const Color(0xFF5BA78C)
//                           : theme.cardColor,
//                       textColor: isSelected
//                           ? Colors.white
//                           : (theme.textTheme.bodyLarge?.color ??
//                           Colors.black),
//                       isSelected: isSelected,
//                       isCurrent: isCurrent,
//                       onTap: () {
//                         setState(() {
//                           _selectedPlanName = plan.name;
//                         });
//                       },
//                     ),
//                   );
//                 }),
//
//                 const SizedBox(height: 20),
//
//                 SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF5C7CFA),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: _isProcessing ? null : _handleCreatePayment,
//                     child: _isProcessing
//                         ? const SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                         : const Text(
//                       "Update Plan",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 if (_status != null && _status!.isPremium)
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: OutlinedButton(
//                       onPressed: _isProcessing ? null : _handleCancel,
//                       child: const Text("Cancel Auto Renew"),
//                     ),
//                   ),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusCard(ThemeData theme) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Current Subscription",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           _row("Plan", _status?.plan ?? "-"),
//           _row("Status", _status?.status ?? "-"),
//           _row("Premium", _status?.isPremium == true ? "Yes" : "No"),
//           _row("Auto renew", _status?.autoRenew == true ? "On" : "Off"),
//           _row("Days remaining", "${_status?.daysRemaining ?? 0}"),
//         ],
//       ),
//     );
//   }
//
//   Widget _row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               "$title:",
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, color: Colors.red, size: 70),
//             const SizedBox(height: 16),
//             Text(
//               _error ?? "Unknown error",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loadData,
//               child: const Text("Retry"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _planCard({
//     required BuildContext context,
//     required String title,
//     required String price,
//     required String desc,
//     required Color color,
//     required Color textColor,
//     required bool isSelected,
//     required bool isCurrent,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: isSelected ? Colors.transparent : Colors.grey.shade300,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
//               color: isSelected ? Colors.white : Colors.grey,
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           color: textColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       if (isCurrent) ...[
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Text(
//                             "Current",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 11,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     price,
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     desc,
//                     style: TextStyle(
//                       color: textColor.withOpacity(0.75),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/subscription_models.dart';
import 'payment_history_page.dart';
import '../../services/subscription_api_service.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _error;

  List<SubscriptionPlanModel> _plans = [];
  SubscriptionStatusModel? _status;
  String? _selectedPlanName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final plans = await SubscriptionApiService.getPlans();

      SubscriptionStatusModel? status;
      try {
        status = await SubscriptionApiService.getStatus();
      } catch (e) {
        debugPrint("GET STATUS ERROR: $e");
      }

      String? selectedPlanName;
      if (status != null) {
        for (final plan in plans) {
          if (plan.name.toUpperCase() == status.plan.toUpperCase()) {
            selectedPlanName = plan.name;
            break;
          }
        }
      }

      setState(() {
        _plans = plans;
        _status = status;
        _selectedPlanName = selectedPlanName;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSubscribe() async {
    if (_selectedPlanName == null || _selectedPlanName!.isEmpty) {
      _showSnackBar("Vui lòng chọn gói");
      return;
    }

    if (_selectedPlanName!.toUpperCase() == "FREE") {
      _showSnackBar("Gói FREE không cần thanh toán");
      return;
    }

    if (_status != null &&
        _status!.isPremium &&
        _status!.plan.toUpperCase() == _selectedPlanName!.toUpperCase()) {
      _showSnackBar("Bạn đang dùng gói này rồi");
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final payment = await SubscriptionApiService.createPayment(
        plan: _selectedPlanName!.toUpperCase(),
        gateway: "PAYPAL",
      );

      final orderId = SubscriptionApiService
          .extractPaypalOrderIdFromApprovalUrl(payment.paymentUrl);

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Không lấy được orderId từ paymentUrl");
      }

      final opened = await launchUrl(
        Uri.parse(payment.paymentUrl),
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        throw Exception("Không mở được trang PayPal");
      }

      if (!mounted) return;

      final shouldCapture = await _showPaymentConfirmDialog();
      if (shouldCapture != true) return;

      final captured = await SubscriptionApiService.capturePayment(orderId);
      if (!captured) {
        throw Exception("Capture payment thất bại");
      }

      await _loadData();

      if (!mounted) return;
      _showSnackBar("Thanh toán thành công, gói đã được cập nhật");
    } catch (e) {
      _showSnackBar("Lỗi thanh toán: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<bool?> _showPaymentConfirmDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận thanh toán"),
          content: const Text(
            "Sau khi thanh toán xong trên PayPal, quay lại ứng dụng rồi bấm 'Tôi đã thanh toán' để hệ thống cập nhật gói.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Để sau"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Tôi đã thanh toán"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCancelAutoRenew() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await SubscriptionApiService.cancelSubscription();
      await _loadData();
      _showSnackBar("Đã huỷ auto-renew");
    } catch (e) {
      _showSnackBar("Lỗi huỷ subscription: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSnackBar(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String _formatPrice(int price) {
    return "$price VNĐ";
  }

  String _displayPlanName(String name) {
    switch (name.toUpperCase()) {
      case "FREE":
        return "Free";
      case "MONTHLY":
        return "Monthly";
      case "YEARLY":
        return "Yearly";
      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Subscription",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Icon(
                  Icons.workspace_premium,
                  size: 70,
                  color: Colors.amber,
                ),
                const SizedBox(height: 20),
                Text(
                  "To continue, please select a subscription",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),
                if (_status != null) _buildStatusCard(theme),
                const SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "There are hundreds of lessons from beginner to advanced",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "The study of culture, travel, and business through special courses",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ..._plans.map(
                      (plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _planCard(
                      context: context,
                      title: _displayPlanName(plan.name),
                      price: _formatPrice(plan.price),
                      desc: plan.description ?? "",
                      color: _selectedPlanName?.toUpperCase() ==
                          plan.name.toUpperCase()
                          ? const Color(0xFF5BA78C)
                          : theme.cardColor,
                      textColor: _selectedPlanName?.toUpperCase() ==
                          plan.name.toUpperCase()
                          ? Colors.white
                          : theme.textTheme.bodyLarge?.color ??
                          Colors.black,
                      isSelected: _selectedPlanName?.toUpperCase() ==
                          plan.name.toUpperCase(),
                      isCurrent: _status?.plan.toUpperCase() ==
                          plan.name.toUpperCase(),
                      onTap: () {
                        setState(() {
                          _selectedPlanName = plan.name;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C7CFA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isProcessing ? null : _handleSubscribe,
                    child: _isProcessing
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Subscribe Now",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_status != null && _status!.isPremium)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed:
                      _isProcessing ? null : _handleCancelAutoRenew,
                      child: const Text("Cancel Auto Renew"),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Subscription",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _statusRow("Plan", _status?.plan ?? "-"),
          _statusRow("Status", _status?.status ?? "-"),
          _statusRow("Premium", _status?.isPremium == true ? "Yes" : "No"),
          _statusRow("Auto renew", _status?.autoRenew == true ? "On" : "Off"),
          _statusRow("Days remaining", "${_status?.daysRemaining ?? 0}"),
        ],
      ),
    );
  }

  Widget _statusRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? "Unknown error",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard({
    required BuildContext context,
    required String title,
    required String price,
    required String desc,
    required Color color,
    required Color textColor,
    required bool isSelected,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Current",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: textColor.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}