// import 'package:flutter/material.dart';
// import '../../services/language_service.dart';
//
// class LanguageSelectionPage extends StatelessWidget {
//   const LanguageSelectionPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final languages = LanguageService.languages;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Select Language",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//
//       body: ValueListenableBuilder<int?>(
//         valueListenable: LanguageService.selectedLanguage,
//         builder: (context, selectedIndex, _) {
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: languages.length,
//
//             itemBuilder: (context, index) {
//
//               bool isSelected = selectedIndex == index;
//
//               return GestureDetector(
//                 onTap: () {
//
//                   LanguageService.selectedLanguage.value = index;
//
//                   Navigator.pop(context);
//                 },
//
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//
//                   decoration: BoxDecoration(
//                     color: theme.cardColor,
//                     borderRadius: BorderRadius.circular(14),
//
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 8,
//                         offset: const Offset(0,2),
//                       )
//                     ],
//                   ),
//
//                   child: ListTile(
//                     contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//
//                     leading: Text(
//                       languages[index]['flag']!,
//                       style: const TextStyle(fontSize: 26),
//                     ),
//
//                     title: Text(
//                       languages[index]['name']!,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         color: theme.textTheme.bodyLarge?.color,
//                       ),
//                     ),
//
//                     trailing: Icon(
//                       isSelected
//                           ? Icons.radio_button_checked
//                           : Icons.radio_button_unchecked,
//                       color: isSelected
//                           ? const Color(0xFF4B00D1)
//                           : theme.disabledColor,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



//
// import 'package:flutter/material.dart';
// import '../../services/language_service.dart';
// import '../../models/language_model.dart';
//
// class LanguageSelectionPage extends StatefulWidget {
//   const LanguageSelectionPage({super.key});
//
//   @override
//   State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
// }
//
// class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
//
//   int? selectedIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4B00D1),
//         title: const Text("Select Language"),
//       ),
//
//       body: FutureBuilder<List<Language>>(
//         future: LanguageService.fetchLanguages(),
//
//         builder: (context, snapshot) {
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//
//           final languages = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: languages.length,
//             padding: const EdgeInsets.all(16),
//
//             itemBuilder: (context, index) {
//
//               final lang = languages[index];
//               bool isSelected = selectedIndex == index;
//
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIndex = index;
//                   });
//
//                   // 👉 lưu language
//                   LanguageService.saveSelectedLanguage(lang);
//
//                   // 👉 lưu code để dùng đổi ngôn ngữ
//                   print("Selected: ${lang.code}");
//
//                   Navigator.pop(context);
//                 },
//
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//
//                   decoration: BoxDecoration(
//                     color: theme.cardColor,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//
//                   child: ListTile(
//                     leading: Text(
//                       lang.flag,
//                       style: const TextStyle(fontSize: 26),
//                     ),
//
//                     title: Text(
//                       lang.name,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//
//                     subtitle: Text(lang.nativeName),
//
//                     trailing: Icon(
//                       isSelected
//                           ? Icons.radio_button_checked
//                           : Icons.radio_button_unchecked,
//                       color: isSelected
//                           ? const Color(0xFF4B00D1)
//                           : theme.disabledColor,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../../services/language_service.dart';
import '../../models/language_model.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          "Select Language",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: FutureBuilder<List<Language>>(
        future: LanguageService.fetchLanguages(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final languages = snapshot.data!;

          return ValueListenableBuilder<Language?>(
            valueListenable: LanguageService.selectedLanguage,
            builder: (context, selectedLang, _) {

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: languages.length,

                itemBuilder: (context, index) {

                  final lang = languages[index];

                  /// 🔥 CHECK SELECTED THEO CODE
                  bool isSelected =
                      selectedLang?.code == lang.code;

                  return GestureDetector(
                    onTap: () async {
                      await LanguageService.saveSelectedLanguage(lang);
                      Navigator.pop(context);
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),

                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),

                        leading: Text(
                          lang.flag,
                          style: const TextStyle(fontSize: 26),
                        ),

                        title: Text(
                          lang.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),

                        subtitle: Text(lang.nativeName),

                        trailing: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? const Color(0xFF4B00D1)
                              : theme.disabledColor,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}