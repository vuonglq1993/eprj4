import 'package:flutter/material.dart';
import 'theme.dart';

/// Widget bao ngoài bất kỳ widget nào để thêm hiệu ứng thu nhỏ khi bấm.
class TappableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  const TappableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.95,
  });

  @override
  State<TappableScale> createState() => _TappableScaleState();
}

class _TappableScaleState extends State<TappableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.pressedScale).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _ctrl.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _ctrl.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}

/// Nút bấm gradient tím với hiệu ứng glow và scale khi bấm.
class GradientButton extends StatefulWidget {
  final String label;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final double fontSize;

  const GradientButton({
    super.key,
    required this.label,
    this.enabled = true,
    this.isLoading = false,
    this.onTap,
    this.height = 54,
    this.borderRadius = 14,
    this.fontSize = 16,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _canTap =>
      widget.enabled && !widget.isLoading && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _canTap ? (_) => _ctrl.forward() : null,
      onTapUp: _canTap ? (_) => _ctrl.reverse() : null,
      onTapCancel: _canTap ? () => _ctrl.reverse() : null,
      onTap: _canTap ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.enabled ? AppGradients.primaryButton : null,
            color: !widget.enabled ? AppColors.surface : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow:
                widget.enabled && !widget.isLoading ? AppShadows.primaryGlow : null,
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w600,
                      color: widget.enabled
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
