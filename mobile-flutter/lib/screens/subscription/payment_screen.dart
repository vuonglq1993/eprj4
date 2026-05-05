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

class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver {
  String _selectedGateway = 'VNPAY';
  bool _processing = false;
  bool _waiting = false;
  StreamSubscription? _deepLinkSub;
  Timer? _pollTimer;
  String? _pendingTxId;
  String? _pendingPayPalOrderId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupDeepLinkListener(); // listen 1 lần duy nhất
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkSub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  // Listener đặt sẵn từ đầu — không cancel/recreate để tránh buffer replay
  void _setupDeepLinkListener() {
    _deepLinkSub = AppLinks().uriLinkStream.listen((uri) {
      if (!mounted) return;
      final path = uri.path;
      if (path.contains('/payment/paypal/success')) {
        final token = uri.queryParameters['token'];
        if (token != null) _handlePayPalSuccess(token);
      } else if (path.contains('/payment/paypal/cancel')) {
        _handlePayPalCancel();
      } else if (path.contains('/payment/vnpay')) {
        _handleVNPayReturn(uri.queryParameters['status'] == 'success');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Không cần xử lý gì — backend tự capture khi poll phát hiện APPROVED
  }

  void _handlePayPalSuccess(String orderId) {
    // Poll sẽ tự detect SUCCESS sau khi backend capture — không cần làm gì thêm
    // Nhưng nếu deep link đến, tăng tốc poll ngay
    if (_waiting) _startPolling(_pendingTxId!);
  }

  void _handlePayPalCancel() {
    if (!_waiting) return;
    _onPaymentFailed();
  }

  void _handleVNPayReturn(bool success) {
    if (!_waiting) return;
    if (success) {
      _onPaymentSuccess();
    } else {
      _onPaymentFailed();
    }
  }

  Future<void> _pay() async {
    setState(() { _processing = true; });
    try {
      final result = await PaymentService.createPayment(
        plan: widget.plan.name,
        gateway: _selectedGateway,
      );
      _pendingTxId = result.transactionId;
      _pendingPayPalOrderId = _selectedGateway == 'PAYPAL' ? result.gatewayRef : null;

      await launchUrl(Uri.parse(result.paymentUrl), mode: LaunchMode.externalApplication);

      if (mounted) setState(() { _processing = false; _waiting = true; });

      // Cả VNPay và PayPal đều poll — backend tự capture PayPal khi APPROVED
      _startPolling(result.transactionId);
    } catch (e) {
      if (mounted) {
        setState(() { _processing = false; _waiting = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _startPolling(String txId) {
    _pollTimer?.cancel();
    int attempts = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (t) async {
      attempts++;
      if (attempts > 60 || !mounted) { t.cancel(); return; } // 3 min
      try {
        final status = await PaymentService.pollStatus(txId);
        if (status == 'SUCCESS') {
          t.cancel();
          if (mounted) _onPaymentSuccess();
        } else if (status == 'FAILED' || status == 'CANCELLED') {
          t.cancel();
          if (mounted) _onPaymentFailed();
        }
      } catch (_) {}
    });
  }

  void _onPaymentSuccess() {
    _pollTimer?.cancel();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thanh toán ${_selectedGateway} thành công!'),
        backgroundColor: AppColors.success,
      ),
    );
    _goInvoice();
  }

  void _onPaymentFailed() {
    _pollTimer?.cancel();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanh toán thất bại hoặc bị hủy'),
          backgroundColor: AppColors.error),
    );
    setState(() { _processing = false; _waiting = false; });
  }

  void _goInvoice() {
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
                  _orderCard(plan, isYearly),
                  const SizedBox(height: 20),
                  _gatewaySection(),
                  const SizedBox(height: 28),
                  _payButton(),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Thanh toán an toàn • Hủy bất kỳ lúc nào',
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
                    Text('Đang xử lý...', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                      Text(
                        _selectedGateway == 'PAYPAL'
                            ? 'Hoàn tất thanh toán trên PayPal\nrồi quay lại app'
                            : 'Hoàn tất thanh toán trên trình duyệt\nrồi quay lại app',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () { _pollTimer?.cancel(); setState(() { _waiting = false; }); },
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

  Widget _orderCard(SubscriptionPlan plan, bool isYearly) {
    final priceDisplay = '${_formatPrice(plan.price)}đ';
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
              Text(priceDisplay,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isYearly ? 'Thanh toán ${_formatPrice(plan.price)}đ / năm'
                     : 'Thanh toán ${_formatPrice(plan.price)}đ / tháng',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng thanh toán',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(priceDisplay,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Tự động gia hạn ${_formatPrice(plan.price)}đ/${isYearly ? "năm" : "tháng"}. Hủy bất kỳ lúc nào.',
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
        const Text('PHƯƠNG THỨC THANH TOÁN',
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
        onPressed: (_processing || _waiting) ? null : _pay,
        child: Text(
          _processing ? 'Đang xử lý...' : 'Thanh toán ngay',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000000) return '${(price / 1000).round()}k';
    if (price >= 1000) return '${price ~/ 1000}.${((price % 1000) ~/ 100).toString().padLeft(1, '0')}00'
        .replaceAll(RegExp(r'\.?0+$'), '');
    return price.toString();
  }
}
