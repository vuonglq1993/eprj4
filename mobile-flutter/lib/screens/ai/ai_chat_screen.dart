import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/ai_service.dart';

class AiChatScreen extends StatefulWidget {
  /// Optional lesson context passed from LessonPlayerScreen
  final String? lessonId;
  final String? lessonTitle;
  final String? cefrLevel;

  const AiChatScreen({
    super.key,
    this.lessonId,
    this.lessonTitle,
    this.cefrLevel,
  });

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen>
    with TickerProviderStateMixin {
  final _scroll = ScrollController();
  final _input = TextEditingController();
  final _focusNode = FocusNode();

  final List<AiChatMessage> _messages = [];
  bool _sending = false;
  int _remainingToday = -1; // -1 = unknown

  // Suggested starter questions
  static const _suggestions = [
    'Giải thích "will have + V3" cho mình với',
    'Khi nào dùng Present Perfect?',
    'Sửa câu này giúp mình: "I am go to school yesterday"',
    'Phân biệt "make" và "do" trong tiếng Anh',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcome();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addWelcome() {
    final greeting = widget.lessonTitle != null
        ? 'Xin chào! Mình là AI Teacher 👋\n\nMình thấy bạn đang học **${widget.lessonTitle}**. Bạn có câu hỏi gì về bài học không? Mình sẵn sàng giải thích bất kỳ điểm ngữ pháp hay từ vựng nào nhé!'
        : 'Xin chào! Mình là AI Teacher 👋\n\nMình có thể giúp bạn giải thích ngữ pháp, sửa câu, dịch nghĩa hoặc luyện tập hội thoại. Bạn muốn hỏi gì nào?';
    _messages.add(AiChatMessage(role: 'assistant', text: greeting));
  }

  Future<void> _send([String? override]) async {
    final text = (override ?? _input.text).trim();
    if (text.isEmpty || _sending) return;

    _input.clear();
    setState(() {
      _messages.add(AiChatMessage(role: 'user', text: text));
      _sending = true;
    });
    _scrollToBottom();

    final result = await AiService.chat(
      message: text,
      cefrLevel: widget.cefrLevel ?? 'B1',
      lessonId: widget.lessonId,
      lessonTitle: widget.lessonTitle,
    );

    if (!mounted) return;

    setState(() {
      _sending = false;
      if (result != null) {
        _messages.add(AiChatMessage(role: 'assistant', text: result.reply));
        _remainingToday = result.remainingToday;
      } else {
        _messages.add(AiChatMessage(
          role: 'assistant',
          text: '❌ Không thể kết nối đến AI. Vui lòng kiểm tra mạng và thử lại.',
        ));
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // top gradient
            Positioned(
              top: 0, left: 0, right: 0, height: 180,
              child: Container(
                decoration: const BoxDecoration(gradient: AppGradients.bgTop),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildMessageList()),
                  if (_sending) _buildTypingIndicator(),
                  _buildInputBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          // AI avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryIcon,
              shape: BoxShape.circle,
              boxShadow: AppShadows.primaryGlow,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Teacher',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  widget.lessonTitle != null
                      ? widget.lessonTitle!
                      : 'Gia sư ngôn ngữ thông minh',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_remainingToday >= 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: Text(
                '$_remainingToday còn lại',
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  // ── Message list ──────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    final showSuggestions = _messages.length == 1; // only welcome msg
    return ListView.builder(
      controller: _scroll,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      itemCount: _messages.length + (showSuggestions ? 1 : 0),
      itemBuilder: (_, i) {
        if (showSuggestions && i == _messages.length) {
          return _buildSuggestions();
        }
        return _buildBubble(_messages[i]);
      },
    );
  }

  Widget _buildBubble(AiChatMessage msg) {
    final isUser = msg.role == 'user';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                gradient: AppGradients.primaryIcon,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 14),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser ? AppGradients.primaryButton : null,
                color: isUser ? null : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: AppColors.border),
                boxShadow: isUser ? AppShadows.primaryGlow : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageText(msg.text, isUser: isUser),
                  // Speak button only on AI messages
                  if (!isUser) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SpeakButton(
                        text: msg.text.replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1'),
                        size: SpeakSize.sm,
                        color: AppColors.primaryLight.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildMessageText(String text, {required bool isUser}) {
    // Simple bold parser: **text** → bold
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int last = 0;
    final baseStyle = TextStyle(
      fontSize: 13.5,
      color: isUser ? Colors.white : AppColors.textPrimary,
      height: 1.55,
    );
    for (final m in regex.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(
            text: text.substring(last, m.start), style: baseStyle));
      }
      spans.add(TextSpan(
        text: m.group(1),
        style: baseStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: isUser ? Colors.white : AppColors.primaryLight,
        ),
      ));
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: baseStyle));
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 38, bottom: 8),
            child: Text(
              'Gợi ý câu hỏi:',
              style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) {
              return GestureDetector(
                onTap: () => _send(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.primaryLight),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Typing indicator ──────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: AppGradients.primaryIcon,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ── Input bar ─────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _input,
                focusNode: _focusNode,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: 'Hỏi AI Teacher...',
                  hintStyle:
                      TextStyle(color: AppColors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _sending
              ? Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryButton,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.primaryGlow,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Animated typing dots ──────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_ctrl.value - delay) % 1.0 + 1.0) % 1.0;
            final scale = 0.6 + 0.4 * _wave(t);
            return Padding(
              padding: EdgeInsets.only(right: i < 2 ? 5 : 0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight
                        .withValues(alpha: 0.5 + 0.5 * scale),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _wave(double t) {
    if (t < 0.5) return t * 2;
    return (1 - t) * 2;
  }
}
