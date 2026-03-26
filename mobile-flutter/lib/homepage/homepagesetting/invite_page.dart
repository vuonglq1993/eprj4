// import 'package:flutter/material.dart';
//
// class InvitePage extends StatelessWidget {
//   const InvitePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Invite Friends",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//
//         child: Column(
//           children: [
//
//             const Spacer(),
//
//             /// IMAGE
//             Image.network(
//               "https://cdni.iconscout.com/illustration/premium/thumb/friends-referral-illustration-download-in-svg-png-gif-file-formats--refer-a-friend-customer-loyalty-marketing-referring-business-pack-illustrations-5047466.png",
//               height: 200,
//             ),
//
//             const SizedBox(height: 25),
//
//             /// TITLE
//             Text(
//               "Invite your Friends",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: theme.textTheme.titleLarge?.color,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             /// SUBTITLE
//             Text(
//               "Learn together with friends",
//               style: TextStyle(
//                 color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
//                 fontSize: 16,
//               ),
//             ),
//
//             const Spacer(),
//
//             /// WHATSAPP BUTTON
//             _buildButton(
//               context: context,
//               text: "Whatsapp",
//               icon: Icons.chat,
//               bgColor: const Color(0xFF5C7CFA),
//               textColor: Colors.white,
//             ),
//
//             const SizedBox(height: 15),
//
//             /// TEXT MESSAGE
//             _buildButton(
//               context: context,
//               text: "Text Message",
//               icon: Icons.sms,
//               bgColor: theme.cardColor,
//               textColor: const Color(0xFF5C7CFA),
//               outlined: true,
//             ),
//
//             const SizedBox(height: 15),
//
//             /// MORE OPTIONS
//             _buildButton(
//               context: context,
//               text: "More Options",
//               icon: Icons.grid_view_rounded,
//               bgColor: theme.cardColor,
//               textColor: const Color(0xFF5C7CFA),
//               outlined: true,
//             ),
//
//             const SizedBox(height: 30),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required BuildContext context,
//     required String text,
//     required IconData icon,
//     required Color bgColor,
//     required Color textColor,
//     bool outlined = false,
//   }) {
//
//     final theme = Theme.of(context);
//
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//
//       child: ElevatedButton.icon(
//
//         onPressed: () {},
//
//         icon: Icon(
//           icon,
//           color: textColor,
//         ),
//
//         label: Text(
//           text,
//           style: TextStyle(
//             color: textColor,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//
//         style: ElevatedButton.styleFrom(
//           backgroundColor: bgColor,
//           elevation: 0,
//           side: outlined
//               ? BorderSide(color: const Color(0xFF5C7CFA))
//               : null,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../homepagesetting/theme_notifier.dart'; // Đảm bảo đúng đường dẫn tới file theme_notifier của bạn

class InvitePage extends StatelessWidget {
  const InvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final theme = Theme.of(context);
        final isDark = mode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF4B00D1),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Invite Friends",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 5),

                  /// ✅ IMAGE - Bọc ColorFiltered để xử lý màu ảnh khi sang Dark Mode
                  ColorFiltered(
                    colorFilter: isDark
                        ? const ColorFilter.matrix([
                      -1.0,  0.0,  0.0, 0.0, 255.0, // R
                      0.0, -1.0,  0.0, 0.0, 255.0, // G
                      0.0,  0.0, -1.0, 0.0, 255.0, // B
                      0.0,  0.0,  0.0, 1.0,   0.0, // A
                    ])
                        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: Image.asset(
                      "assets/images/invite_friends.png",
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// TITLE
                  Text(
                    "Invite your Friends",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 0),

                  /// SUBTITLE
                  Text(
                    "Learn together with friends",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// WHATSAPP BUTTON
                  _buildButton(
                    context: context,
                    text: "Whatsapp",
                    icon: Icons.chat,
                    bgColor: const Color(0xFF5F2EFF),
                    textColor: Colors.white,
                  ),

                  const SizedBox(height: 15),

                  /// TEXT MESSAGE
                  _buildButton(
                    context: context,
                    text: "Text Message",
                    icon: Icons.sms,
                    bgColor: theme.cardColor,
                    textColor: const Color(0xFF5F2EFF),
                    outlined: true,
                  ),

                  const SizedBox(height: 15),

                  /// MORE OPTIONS
                  _buildButton(
                    context: context,
                    text: "More Options",
                    icon: Icons.grid_view_rounded,
                    bgColor: theme.cardColor,
                    textColor: const Color(0xFF5F2EFF),
                    outlined: true,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    bool outlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // Xử lý logic chia sẻ ở đây
        },
        icon: Icon(icon, color: textColor, size: 22),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          side: outlined ? const BorderSide(color: Color(0xFF5F2EFF), width: 1.5) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

