import 'package:flutter/material.dart';

class HelpChatPage extends StatefulWidget {
  const HelpChatPage({super.key});

  @override
  State<HelpChatPage> createState() => _HelpChatPageState();
}

class _HelpChatPageState extends State<HelpChatPage> {

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Map<String, String>> messages = [
    {
      "role": "ai",
      "text": "Hello 👋 I'm your AI assistant. How can I help you today?"
    }
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() {

    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "role": "user",
        "text": controller.text.trim()
      });

      messages.add({
        "role": "ai",
        "text": "Thanks for your question. AI support will respond soon."
      });
    });

    controller.clear();

    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(

      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "AI Help",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          /// CHAT LIST
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,
              itemBuilder: (context, index) {

                bool isUser = messages[index]["role"] == "user";

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),

                    padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10
                    ),

                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),

                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF5F2EFF)
                          : theme.cardColor,

                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft:
                        isUser ? const Radius.circular(18) : const Radius.circular(4),
                        bottomRight:
                        isUser ? const Radius.circular(4) : const Radius.circular(18),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),

                    child: Text(
                      messages[index]["text"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isUser
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// INPUT AREA
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10
            ),

            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
            ),

            child: Row(
              children: [

                /// TEXT FIELD
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.send,

                    onSubmitted: (value) {
                      sendMessage();
                    },

                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),

                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// SEND BUTTON
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),

                    decoration: const BoxDecoration(
                      color: Color(0xFF5F2EFF),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}