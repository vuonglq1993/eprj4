import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'ai_button_controller.dart';
import '../screens/ai/ai_chat_screen.dart';
import '../screens/ai/ai_grammar_screen.dart';
import '../screens/ai/ai_vocab_screen.dart';
import '../screens/ai/ai_recommend_screen.dart';
import '../screens/ai/ai_pronunciation_screen.dart';
import '../screens/profile/ai_review_screen.dart';

// ── Menu item definition ───────────────────────────────────────────────────

class _AiMenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback Function(NavigatorState nav) onTap;

  const _AiMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// ── Global floating AI button with expandable menu ─────────────────────────

class AiFloatingButton extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const AiFloatingButton({super.key, required this.navigatorKey});

  @override
  State<AiFloatingButton> createState() => _AiFloatingButtonState();
}

class _AiFloatingButtonState extends State<AiFloatingButton>
    with TickerProviderStateMixin {
  // Pulse glow on the main button
  late final AnimationController _pulse;
  late final Animation<double> _glowAnim;

  // Expand/collapse menu
  late final AnimationController _expand;
  late final Animation<double> _expandAnim;
  bool _open = false;

  static final List<_AiMenuItem> _items = [
    _AiMenuItem(
      label: 'AI Chat',
      icon: Icons.chat_bubble_rounded,
      color: const Color(0xFF8B60FF),
      onTap: (nav) => () => _push(nav, const AiChatScreen()),
    ),
    _AiMenuItem(
      label: 'Ngữ pháp',
      icon: Icons.spellcheck_rounded,
      color: const Color(0xFF4CAF50),
      onTap: (nav) => () => _push(nav, const AiGrammarScreen()),
    ),
    _AiMenuItem(
      label: 'Từ vựng',
      icon: Icons.menu_book_rounded,
      color: const Color(0xFF3E8EEA),
      onTap: (nav) => () => _push(nav, const AiVocabScreen()),
    ),
    _AiMenuItem(
      label: 'Phát âm',
      icon: Icons.mic_rounded,
      color: const Color(0xFFFF6B35),
      onTap: (nav) => () => _push(nav, const AiPronunciationScreen()),
    ),
    _AiMenuItem(
      label: 'Gợi ý',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFFB300),
      onTap: (nav) => () => _push(nav, const AiRecommendScreen()),
    ),
    _AiMenuItem(
      label: 'Ôn tập',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFFE11D48),
      onTap: (nav) => () => _push(nav, const AiReviewScreen()),
    ),
  ];

  static void _push(NavigatorState nav, Widget screen) {
    nav.push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, anim, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: SlideTransition(position: slide, child: child),
        );
      },
    ));
  }

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.28, end: 0.65).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );

    _expand = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnim = CurvedAnimation(parent: _expand, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _expand.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() => _open = !_open);
    _open ? _expand.forward() : _expand.reverse();
  }

  void _closeAndNavigate(VoidCallback fn) {
    setState(() => _open = false);
    _expand.reverse().then((_) => fn());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AiButtonController.visible,
      builder: (_, visible, __) {
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: AnimatedSlide(
            offset: visible ? Offset.zero : const Offset(0, 0.3),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: IgnorePointer(
              ignoring: !visible,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ── Menu items (shown when open) ──────────────────────────
                  ..._items.asMap().entries.map((e) {
                    final idx = e.key;
                    final item = e.value;
                    // stagger: items appear bottom→top, so reverse index
                    final delay = (_items.length - 1 - idx) / _items.length;
                    return AnimatedBuilder(
                      animation: _expandAnim,
                      builder: (_, __) {
                        final t = (_expandAnim.value - delay * 0.5)
                            .clamp(0.0, 1.0);
                        final scale =
                            Curves.easeOutBack.transform(t.clamp(0.0, 1.0));
                        return Opacity(
                          opacity: t.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _MenuChip(
                                label: item.label,
                                icon: item.icon,
                                color: item.color,
                                onTap: () {
                                  final nav =
                                      widget.navigatorKey.currentState;
                                  if (nav == null) return;
                                  _closeAndNavigate(item.onTap(nav));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),

                  // ── Main FAB ──────────────────────────────────────────────
                  GestureDetector(
                    onTap: _toggle,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_glowAnim, _expand]),
                      builder: (_, __) {
                        return Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: _open
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B6B),
                                      Color(0xFFE53935)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : AppGradients.primaryIcon,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_open
                                        ? Colors.red
                                        : AppColors.primary)
                                    .withValues(alpha: _glowAnim.value),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AnimatedRotation(
                            turns: _open ? 0.125 : 0,
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutBack,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  _open
                                      ? Icons.close_rounded
                                      : Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                if (!_open)
                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00E5FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'AI',
                                          style: TextStyle(
                                            fontSize: 5.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Menu chip ──────────────────────────────────────────────────────────────

class _MenuChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // label pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // icon circle
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 18),
          ),
        ],
      ),
    );
  }
}
