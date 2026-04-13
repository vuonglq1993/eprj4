// import 'package:flutter/material.dart';
//
// class HelpChatPage extends StatefulWidget {
//   const HelpChatPage({super.key});
//
//   @override
//   State<HelpChatPage> createState() => _HelpChatPageState();
// }
//
// class _HelpChatPageState extends State<HelpChatPage> {
//
//   final TextEditingController controller = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//
//   List<Map<String, String>> messages = [
//     {
//       "role": "ai",
//       "text": "Hello 👋 I'm your AI assistant. How can I help you today?"
//     }
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       scrollToBottom();
//     });
//   }
//
//   void scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void sendMessage() {
//
//     if (controller.text.trim().isEmpty) return;
//
//     setState(() {
//       messages.add({
//         "role": "user",
//         "text": controller.text.trim()
//       });
//
//       messages.add({
//         "role": "ai",
//         "text": "Thanks for your question. AI support will respond soon."
//       });
//     });
//
//     controller.clear();
//
//     scrollToBottom();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//
//     return Scaffold(
//
//       backgroundColor: theme.scaffoldBackgroundColor,
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "AI Help",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//
//       body: Column(
//         children: [
//
//           /// CHAT LIST
//           Expanded(
//             child: ListView.builder(
//               controller: scrollController,
//               padding: const EdgeInsets.all(15),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//
//                 bool isUser = messages[index]["role"] == "user";
//
//                 return Align(
//                   alignment:
//                   isUser ? Alignment.centerRight : Alignment.centerLeft,
//
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 6),
//
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10
//                     ),
//
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.7,
//                     ),
//
//                     decoration: BoxDecoration(
//                       color: isUser
//                           ? const Color(0xFF5F2EFF)
//                           : theme.cardColor,
//
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(18),
//                         topRight: const Radius.circular(18),
//                         bottomLeft:
//                         isUser ? const Radius.circular(18) : const Radius.circular(4),
//                         bottomRight:
//                         isUser ? const Radius.circular(4) : const Radius.circular(18),
//                       ),
//
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 6,
//                           offset: const Offset(0, 2),
//                         )
//                       ],
//                     ),
//
//                     child: Text(
//                       messages[index]["text"]!,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isUser
//                             ? Colors.white
//                             : theme.textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           /// INPUT AREA
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 10
//             ),
//
//             decoration: BoxDecoration(
//               color: theme.cardColor,
//               border: Border(
//                 top: BorderSide(
//                   color: theme.dividerColor,
//                 ),
//               ),
//             ),
//
//             child: Row(
//               children: [
//
//                 /// TEXT FIELD
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     textInputAction: TextInputAction.send,
//
//                     onSubmitted: (value) {
//                       sendMessage();
//                     },
//
//                     decoration: InputDecoration(
//                       hintText: "Ask something...",
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12
//                       ),
//
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//
//                       filled: true,
//                       fillColor: theme.scaffoldBackgroundColor,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 /// SEND BUTTON
//                 GestureDetector(
//                   onTap: sendMessage,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF5F2EFF),
//                       shape: BoxShape.circle,
//                     ),
//
//                     child: const Icon(
//                       Icons.send,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }



//bản nối API
import 'package:flutter/material.dart';
import '../../../models/ai_chat_model.dart';
import '../../../services/ai_chat_service.dart';

class HelpChatPage extends StatefulWidget {
  final String? lessonId;
  final String? lessonTitle;
  final String? lessonContent;
  final String cefrLevel;

  const HelpChatPage({
    super.key,
    this.lessonId,
    this.lessonTitle,
    this.lessonContent,
    this.cefrLevel = "B1",
  });

  @override
  State<HelpChatPage> createState() => _HelpChatPageState();
}

class _HelpChatPageState extends State<HelpChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isSending = false;
  int? remainingToday;

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
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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

  Future<void> sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty || isSending) return;

    setState(() {
      messages.add({
        "role": "user",
        "text": text,
      });
      isSending = true;
    });

    controller.clear();
    _scrollToBottom();

    try {
      final response = await AiChatService.sendMessage(
        AiChatRequestModel(
          lessonId: widget.lessonId,
          lessonTitle: widget.lessonTitle,
          lessonContent: widget.lessonContent,
          cefrLevel: widget.cefrLevel,
          message: text,
        ),
      );

      if (!mounted) return;

      setState(() {
        messages.add({
          "role": "ai",
          "text": response.reply,
        });
        remainingToday = response.remainingToday;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        messages.add({
          "role": "ai",
          "text": "Có lỗi xảy ra khi gọi AI: $e",
        });
      });
    } finally {
      if (!mounted) return;
      setState(() {
        isSending = false;
      });
      _scrollToBottom();
    }
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AI Help",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (remainingToday != null)
              Text(
                "Remaining today: $remainingToday",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: messages.length + (isSending ? 1 : 0),
              itemBuilder: (context, index) {
                if (isSending && index == messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "AI is thinking...",
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final item = messages[index];
                final isUser = item["role"] == "user";

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF5F2EFF)
                          : theme.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: isUser
                            ? const Radius.circular(18)
                            : const Radius.circular(4),
                        bottomRight: isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      item["text"] ?? "",
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    enabled: !isSending,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
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
                GestureDetector(
                  onTap: isSending ? null : sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSending
                          ? Colors.grey
                          : const Color(0xFF5F2EFF),
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