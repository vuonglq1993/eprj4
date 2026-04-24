import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../services/payment_service.dart';
import '../../l10n/l10n_ext.dart';

class InvoiceScreen extends StatelessWidget {
  final SubscriptionPlan plan;
  final String gateway;

  const InvoiceScreen({super.key, required this.plan, required this.gateway});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nextBilling = now.add(Duration(days: plan.durationDays + 7)); // +7 ngày thử
    final invoiceNo = '#INV-${DateFormat('yyyy').format(now)}-${now.millisecondsSinceEpoch % 10000}';
    final dateStr = DateFormat('dd/MM/yyyy').format(now);
    final nextStr = DateFormat('dd/MM/yyyy').format(nextBilling);
    final isYearly = plan.name == 'YEARLY';
    final baseAmount = (plan.price / 1.1).round();
    final vat = plan.price - baseAmount;
    final gwLabel = gateway == 'PAYPAL' ? 'PayPal' : 'VNPay';

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
                children: [
                  _topBar(context),
                  const SizedBox(height: 16),
                  _successHero(context),
                  const SizedBox(height: 20),
                  _invoiceCard(invoiceNo, dateStr, gwLabel, baseAmount, vat, isYearly),
                  const SizedBox(height: 16),
                  _renewalCard(nextStr, isYearly),
                  const SizedBox(height: 24),
                  _doneButton(context),
                ],
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
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _successHero(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.35), blurRadius: 24, spreadRadius: 4)],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 16),
        Text(context.l10n.invoiceTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Text(context.l10n.welcomeToPro,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _invoiceCard(String invNo, String date, String gw, int base, int vat, bool isYearly) {
    return Container(
      width: double.infinity,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hóa đơn VAT',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: const Text('Đã thanh toán',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _row('Mã hóa đơn', invNo),
          _row('Ngày', date),
          _row('Gói', isYearly ? 'Pro Yearly' : 'Pro Monthly'),
          _row('Phương thức', gw),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.border),
          ),
          _row('Tiền hàng', '${_fmt(base)}đ'),
          _row('VAT 10%', '${_fmt(vat)}đ'),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('${_fmt(base + vat)}đ',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renewalCard(String nextDate, bool isYearly) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gia hạn tiếp theo',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warning)),
          const SizedBox(height: 6),
          Text(
            '$nextDate · ${_fmt(isYearly ? 1390000 : 199000)}đ · Tự động',
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text('Hủy bất kỳ lúc nào trong Settings',
              style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _doneButton(BuildContext context) {
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
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        child: const Text('Bắt đầu học ngay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
