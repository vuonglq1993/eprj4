import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import '../../core/theme.dart';
import '../../services/payment_service.dart';
import 'invoice_screen.dart';

class PaymentScreen extends StatefulWidget {
  final SubscriptionPlan plan;
  const PaymentScreen({super.key, required this.plan});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedGateway = 'VNPAY';
  bool _processing = false; // gọi API tạo payment
  bool _waiting = false;    // đã mở browser, đang chờ kết quả
  StreamSubscription? _deepLinkSub;
  Timer? _pollTimer;
  String? _pendingTxId; // kept for future use (e.g. cancel)

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _listenDeepLinks() {
    final appLinks = AppLinks();
    _deepLinkSub = appLinks.uriLinkStream.listen((uri) async {
      final path = uri.path;

      if (path.contains('/payment/paypal/success')) {
        final token = uri.queryParameters['token'];
        if (token != null && mounted) _onPayPalReturn(token);
      } else if (path.contains('/payment/vnpay')) {
        final status = uri.queryParameters['status'];
        if (mounted) _onVNPayReturn(status == 'success');
      }
    });
  }

  Future<void> _pay() async {
    setState(() => _processing = true);
    try {
      final result = await PaymentService.createPayment(
        plan: widget.plan.name,
        gateway: _selectedGateway,
      );

      _pendingTxId = result.transactionId;
      _listenDeepLinks();

      final uri = Uri.parse(result.paymentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Không thể mở trang thanh toán');
      }

      // Sau khi browser mở, chuyển sang trạng thái "đang chờ kết quả"
      if (mounted) setState(() { _processing = false; _waiting = true; });

      if (_selectedGateway == 'VNPAY') {
        _startVNPayPolling(result.transactionId);
      }
    } catch (e) {
      if (mounted) {
        setState(() { _processing = false; _waiting = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _startVNPayPolling(String txId) {
    int attempts = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (t) async {
      attempts++;
      if (attempts > 45 || !mounted) { t.cancel(); return; } // 3 min timeout
      try {
        final status = await PaymentService.pollStatus(txId);
        if (status == 'SUCCESS') {
          t.cancel();
          if (mounted) _onVNPayReturn(true);
        } else if (status == 'FAILED' || status == 'CANCELLED') {
          t.cancel();
          if (mounted) _onVNPayReturn(false);
        }
      } catch (_) {}
    });
  }

  Future<void> _onPayPalReturn(String orderId) async {
    _deepLinkSub?.cancel();
    setState(() { _processing = true; _waiting = false; });
    try {
      await PaymentService.capturePayPal(orderId);
      if (mounted) _goInvoice(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture thất bại: $e'), backgroundColor: AppColors.error),
        );
        setState(() => _processing = false);
      }
    }
  }

  void _onVNPayReturn(bool success) {
    _deepLinkSub?.cancel();
    _pollTimer?.cancel();
    if (success) {
      _goInvoice(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán thất bại hoặc bị hủy'), backgroundColor: AppColors.error),
      );
      if (mounted) setState(() { _processing = false; _waiting = false; });
    }
  }

  void _goInvoice(bool success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(plan: widget.plan, gateway: _selectedGateway),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final isYearly = plan.name == 'YEARLY';
    final amountDisplay = '${_formatPrice(plan.price)}đ';
    final discount = plan.price; // free trial = full discount

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(context),
                  const SizedBox(height: 16),
                  _orderCard(plan, amountDisplay, discount, isYearly),
                  const SizedBox(height: 20),
                  _gatewaySection(),
                  const SizedBox(height: 28),
                  _payButton(),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Bảo mật theo tiêu chuẩn PCI-DSS\nHủy bất kỳ lúc nào trong Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColors.textHint),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_processing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Đang tạo đơn hàng...', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),
          if (_waiting)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 20),
                      const Text('Đang chờ kết quả thanh toán',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      const Text('Hoàn tất thanh toán trên trình duyệt\nrồi quay lại app',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => setState(() => _waiting = false),
                        child: const Text('Hủy chờ',
                            style: TextStyle(color: AppColors.error, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: _processing ? null : () => Navigator.pop(context),
          ),
          const Text('Thanh toán',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(width: 8),
          const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.success),
          const Text(' Bảo mật', style: TextStyle(fontSize: 13, color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _orderCard(SubscriptionPlan plan, String amount, int discount, bool isYearly) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ĐƠN HÀNG',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isYearly ? 'Pro Yearly' : 'Pro Monthly',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dùng thử 7 ngày', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('-${_formatPrice(discount)}đ',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Thanh toán hôm nay',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('0đ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Tự động gia hạn ${_formatPrice(plan.price)}đ/${isYearly ? "năm" : "tháng"} sau 7 ngày',
            style: const TextStyle(fontSize: 11, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _gatewaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VÍ & NGÂN HÀNG NỘI ĐỊA',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                color: AppColors.textSecondary, letterSpacing: 0.8)),
        const SizedBox(height: 12),
        Row(
          children: [
            _gatewayTile('VNPAY', 'VN', const Color(0xFF003087), Colors.white, 'VNPay'),
            const SizedBox(width: 12),
            _gatewayTile('PAYPAL', 'PP', const Color(0xFF009CDE), Colors.white, 'PayPal'),
          ],
        ),
      ],
    );
  }

  Widget _gatewayTile(String id, String abbr, Color bg, Color fg, String label) {
    final selected = _selectedGateway == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGateway = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(abbr, style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: _processing ? null : _pay,
        child: Text(
          _processing ? 'Đang xử lý...' : 'Bắt đầu dùng thử miễn phí',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000000) return '${(price / 1000).round()}k';
    if (price >= 1000) return '${price ~/ 1000}.${((price % 1000) ~/ 100).toString().padLeft(1, '0')}00'.replaceAll(RegExp(r'\.?0+$'), '');
    return price.toString();
  }
}
