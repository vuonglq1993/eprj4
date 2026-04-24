import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../services/ai_service.dart';
import '../../l10n/l10n_ext.dart';

class AiGrammarScreen extends StatefulWidget {
  const AiGrammarScreen({super.key});

  @override
  State<AiGrammarScreen> createState() => _AiGrammarScreenState();
}

class _AiGrammarScreenState extends State<AiGrammarScreen> {
  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();

  bool _checking = false;
  GrammarCheckResult? _result;
  String? _error;

  static const _examples = [
    'She have worked here since 2020.',
    'Yesterday, I go to the store and buyed some milk.',
    'He don\'t know the answer to the question.',
    'They was very happy when they heared the news.',
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _checking) return;
    _focusNode.unfocus();
    setState(() {
      _checking = true;
      _result = null;
      _error = null;
    });

    final res = await AiService.checkGrammar(text: text);

    if (!mounted) return;
    setState(() {
      _checking = false;
      if (res != null) {
        _result = res;
      } else {
        _error = context.l10n.error;
      }
    });
  }

  void _useExample(String ex) {
    _inputCtrl.text = ex;
    _check();
  }

  void _reset() {
    setState(() {
      _result = null;
      _error = null;
      _inputCtrl.clear();
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
            Positioned(
              top: 0, left: 0, right: 0, height: 180,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: AppGradients.bgTop),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputCard(),
                          const SizedBox(height: 16),
                          if (_result == null && !_checking && _error == null)
                            _buildExamples(),
                          if (_checking)
                            _buildLoadingCard(),
                          if (_error != null)
                            _buildErrorCard(),
                          if (_result != null) ...[
                            _buildScoreCard(),
                            const SizedBox(height: 14),
                            if (!_result!.isCorrect) ...[
                              _buildCorrectedCard(),
                              const SizedBox(height: 14),
                              if (_result!.errors.isNotEmpty)
                                _buildErrorsList(),
                              const SizedBox(height: 14),
                            ],
                            if (_result!.betterExpression.isNotEmpty)
                              _buildBetterExpressionCard(),
                            if (_result!.tip.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              _buildTipCard(),
                            ],
                          ],
                        ],
                      ),
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

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.spellcheck_rounded,
                color: Color(0xFF4CAF50), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.aiGrammarCheck,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                Text(
                  context.l10n.checkAndFixGrammar,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (_result != null)
            GestureDetector(
              onTap: _reset,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  context.l10n.refresh,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Input card ────────────────────────────────────────────────────────────

  Widget _buildInputCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.edit_rounded,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  context.l10n.enterSentenceToCheck,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      _inputCtrl.text = data!.text!;
                    }
                  },
                  child: Text(
                    context.l10n.paste,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.primaryLight),
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _inputCtrl,
            focusNode: _focusNode,
            style: const TextStyle(
                fontSize: 14.5, color: AppColors.textPrimary, height: 1.6),
            maxLines: 5,
            minLines: 3,
            decoration: const InputDecoration(
              hintText:
                  'Ví dụ: "She have worked here since 2020 and always been very dedicated."',
              hintStyle:
                  TextStyle(color: AppColors.textHint, fontSize: 13.5),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _inputCtrl,
                    builder: (_, val, __) {
                      final count = val.text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
                      return Text(
                        context.l10n.wordCount(count),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => _inputCtrl.clear(),
                  child: const Icon(Icons.clear_rounded,
                      size: 16, color: AppColors.textHint),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _checking ? null : _check,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: _checking
                          ? null
                          : AppGradients.primaryButton,
                      color: _checking ? AppColors.inputBg : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _checking
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryLight,
                            ),
                          )
                        : Text(
                            context.l10n.check,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Examples ──────────────────────────────────────────────────────────────

  Widget _buildExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.trySampleSentences,
          style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        ..._examples.map((ex) => GestureDetector(
              onTap: () => _useExample(ex),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        ex,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: AppColors.textHint),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.l10n.aiAnalyzing,
            style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.checkingGrammar,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_error!,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  // ── Score card ────────────────────────────────────────────────────────────

  Widget _buildScoreCard() {
    final result = _result!;
    final isOk = result.isCorrect;
    final color =
        isOk ? AppColors.success : AppColors.error;
    final bgColor = color.withValues(alpha: 0.08);
    final borderColor = color.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOk
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOk ? context.l10n.sentenceCorrect : context.l10n.grammarErrorsFound,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOk
                      ? context.l10n.sentencePerfect
                      : context.l10n.errorsFound(result.errors.length),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Corrected card ────────────────────────────────────────────────────────

  Widget _buildCorrectedCard() {
    final result = _result!;
    return _SectionCard(
      title: context.l10n.correctedSentence,
      icon: Icons.auto_fix_high_rounded,
      iconColor: const Color(0xFF4CAF50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original with strikethrough
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.error.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.close_rounded,
                    size: 14, color: AppColors.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.original,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.error,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.error,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Corrected in green
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_rounded,
                    size: 14, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.corrected,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: result.corrected));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.copiedCorrectedSentence),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy_rounded,
                      size: 14, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Errors list ───────────────────────────────────────────────────────────

  Widget _buildErrorsList() {
    return _SectionCard(
      title: context.l10n.errorDetails,
      icon: Icons.list_alt_rounded,
      iconColor: AppColors.warning,
      child: Column(
        children: _result!.errors.asMap().entries.map((e) {
          final idx = e.key;
          final err = e.value;
          return _ErrorItem(error: err, index: idx + 1);
        }).toList(),
      ),
    );
  }

  // ── Better expression ─────────────────────────────────────────────────────

  Widget _buildBetterExpressionCard() {
    return _SectionCard(
      title: context.l10n.betterExpressions,
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.primaryLight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Text(
          _result!.betterExpression,
          style: const TextStyle(
            fontSize: 13.5,
            color: AppColors.primaryLight,
            fontStyle: FontStyle.italic,
            height: 1.55,
          ),
        ),
      ),
    );
  }

  // ── Tip ───────────────────────────────────────────────────────────────────

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _result!.tip,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable section card ──────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Error item ────────────────────────────────────────────────────────────

class _ErrorItem extends StatefulWidget {
  final GrammarError error;
  final int index;

  const _ErrorItem({required this.error, required this.index});

  @override
  State<_ErrorItem> createState() => _ErrorItemState();
}

class _ErrorItemState extends State<_ErrorItem> {
  bool _expanded = false;

  static Color _typeColor(String type) {
    switch (type.toUpperCase()) {
      case 'GRAMMAR':
        return AppColors.error;
      case 'SPELLING':
        return AppColors.warning;
      case 'PUNCTUATION':
        return const Color(0xFF3E8EEA);
      default:
        return AppColors.textSecondary;
    }
  }

  String _typeLabel(BuildContext context, String type) {
    switch (type.toUpperCase()) {
      case 'GRAMMAR':
        return context.l10n.grammarType;
      case 'SPELLING':
        return context.l10n.spellingType;
      case 'PUNCTUATION':
        return context.l10n.punctuationType;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final err = widget.error;
    final color = _typeColor(err.type);

    return Container(
      margin: EdgeInsets.only(bottom: widget.index > 0 ? 10 : 0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Error number badge
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index}',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _typeLabel(context, err.type),
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: color),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '"${err.wrong}"',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.error,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                  const Text(' → ',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textHint)),
                                  Flexible(
                                    child: Text(
                                      '"${err.correct}"',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
          // Expanded explanation
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding:
                  const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: color.withValues(alpha: 0.15)),
                  const SizedBox(height: 6),
                  if (err.explanation.isNotEmpty) ...[
                    Text(
                      context.l10n.explanation,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHint),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      err.explanation,
                      style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                  ],
                  if (err.rule.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.primary
                                .withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school_rounded,
                              size: 12,
                              color: AppColors.primaryLight),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              err.rule,
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.primaryLight,
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
