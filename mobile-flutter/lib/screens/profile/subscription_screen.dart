import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../l10n/l10n_ext.dart';
import '../../core/app_widgets.dart';
import '../../services/payment_service.dart';
import '../subscription/plan_selection_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionStatus? _status;
  List<PaymentHistoryItem> _history = [];
  List<SubscriptionPlan> _plans = [];
  bool _loading = true;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      PaymentService.getStatus(),
      PaymentService.getHistory(),
      PaymentService.getPlans().catchError((_) => <SubscriptionPlan>[]),
    ]);
    if (mounted) {
      setState(() {
        _status = results[0] as SubscriptionStatus;
        _history = results[1] as List<PaymentHistoryItem>;
        _plans = results[2] as List<SubscriptionPlan>;
        _loading = false;
      });
    }
  }

  Future<void> _cancelAutoRenew() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(context.l10n.cancelAutoRenew, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(
            context.l10n.cancelAutoRenewDesc,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.keepPlan, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.cancelRenewal, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _cancelling = true);
    await PaymentService.cancelAutoRenew();
    await _load();
    if (mounted) setState(() => _cancelling = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 180,
              child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop))),
          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: _load,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topBar(),
                          const SizedBox(height: 16),
                          _currentPlanCard(),
                          const SizedBox(height: 16),
                          if (_status?.plan != 'YEARLY') _upgradeCard(),
                          if (_status?.plan != 'YEARLY') const SizedBox(height: 20),
                          _historySection(),
                          if (_status?.autoRenew == true) ...[
                            const SizedBox(height: 16),
                            _cancelButton(),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Text(context.l10n.subscription,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _currentPlanCard() {
    final s = _status;
    if (s == null) return const SizedBox.shrink();

    final planLabel = _planLabel(s.plan);
    final isActive = s.status == 'ACTIVE';
    final startStr = s.endDate != null
        ? DateFormat('dd/MM/yyyy').format(s.endDate!.subtract(Duration(days: _planDays(s.plan))))
        : '—';
    final endStr = s.endDate != null ? DateFormat('dd/MM/yyyy').format(s.endDate!) : '—';
    final lastTx = _history.where((h) => h.status == 'SUCCESS').firstOrNull;
    final gwLabel = lastTx?.gateway ?? '—';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primaryLight.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(context.l10n.currentPlan,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.success : AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isActive ? context.l10n.activeStatus : s.status,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(planLabel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 16),
          _infoRow(context.l10n.startDate, startStr),
          _infoRow(context.l10n.renewalDate, endStr),
          _infoRow(context.l10n.paymentMethod, gwLabel),
          if (s.autoRenew && s.endDate != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Tự động gia hạn · ${_planPrice(s.plan)}đ/${_planPeriod(s.plan)}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _upgradeCard() {
    return TappableScale(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanSelectionScreen())),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(context.l10n.upgradeToYearly,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.warning)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('-40%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Tiết kiệm ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                TextSpan(text: '1,000,000đ/năm',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                TextSpan(text: ' so với gói tháng', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            )),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const PlanSelectionScreen())),
                child: const Text('Chuyển sang Yearly',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historySection() {
    final successful = _history.where((h) => h.status == 'SUCCESS').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.paymentHistory.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                color: AppColors.textSecondary, letterSpacing: 0.8)),
        const SizedBox(height: 10),
        if (successful.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(Icons.receipt_long_outlined, size: 36, color: AppColors.textHint),
                const SizedBox(height: 8),
                Text(context.l10n.noPaymentHistory,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          )
        else
          ...successful.map((tx) => _historyItem(tx)),
      ],
    );
  }

  Widget _historyItem(PaymentHistoryItem tx) {
    final dateStr = tx.paidAt != null
        ? DateFormat('dd/MM/yyyy').format(tx.paidAt!)
        : (tx.createdAt != null ? DateFormat('dd/MM/yyyy').format(tx.createdAt!) : '—');
    final amountStr = tx.currency == 'USD'
        ? '\$${tx.amount.toStringAsFixed(2)}'
        : '${(tx.amount / 1000).round()}kđ';
    final planLabel = tx.plan.replaceAll('_', ' ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pro $planLabel',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(dateStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(amountStr,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Đã TT',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
          ),
        ],
      ),
    );
  }

  Widget _cancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.error),
          foregroundColor: AppColors.error,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: _cancelling ? null : _cancelAutoRenew,
        child: Text(
          _cancelling ? 'Đang xử lý...' : 'Hủy gia hạn tự động',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _planLabel(String plan) => switch (plan) {
        'MONTHLY' => 'Pro Monthly',
        'THREE_MONTHS' => 'Pro 3 Months',
        'YEARLY' => 'Pro Yearly',
        _ => 'Free',
      };

  String _planPrice(String plan) {
    final found = _plans.where((p) => p.name == plan).firstOrNull;
    if (found != null) {
      return NumberFormat('#,###', 'vi_VN').format(found.price);
    }
    return switch (plan) {
      'MONTHLY'      => '199,000',
      'THREE_MONTHS' => '479,000',
      'YEARLY'       => '1,390,000',
      _              => '0',
    };
  }

  String _planPeriod(String plan) => plan == 'YEARLY' ? 'năm' : 'tháng';

  int _planDays(String plan) => switch (plan) {
        'MONTHLY' => 30,
        'THREE_MONTHS' => 90,
        'YEARLY' => 365,
        _ => 0,
      };
}
