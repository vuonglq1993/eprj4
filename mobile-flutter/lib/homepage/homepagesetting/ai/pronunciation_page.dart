// import 'package:flutter/material.dart';
// import '../../../models/ai_pronunciation_model.dart';
// import '../../../services/ai_pronunciation_service.dart';
//
// class PronunciationPage extends StatefulWidget {
//   const PronunciationPage({super.key});
//
//   @override
//   State<PronunciationPage> createState() => _PronunciationPageState();
// }
//
// class _PronunciationPageState extends State<PronunciationPage> {
//   final TextEditingController _targetController = TextEditingController();
//   final TextEditingController _recognizedController = TextEditingController();
//   String _cefrLevel = "B1";
//   bool isLoading = false;
//   PronunciationResponseModel? result;
//
//   @override
//   void dispose() {
//     _targetController.dispose();
//     _recognizedController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _analyze() async {
//     if (_targetController.text.trim().isEmpty ||
//         _recognizedController.text.trim().isEmpty ||
//         isLoading) {
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       result = null;
//     });
//
//     try {
//       final response = await AiPronunciationService.analyze(
//         PronunciationRequestModel(
//           targetText: _targetController.text.trim(),
//           recognizedText: _recognizedController.text.trim(),
//           cefrLevel: _cefrLevel,
//         ),
//       );
//
//       if (!mounted) return;
//       setState(() {
//         result = response;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi pronunciation: $e")),
//       );
//     } finally {
//       if (!mounted) return;
//       setState(() => isLoading = false);
//     }
//   }
//
//   Widget _buildScoreCircle() {
//     if (result == null) return const SizedBox.shrink();
//
//     return Column(
//       children: [
//         SizedBox(
//           width: 120,
//           height: 120,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CircularProgressIndicator(
//                 value: (result!.score.clamp(0, 100)) / 100,
//                 strokeWidth: 10,
//                 backgroundColor: Colors.grey.withOpacity(0.2),
//               ),
//               Text(
//                 "${result!.score}",
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text("CEFR: ${result!.cefrLevel}"),
//       ],
//     );
//   }
//
//   Widget _buildResultCard(ThemeData theme) {
//     if (result == null) return const SizedBox.shrink();
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (result!.feedback.isNotEmpty) ...[
//             const Text(
//               "Feedback",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(result!.feedback),
//             const SizedBox(height: 12),
//           ],
//           if (result!.phonemeErrors.isNotEmpty) ...[
//             const Text(
//               "Phoneme Errors",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(result!.phonemeErrors),
//             const SizedBox(height: 12),
//           ],
//           if (result!.improvement.isNotEmpty) ...[
//             const Text(
//               "Improvement",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(result!.improvement),
//           ],
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     const levels = ["A1", "A2", "B1", "B2", "C1", "C2"];
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         title: const Text(
//           "Pronunciation",
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
//             DropdownButtonFormField<String>(
//               value: _cefrLevel,
//               decoration: InputDecoration(
//                 labelText: "CEFR Level",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               items: levels
//                   .map(
//                     (level) => DropdownMenuItem(
//                   value: level,
//                   child: Text(level),
//                 ),
//               )
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _cefrLevel = value);
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _targetController,
//               decoration: InputDecoration(
//                 labelText: "Target text",
//                 hintText: "What the user should pronounce",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _recognizedController,
//               minLines: 3,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 labelText: "Recognized text",
//                 hintText: "Text recognized from speech",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : _analyze,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF5F2EFF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   "Analyze Pronunciation",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildScoreCircle(),
//             const SizedBox(height: 20),
//             _buildResultCard(theme),
//           ],
//         ),
//       ),
//     );
//   }
// }





//bản mới
import 'package:flutter/material.dart';
import '../../../models/ai_pronunciation_model.dart';
import '../../../services/ai_pronunciation_service.dart';

class PronunciationPage extends StatefulWidget {
  const PronunciationPage({super.key});

  @override
  State<PronunciationPage> createState() => _PronunciationPageState();
}

class _PronunciationPageState extends State<PronunciationPage> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _spokenController = TextEditingController();

  String _cefrLevel = "B1";
  bool isLoading = false;
  PronunciationResponseModel? result;

  @override
  void dispose() {
    _targetController.dispose();
    _spokenController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (_targetController.text.trim().isEmpty ||
        _spokenController.text.trim().isEmpty ||
        isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
      result = null;
    });

    try {
      final response = await AiPronunciationService.analyze(
        PronunciationRequestModel(
          targetText: _targetController.text.trim(),
          recognizedText: _spokenController.text.trim(),
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
        SnackBar(content: Text("Lỗi pronunciation: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Widget _buildScoreCard(ThemeData theme) {
    if (result == null) return const SizedBox.shrink();

    final score = result!.score.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.withOpacity(0.18),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$score",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Score",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Estimated CEFR: ${result!.cefrLevel}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      ThemeData theme, {
        required String title,
        required String value,
        required IconData icon,
      }) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
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
              Icon(icon, color: const Color(0xFF5F2EFF), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const levels = ["A1", "A2", "B1", "B2", "C1", "C2"];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        title: const Text(
          "Pronunciation",
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
            TextField(
              controller: _targetController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Target sentence",
                hintText: "Example: I would like a cup of coffee.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _spokenController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "What you said",
                hintText: "Paste the recognized speech text here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Tip: For now, this screen analyzes your spoken text after speech recognition. You can paste recognized speech here.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F2EFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                )
                    : const Text(
                  "Analyze Pronunciation",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _buildScoreCard(theme),
            if (result != null) ...[
              _buildInfoCard(
                theme,
                title: "Feedback",
                value: result!.feedback,
                icon: Icons.feedback_outlined,
              ),
              _buildInfoCard(
                theme,
                title: "Phoneme Errors",
                value: result!.phonemeErrors,
                icon: Icons.graphic_eq,
              ),
              _buildInfoCard(
                theme,
                title: "Improvement",
                value: result!.improvement,
                icon: Icons.trending_up,
              ),
            ],
          ],
        ),
      ),
    );
  }
}