import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/payment_service.dart';
import 'payment_screen.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({super.key});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  List<SubscriptionPlan> _plans = [];
  SubscriptionStatus? _status;
  bool _loading = true;
  bool _yearly = false; // toggle hàng tháng / hàng năm

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        PaymentService.getPlans(),
        PaymentService.getStatus(),
      ]);
      if (mounted) {
        setState(() {
          _plans = results[0] as List<SubscriptionPlan>;
          _status = results[1] as SubscriptionStatus;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Giả sử plan name conventions: FREE, MONTHLY, THREE_MONTHS, YEARLY
  // Hiển thị MONTHLY khi toggle = false, YEARLY khi toggle = true
  List<SubscriptionPlan> get _filteredPlans {
    if (_yearly) {
      return _plans.where((p) => p.name == 'YEARLY').toList();
    }
    return _plans.where((p) => p.name != 'YEARLY').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.bgTop)),
          ),
          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Column(
                      children: [
                        _topBar(context),
                        const SizedBox(height: 8),
                        _toggle(),
                        const SizedBox(height: 20),
                        ..._buildPlanCards(),
                        const SizedBox(height: 16),
                        _disclaimer(),
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
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Text('Chọn gói', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _toggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn('Hàng tháng', !_yearly, () => setState(() => _yearly = false)),
          _toggleBtn('Hàng năm', _yearly, () => setState(() => _yearly = true), badge: '-40%'),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap, {String? badge}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: active ? AppGradients.primaryIcon : null,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.textSecondary,
            )),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlanCards() {
    // Always show FREE card first, then paid plans
    final freePlan = _plans.where((p) => p.name == 'FREE').firstOrNull;
    final paidPlans = _filteredPlans.where((p) => p.name != 'FREE').toList();

    return [
      if (freePlan != null) _freeCard(freePlan),
      const SizedBox(height: 12),
      ...paidPlans.map((p) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _paidCard(p),
      )),
    ];
  }

  Widget _freeCard(SubscriptionPlan plan) {
    final isCurrent = _status?.plan == 'FREE' && !(_status?.isPremium ?? false);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isCurrent ? AppColors.primary : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Free', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('0đ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          _feature(true, '5 bài học / ngày'),
          _feature(true, 'Flashcard cơ bản'),
          _feature(false, 'Không có AI features'),
          _feature(false, 'Giới hạn Speaking/Writing'),
        ],
      ),
    );
  }

  Widget _paidCard(SubscriptionPlan plan) {
    final isPopular = plan.name == 'MONTHLY';
    final isYearly = plan.name == 'YEARLY';
    final isCurrent = _status?.plan == plan.name && (_status?.isPremium ?? false);
    final monthlyPrice = isYearly ? (plan.price / 12).round() : plan.price;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPopular
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.primaryLight.withValues(alpha: 0.06),
                ],
              )
            : null,
        color: isPopular ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPopular ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border,
          width: isPopular ? 1.5 : 1,
        ),
        boxShadow: isPopular ? AppShadows.primaryGlowSoft : AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryIcon,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Phổ biến nhất',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isYearly ? 'Pro Yearly' : 'Pro Monthly',
                style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold,
                  color: isPopular ? AppColors.primary : AppColors.warning,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _formatPrice(isYearly ? plan.price : plan.price),
                          style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900,
                            color: isPopular ? AppColors.primary : AppColors.warning,
                          ),
                        ),
                        TextSpan(
                          text: isYearly ? 'đ/năm' : 'đ/th',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (isYearly)
                    Text('≈ ${_formatPrice(monthlyPrice)}đ/tháng',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _feature(true, 'Không giới hạn bài học'),
          _feature(true, 'Toàn bộ AI features (5 tính năng)'),
          _feature(true, 'Offline mode'),
          _feature(true, 'Hủy bất kỳ lúc nào'),
          if (isYearly) _feature(true, 'Ưu tiên hỗ trợ & tính năng mới'),
          const SizedBox(height: 16),
          if (!isCurrent)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isPopular ? AppColors.primary : AppColors.warning,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaymentScreen(plan: plan)),
                ),
                child: Text(
                  isYearly ? 'Đăng ký Pro Yearly' : 'Đăng ký Pro Monthly',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Text('✓ Gói hiện tại',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _feature(bool enabled, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: enabled ? AppColors.success : AppColors.textHint,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                  fontSize: 13,
                  color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
                )),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return const Text(
      'Hủy bất kỳ lúc nào trong Settings',
      style: TextStyle(fontSize: 12, color: AppColors.textHint),
      textAlign: TextAlign.center,
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000).round()}k';
    }
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1).replaceAll('.0', '')}k';
    }
    return price.toString();
  }
}
