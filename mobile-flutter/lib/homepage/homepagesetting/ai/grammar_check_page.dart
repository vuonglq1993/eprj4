import 'package:flutter/material.dart';
import '../../../models/ai_grammar_model.dart';
import '../../../services/ai_grammar_service.dart';

class GrammarCheckPage extends StatefulWidget {
  const GrammarCheckPage({super.key});

  @override
  State<GrammarCheckPage> createState() => _GrammarCheckPageState();
}

class _GrammarCheckPageState extends State<GrammarCheckPage> {
  final TextEditingController _textController = TextEditingController();
  String _cefrLevel = "B1";
  bool isLoading = false;
  GrammarCheckResponseModel? result;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _checkGrammar() async {
    if (_textController.text.trim().isEmpty || isLoading) return;

    setState(() {
      isLoading = true;
      result = null;
    });

    try {
      final response = await AiGrammarService.checkGrammar(
        GrammarCheckRequestModel(
          text: _textController.text.trim(),
          cefrLevel: _cefrLevel,
        ),
      );

      if (!mounted) return;
      setState(() {
        result = response;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi grammar check: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildLevelDropdown() {
    const levels = ["A1", "A2", "B1", "B2", "C1", "C2"];
    return DropdownButtonFormField<String>(
      value: _cefrLevel,
      decoration: InputDecoration(
        labelText: "CEFR Level",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      items: levels
          .map(
            (level) => DropdownMenuItem(
          value: level,
          child: Text(level),
        ),
      )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _cefrLevel = value);
        }
      },
    );
  }

  Widget _buildResultCard(ThemeData theme) {
    if (result == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result!.isCorrect ? "Sentence is correct" : "Needs improvement",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: result!.isCorrect ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Original:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(result!.original),
              const SizedBox(height: 12),
              Text(
                "Corrected:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(result!.corrected),
              if (result!.betterExpression.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  "Better expression:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(result!.betterExpression),
              ],
              if (result!.tip.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  "Tip:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(result!.tip),
              ],
            ],
          ),
        ),
        if (result!.errors.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            "Errors",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          ...result!.errors.map((error) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error.type,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Wrong: ${error.wrong}"),
                  Text("Correct: ${error.correct}"),
                  if (error.explanation.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text("Explanation: ${error.explanation}"),
                  ],
                  if (error.rule.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text("Rule: ${error.rule}"),
                  ],
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        title: const Text(
          "Grammar Check",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLevelDropdown(),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              minLines: 5,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Enter a sentence or paragraph...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : _checkGrammar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F2EFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Check Grammar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildResultCard(theme),
          ],
        ),
      ),
    );
  }
}