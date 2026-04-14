import 'package:flutter/material.dart';
import 'grammar_check_page.dart';
import 'pronunciation_page.dart';
import 'vocab_ai_page.dart';
import 'recommend_page.dart';
//import '../../homepagesetting/help_chat_page.dart';
import 'help_chat_page.dart';

class AiToolsPage extends StatelessWidget {
  const AiToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        title: const Text(
          "AI Tools",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(
            context,
            title: "AI Chat",
            subtitle: "Chat with AI teacher",
            icon: Icons.chat_bubble_outline,
            page: const HelpChatPage(),
          ),
          _item(
            context,
            title: "Grammar Check",
            subtitle: "Check grammar and corrections",
            icon: Icons.spellcheck,
            page: const GrammarCheckPage(),
          ),
          _item(
            context,
            title: "Pronunciation",
            subtitle: "Analyze pronunciation from recognized text",
            icon: Icons.record_voice_over_outlined,
            page: const PronunciationPage(),
          ),
          _item(
            context,
            title: "Vocabulary AI",
            subtitle: "Generate word data and vocab games",
            icon: Icons.menu_book_outlined,
            page: const VocabAiPage(),
          ),
          _item(
            context,
            title: "Recommendation",
            subtitle: "Get suggested lessons from study data",
            icon: Icons.auto_awesome_outlined,
            page: const RecommendPage(),
          ),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Widget page,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5F2EFF), size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}