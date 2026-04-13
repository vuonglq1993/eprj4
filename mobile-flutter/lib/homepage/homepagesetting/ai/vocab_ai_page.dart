// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../../../models/ai_vocab_model.dart';
// import '../../../services/ai_vocab_service.dart';
//
// class VocabAiPage extends StatefulWidget {
//   const VocabAiPage({super.key});
//
//   @override
//   State<VocabAiPage> createState() => _VocabAiPageState();
// }
//
// class _VocabAiPageState extends State<VocabAiPage> {
//   final TextEditingController _wordController = TextEditingController();
//   String _cefrLevel = "B1";
//   String _gameType = "MULTIPLE_CHOICE";
//
//   bool isLoadingGenerate = false;
//   bool isLoadingGame = false;
//
//   Map<String, dynamic>? vocabResult;
//   Map<String, dynamic>? gameResult;
//
//   @override
//   void dispose() {
//     _wordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _generateWordData() async {
//     if (_wordController.text.trim().isEmpty || isLoadingGenerate) return;
//
//     setState(() {
//       isLoadingGenerate = true;
//       vocabResult = null;
//     });
//
//     try {
//       final response = await AiVocabService.generateWordData(
//         VocabRequestModel(
//           word: _wordController.text.trim(),
//           cefrLevel: _cefrLevel,
//         ),
//       );
//
//       if (!mounted) return;
//       setState(() => vocabResult = response);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi vocab generate: $e")),
//       );
//     } finally {
//       if (!mounted) return;
//       setState(() => isLoadingGenerate = false);
//     }
//   }
//
//   Future<void> _generateGame() async {
//     if (_wordController.text.trim().isEmpty || isLoadingGame) return;
//
//     setState(() {
//       isLoadingGame = true;
//       gameResult = null;
//     });
//
//     try {
//       final response = await AiVocabService.generateGameQuestion(
//         VocabGameRequestModel(
//           word: _wordController.text.trim(),
//           gameType: _gameType,
//           cefrLevel: _cefrLevel,
//         ),
//       );
//
//       if (!mounted) return;
//       setState(() => gameResult = response);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi vocab game: $e")),
//       );
//     } finally {
//       if (!mounted) return;
//       setState(() => isLoadingGame = false);
//     }
//   }
//
//   Widget _jsonCard(String title, Map<String, dynamic>? data, ThemeData theme) {
//     if (data == null) return const SizedBox.shrink();
//
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(top: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: theme.textTheme.titleMedium?.color,
//             ),
//           ),
//           const SizedBox(height: 12),
//           SelectableText(
//             const JsonEncoder.withIndent("  ").convert(data),
//             style: TextStyle(
//               fontSize: 13,
//               color: theme.textTheme.bodyMedium?.color,
//               height: 1.45,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     const levels = ["A1", "A2", "B1", "B2", "C1", "C2"];
//     const gameTypes = ["MULTIPLE_CHOICE", "SPELLING", "SENTENCE"];
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         title: const Text(
//           "AI Vocabulary",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _wordController,
//               decoration: InputDecoration(
//                 labelText: "Word",
//                 hintText: "Enter a word",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _cefrLevel,
//               decoration: InputDecoration(
//                 labelText: "CEFR Level",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               items: levels
//                   .map((level) => DropdownMenuItem(
//                 value: level,
//                 child: Text(level),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _cefrLevel = value);
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _gameType,
//               decoration: InputDecoration(
//                 labelText: "Game Type",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               items: gameTypes
//                   .map((type) => DropdownMenuItem(
//                 value: type,
//                 child: Text(type),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _gameType = value);
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: isLoadingGenerate ? null : _generateWordData,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF5F2EFF),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: isLoadingGenerate
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                         "Generate",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: SizedBox(
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: isLoadingGame ? null : _generateGame,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: isLoadingGame
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                         "Game",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             _jsonCard("Word Data", vocabResult, theme),
//             _jsonCard("Game Question", gameResult, theme),
//           ],
//         ),
//       ),
//     );
//   }
// }




//bản mới
import 'package:flutter/material.dart';
import '../../../models/ai_vocab_model.dart';
import '../../../services/ai_vocab_service.dart';

class VocabAiPage extends StatefulWidget {
  const VocabAiPage({super.key});

  @override
  State<VocabAiPage> createState() => _VocabAiPageState();
}

class _VocabAiPageState extends State<VocabAiPage> {
  final TextEditingController _wordController = TextEditingController();
  String _cefrLevel = "B1";
  String _gameType = "MULTIPLE_CHOICE";

  bool isLoadingGenerate = false;
  bool isLoadingGame = false;

  Map<String, dynamic>? vocabResult;
  Map<String, dynamic>? gameResult;

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  Future<void> _generateWordData() async {
    if (_wordController.text.trim().isEmpty || isLoadingGenerate) return;

    setState(() {
      isLoadingGenerate = true;
      vocabResult = null;
    });

    try {
      final response = await AiVocabService.generateWordData(
        VocabRequestModel(
          word: _wordController.text.trim(),
          cefrLevel: _cefrLevel,
        ),
      );

      if (!mounted) return;
      setState(() => vocabResult = response);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi vocab generate: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoadingGenerate = false);
    }
  }

  Future<void> _generateGame() async {
    if (_wordController.text.trim().isEmpty || isLoadingGame) return;

    setState(() {
      isLoadingGame = true;
      gameResult = null;
    });

    try {
      final response = await AiVocabService.generateGameQuestion(
        VocabGameRequestModel(
          word: _wordController.text.trim(),
          gameType: _gameType,
          cefrLevel: _cefrLevel,
        ),
      );

      if (!mounted) return;
      setState(() => gameResult = response);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi vocab game: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoadingGame = false);
    }
  }

  String _readValue(Map<String, dynamic>? data, List<String> keys) {
    if (data == null) return "";
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return "";
  }

  Widget _buildInfoCard(
      ThemeData theme, {
        required String title,
        required String value,
        IconData? icon,
      }) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: const Color(0xFF5F2EFF)),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(ThemeData theme) {
    if (vocabResult == null) return const SizedBox.shrink();

    final word = _readValue(vocabResult, ["word", "term"]);
    final meaning = _readValue(vocabResult, ["meaning", "definition"]);
    final example = _readValue(vocabResult, ["example", "exampleSentence"]);
    final collocations =
    _readValue(vocabResult, ["collocations", "commonPhrases"]);
    final memoryTip = _readValue(vocabResult, ["memoryTip", "tip", "mnemonic"]);
    final raw = _readValue(vocabResult, ["raw"]);

    final hasStructured = [
      word,
      meaning,
      example,
      collocations,
      memoryTip,
    ].any((e) => e.isNotEmpty);

    if (!hasStructured && raw.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (word.isNotEmpty)
          _buildInfoCard(
            theme,
            title: "Word",
            value: word,
            icon: Icons.title,
          ),
        if (meaning.isNotEmpty)
          _buildInfoCard(
            theme,
            title: "Meaning",
            value: meaning,
            icon: Icons.lightbulb_outline,
          ),
        if (example.isNotEmpty)
          _buildInfoCard(
            theme,
            title: "Example",
            value: example,
            icon: Icons.chat_bubble_outline,
          ),
        if (collocations.isNotEmpty)
          _buildInfoCard(
            theme,
            title: "Collocations",
            value: collocations,
            icon: Icons.link,
          ),
        if (memoryTip.isNotEmpty)
          _buildInfoCard(
            theme,
            title: "Memory Tip",
            value: memoryTip,
            icon: Icons.psychology_outlined,
          ),
        if (!hasStructured && raw.isNotEmpty)
          _buildInfoCard(
            theme,
            title: "AI Result",
            value: raw,
            icon: Icons.auto_awesome,
          ),
      ],
    );
  }

  Widget _buildGameSection(ThemeData theme) {
    if (gameResult == null) return const SizedBox.shrink();

    final question = _readValue(gameResult, ["question", "prompt"]);
    final answer = _readValue(gameResult, ["answer", "correctAnswer"]);
    final explanation = _readValue(gameResult, ["explanation", "tip"]);
    final options = gameResult?["options"];
    final raw = _readValue(gameResult, ["raw"]);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.extension_outlined, color: Color(0xFF5F2EFF)),
              SizedBox(width: 8),
              Text(
                "Vocabulary Game",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (question.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              question,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
          if (options is List && options.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...options.map((option) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(option.toString()),
              );
            }),
          ],
          if (answer.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "Answer: $answer",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              explanation,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
          if (question.isEmpty && answer.isEmpty && raw.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              raw,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const levels = ["A1", "A2", "B1", "B2", "C1", "C2"];
    const gameTypes = ["MULTIPLE_CHOICE", "SPELLING", "SENTENCE"];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        title: const Text(
          "AI Vocabulary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _wordController,
              decoration: InputDecoration(
                labelText: "Word",
                hintText: "Enter a word to learn",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _cefrLevel,
              decoration: InputDecoration(
                labelText: "CEFR Level",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              items: levels
                  .map((level) => DropdownMenuItem(
                value: level,
                child: Text(level),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _cefrLevel = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gameType,
              decoration: InputDecoration(
                labelText: "Game Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              items: gameTypes
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _gameType = value);
                }
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoadingGenerate ? null : _generateWordData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F2EFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoadingGenerate
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Generate",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoadingGame ? null : _generateGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoadingGame
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Create Game",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _buildResultSection(theme),
            const SizedBox(height: 4),
            _buildGameSection(theme),
          ],
        ),
      ),
    );
  }
}