import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/app_widgets.dart';
import '../../services/ai_service.dart';
import '../../l10n/l10n_ext.dart';

class AiVocabScreen extends StatefulWidget {
  const AiVocabScreen({super.key});

  @override
  State<AiVocabScreen> createState() => _AiVocabScreenState();
}

class _AiVocabScreenState extends State<AiVocabScreen>
    with SingleTickerProviderStateMixin {
  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();

  bool _loading = false;
  Map<String, dynamic>? _data;
  String? _error;

  // Tab: 0 = Overview, 1 = Examples, 2 = Practice
  late TabController _tabCtrl;

  static const _trending = [
    'deliberate', 'resilient', 'ambiguous', 'paramount',
    'scrutinize', 'alleviate', 'contemplate', 'eloquent',
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _focusNode.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _search([String? word]) async {
    final w = (word ?? _inputCtrl.text).trim();
    if (w.isEmpty || _loading) return;
    _inputCtrl.text = w;
    _focusNode.unfocus();
    setState(() {
      _loading = true;
      _data = null;
      _error = null;
    });

    final (:data, :error) = await AiService.generateVocab(word: w);

    if (!mounted) return;
    // ✅ animateTo PHẢI gọi NGOÀI setState để tránh crash TabController
    setState(() {
      _loading = false;
      _data = data;
      _error = error;
    });
    if (data != null) {
      _tabCtrl.animateTo(0);
    }
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
                      gradient: AppGradients.bgTop)),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  const SizedBox(height: 8),
                  // ✅ Trending words luôn hiển thị để user dễ bấm chuyển từ
                  _buildTrendingRow(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _loading
                        ? _buildLoading()
                        : _error != null
                            ? _buildError()
                            : _data != null
                                ? _buildResult()
                                : _buildEmptyHints(),
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
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF3E8EEA).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFF3E8EEA).withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.menu_book_rounded,
                color: Color(0xFF3E8EEA), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.aiVocabulary,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Text(context.l10n.smartDictionary,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (_data != null || _error != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  _data = null;
                  _error = null;
                  _inputCtrl.clear();
                });
                _focusNode.requestFocus();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(context.l10n.delete,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ),
            ),
        ],
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded,
                color: AppColors.textHint, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _inputCtrl,
                focusNode: _focusNode,
                style: const TextStyle(
                    fontSize: 15, color: AppColors.textPrimary),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: context.l10n.enterEnglishWord,
                  hintStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: _loading ? null : _search,
              child: Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: _loading ? null : AppGradients.primaryButton,
                  color: _loading ? AppColors.inputBg : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryLight))
                    : Text(context.l10n.lookup,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Trending row — luôn hiển thị ngang dưới search bar ───────────────────

  Widget _buildTrendingRow() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _trending.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final w = _trending[i];
          final isActive = _data?['word']?.toString().toLowerCase() ==
              w.toLowerCase();
          return GestureDetector(
            onTap: () => _search(w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF3E8EEA).withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF3E8EEA).withValues(alpha: 0.7)
                      : AppColors.border,
                ),
              ),
              child: Text(
                w,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isActive
                      ? const Color(0xFF3E8EEA)
                      : AppColors.textSecondary,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Empty state hints (chỉ hiện khi chưa tra từ nào) ──────────────────────

  Widget _buildEmptyHints() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _buildFeatureHints(),
      ],
    );
  }

  Widget _buildFeatureHints() {
    final hints = [
      (Icons.record_voice_over_rounded, context.l10n.ipaTranscription, '3E8EEA'),
      (Icons.lightbulb_outline_rounded, context.l10n.memorizationTip, 'FFB300'),
      (Icons.compare_arrows_rounded, context.l10n.synonymsAntonyms, '4CAF50'),
      (Icons.format_list_bulleted_rounded, context.l10n.realExamples, '8B60FF'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: hints.map((h) {
        final color = Color(int.parse('FF${h.$3}', radix: 16));
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(h.$1, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(h.$2,
                    style: TextStyle(
                        fontSize: 11.5,
                        color: color,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF3E8EEA).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 28, height: 28,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF3E8EEA)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(context.l10n.lookingUpWord,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(context.l10n.aiSynthesizing,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded,
                  color: AppColors.error, size: 28),
            ),
            const SizedBox(height: 14),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _search(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(context.l10n.retry,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.none)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Result ────────────────────────────────────────────────────────────────

  Widget _buildResult() {
    final d = _data!;
    final word = d['word'] as String? ?? '';
    final pronunciation = d['pronunciation'] as String? ?? '';
    final partOfSpeech = d['partOfSpeech'] as String? ?? '';
    final cefrLevel = d['cefrLevel'] as String? ?? '';
    final definition = d['definition'] as String? ?? '';
    final definitionVi = d['definitionVi'] as String? ?? '';
    final examples =
        ((d['examples'] as List?) ?? []).cast<Map<String, dynamic>>();
    final collocations = ((d['collocations'] as List?) ?? []).cast<String>();
    final synonyms = ((d['synonyms'] as List?) ?? []).cast<String>();
    final antonyms = ((d['antonyms'] as List?) ?? []).cast<String>();
    final tip = d['tip'] as String? ?? '';

    return Column(
      children: [
        // Word hero card
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _buildWordHero(
              word, pronunciation, partOfSpeech, cefrLevel, definition, definitionVi),
        ),
        const SizedBox(height: 12),
        // Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabCtrl,
              tabs: [
                Tab(text: context.l10n.overview),
                Tab(text: context.l10n.examples),
                Tab(text: context.l10n.related),
              ],
              labelStyle: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              labelColor: AppColors.primaryLight,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(3),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _buildOverviewTab(collocations, tip),
              _buildExamplesTab(examples),
              _buildRelatedTab(synonyms, antonyms),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWordHero(String word, String pronunciation, String pos,
      String cefr, String definition, String definitionVi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDEEBFF), Color(0xFFEFF4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF3E8EEA).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(word,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5)),
                    if (pronunciation.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(pronunciation,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF3E8EEA),
                                  fontStyle: FontStyle.italic)),
                          const SizedBox(width: 10),
                          // Normal speed
                          SpeakButton(
                            text: word,
                            size: SpeakSize.sm,
                            color: const Color(0xFF3E8EEA),
                          ),
                          const SizedBox(width: 6),
                          // Slow speed
                          SpeakButton(
                            text: word,
                            size: SpeakSize.sm,
                            slow: true,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(context.l10n.slow,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textHint)),
                        ],
                      ),
                    ] else ...[
                      // No pronunciation text — still show speak buttons
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          SpeakButton(
                            text: word,
                            size: SpeakSize.md,
                            color: const Color(0xFF3E8EEA),
                          ),
                          const SizedBox(width: 8),
                          SpeakButton(
                            text: word,
                            size: SpeakSize.md,
                            slow: true,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(context.l10n.slow,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textHint)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  if (pos.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(pos,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600)),
                    ),
                  if (cefr.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E8EEA).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(cefr,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF3E8EEA),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (definition.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(definition,
                style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                    height: 1.5)),
          ],
          if (definitionVi.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('→ $definitionVi',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewTab(List<String> collocations, String tip) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        if (collocations.isNotEmpty) ...[
          _SectionLabel(
              icon: Icons.link_rounded,
              label: context.l10n.commonPhrases,
              color: const Color(0xFF3E8EEA)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: collocations
                .map((c) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E8EEA).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF3E8EEA)
                                .withValues(alpha: 0.25)),
                      ),
                      child: Text(c,
                          style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF3E8EEA))),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (tip.isNotEmpty) ...[
          _SectionLabel(
              icon: Icons.lightbulb_rounded,
              label: context.l10n.memorizationTip,
              color: AppColors.warning),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    size: 14, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tip,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.55)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExamplesTab(List<Map<String, dynamic>> examples) {
    if (examples.isEmpty) {
      return Center(
        child: Text(context.l10n.noExamples,
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: examples.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final ex = examples[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color:
                          AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(ex['en'] as String? ?? '',
                        style: const TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textPrimary,
                            fontStyle: FontStyle.italic,
                            height: 1.5)),
                  ),
                  const SizedBox(width: 8),
                  SpeakButton(
                    text: ex['en'] as String? ?? '',
                    size: SpeakSize.sm,
                    color: AppColors.primaryLight,
                  ),
                ],
              ),
              if ((ex['vi'] as String? ?? '').isNotEmpty) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(ex['vi'] as String,
                      style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary
                              .withValues(alpha: 0.8),
                          height: 1.4)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildRelatedTab(
      List<String> synonyms, List<String> antonyms) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        if (synonyms.isNotEmpty) ...[
          _SectionLabel(
              icon: Icons.compare_arrows_rounded,
              label: context.l10n.synonyms,
              color: AppColors.success),
          const SizedBox(height: 8),
          _WordChips(
              words: synonyms,
              color: AppColors.success,
              onTap: _search),
          const SizedBox(height: 20),
        ],
        if (antonyms.isNotEmpty) ...[
          _SectionLabel(
              icon: Icons.swap_horiz_rounded,
              label: context.l10n.antonyms,
              color: AppColors.error),
          const SizedBox(height: 8),
          _WordChips(
              words: antonyms,
              color: AppColors.error,
              onTap: _search),
        ],
        if (synonyms.isEmpty && antonyms.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(context.l10n.noRelatedData,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
          ),
      ],
    );
  }
}

// ── Small helpers ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionLabel(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color)),
      ],
    );
  }
}

class _WordChips extends StatelessWidget {
  final List<String> words;
  final Color color;
  final void Function(String) onTap;
  const _WordChips(
      {required this.words, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: words
          .map((w) => GestureDetector(
                onTap: () => onTap(w),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(w,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: color,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded,
                          size: 10, color: color.withValues(alpha: 0.6)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
