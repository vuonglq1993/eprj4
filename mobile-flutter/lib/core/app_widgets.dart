import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import '../services/tts_service.dart';

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

// ── Speak button ──────────────────────────────────────────────────────────────
//
// Sizes:
//   SpeakSize.sm  — nhỏ (inline text, 28px)
//   SpeakSize.md  — vừa (word hero, 36px)  ← default
//   SpeakSize.lg  — to  (pronunciation page, 52px)

enum SpeakSize { sm, md, lg }

class SpeakButton extends StatefulWidget {
  final String text;
  final SpeakSize size;
  final bool slow;
  final Color? color;

  const SpeakButton({
    super.key,
    required this.text,
    this.size = SpeakSize.md,
    this.slow = false,
    this.color,
  });

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton>
    with SingleTickerProviderStateMixin {
  bool _playing = false;
  late AnimationController _ripple;

  @override
  void initState() {
    super.initState();
    _ripple = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _ripple.dispose();
    if (_playing) TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _tap() async {
    if (_playing) {
      await TtsService.instance.stop();
      setState(() => _playing = false);
      _ripple.stop();
      _ripple.reset();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _playing = true);
    _ripple.repeat();

    if (widget.slow) {
      await TtsService.instance.speakSlow(widget.text);
    } else {
      await TtsService.instance.speak(widget.text);
    }

    if (mounted) {
      setState(() => _playing = false);
      _ripple.stop();
      _ripple.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? AppColors.primaryLight;

    final (double box, double icon) = switch (widget.size) {
      SpeakSize.sm => (28.0, 14.0),
      SpeakSize.md => (36.0, 18.0),
      SpeakSize.lg => (52.0, 26.0),
    };

    return GestureDetector(
      onTap: _tap,
      child: AnimatedBuilder(
        animation: _ripple,
        builder: (_, child) {
          final t = _ripple.value < 0.5
              ? _ripple.value * 2
              : (1 - _ripple.value) * 2;
          final scale = _playing ? 1.0 + 0.08 * t : 1.0;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: box,
          height: box,
          decoration: BoxDecoration(
            color: _playing
                ? baseColor.withValues(alpha: 0.25)
                : baseColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: baseColor.withValues(alpha: _playing ? 0.7 : 0.35),
            ),
          ),
          child: Icon(
            _playing ? Icons.stop_rounded : Icons.volume_up_rounded,
            size: icon,
            color: baseColor,
          ),
        ),
      ),
    );
  }
}
