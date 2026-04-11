// import 'package:flutter/material.dart';
// import 'congratulations_page.dart';
// import '../services/language_service.dart';
//
// class LoginCompleteFlow extends StatefulWidget {
//   const LoginCompleteFlow({super.key});
//
//   @override
//   State<LoginCompleteFlow> createState() => _LoginCompleteFlowState();
// }
//
// class _LoginCompleteFlowState extends State<LoginCompleteFlow> {
//   int step = 0;
//   int? selectedIndex;
//
//   final List<Map<String, dynamic>> steps = [
//     {
//       "title": "What Is Your Mother Language?",
//       "options": LanguageService.languages.map((e) => e["name"]).toList()
//     },
//     {
//       "title": "What is your main reason for using the Language App?",
//       "options": [
//         "Travel",
//         "School",
//         "Work",
//         "Family/Friends",
//         "Skill Improvement",
//         "Others",
//       ]
//     },
//     {
//       "title": "How much do you know about our Language App?",
//       "options": [
//         "I don't know",
//         "I know a little",
//         "I know a lot",
//       ]
//     },
//     {
//       "title": "How old are you?",
//       "options": [
//         "Under 18",
//         "18 - 24",
//         "25 - 34",
//         "35 - 44",
//         "45 - 54",
//         "55 - 64",
//         "65 or older",
//       ]
//     },
//     {
//       "title": "How many hours a day can you dedicate to studying with the Language App?",
//       "options": [
//         "5min/Day",
//         "15min/Day",
//         "30min/Day",
//         "60min/Day",
//       ]
//     },
//     {
//       "title": "How did you hear about Language App?",
//       "options": [
//         "Friends/Family",
//         "Play Store",
//         "Youtube",
//         "TV",
//         "Podcast",
//         "Website Ad",
//       ]
//     },
//     {
//       "title": "Course Overview",
//       "isOverview": true
//     }
//   ];
//
//   void next() {
//     if (step == steps.length - 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const CongratulationsPage(),
//         ),
//       );
//       return;
//     }
//
//     if (selectedIndex == null) return;
//
//     setState(() {
//       step++;
//       selectedIndex = null;
//     });
//   }
//
//   void back() {
//     if (step > 0) {
//       setState(() {
//         step--;
//         selectedIndex = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var current = steps[step];
//     bool isOverview = current["isOverview"] == true;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: back,
//         ),
//         centerTitle: true,
//         title: Text(
//           "Completed ${step + 1}/${steps.length}",
//           style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 25),
//
//             Text(
//               current["title"],
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             if (!isOverview)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: current["options"].length,
//                   itemBuilder: (_, index) {
//                     bool isSelected = selectedIndex == index;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = index;
//                         });
//
//                         if (step == 0) {
//                           LanguageService.selectedLanguage.value = index;
//                         }
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 18),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xFF17A398)
//                               : const Color(0xFFE9EAF0),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           current["options"][index],
//                           style: TextStyle(
//                             color: isSelected
//                                 ? Colors.white
//                                 : Colors.black87,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//             if (isOverview)
//               Expanded(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Learn listening, speaking, reading, and writing skills.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         overviewCard("9000+", "Words"),
//                         const SizedBox(width: 20),
//                         overviewCard("2100+", "Sentences"),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//
//             GestureDetector(
//               onTap: (selectedIndex != null || isOverview) ? next : null,
//               child: Container(
//                 height: 55,
//                 margin: const EdgeInsets.only(bottom: 25),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
//                   ),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Next",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget overviewCard(String title, String subtitle) {
//     return Container(
//       width: 130,
//       height: 130,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9EAF0),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.description, size: 30),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             subtitle,
//             style: const TextStyle(color: Colors.grey),
//           )
//         ],
//       ),
//     );
//   }
// }



//
// import 'package:flutter/material.dart';
// import 'congratulations_page.dart';
// import '../services/language_service.dart';
// import '../models/language_model.dart';
//
// class LoginCompleteFlow extends StatefulWidget {
//   const LoginCompleteFlow({super.key});
//
//   @override
//   State<LoginCompleteFlow> createState() => _LoginCompleteFlowState();
// }
//
// class _LoginCompleteFlowState extends State<LoginCompleteFlow> {
//   int step = 0;
//   int? selectedIndex;
//
//   final List<Map<String, dynamic>> steps = [
//     {
//       "title": "What Is Your Mother Language?",
//       "isLanguageStep": true
//     },
//     {
//       "title": "What is your main reason for using the Language App?",
//       "options": [
//         "Travel",
//         "School",
//         "Work",
//         "Family/Friends",
//         "Skill Improvement",
//         "Others",
//       ]
//     },
//     {
//       "title": "How much do you know about our Language App?",
//       "options": [
//         "I don't know",
//         "I know a little",
//         "I know a lot",
//       ]
//     },
//     {
//       "title": "How old are you?",
//       "options": [
//         "Under 18",
//         "18 - 24",
//         "25 - 34",
//         "35 - 44",
//         "45 - 54",
//         "55 - 64",
//         "65 or older",
//       ]
//     },
//     {
//       "title": "How many hours a day can you dedicate to studying?",
//       "options": [
//         "5min/Day",
//         "15min/Day",
//         "30min/Day",
//         "60min/Day",
//       ]
//     },
//     {
//       "title": "How did you hear about Language App?",
//       "options": [
//         "Friends/Family",
//         "Play Store",
//         "Youtube",
//         "TV",
//         "Podcast",
//         "Website Ad",
//       ]
//     },
//     {
//       "title": "Course Overview",
//       "isOverview": true
//     }
//   ];
//
//   void next() {
//     if (step == steps.length - 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const CongratulationsPage(),
//         ),
//       );
//       return;
//     }
//
//     if (selectedIndex == null && steps[step]["isOverview"] != true) return;
//
//     setState(() {
//       step++;
//       selectedIndex = null;
//     });
//   }
//
//   void back() {
//     if (step > 0) {
//       setState(() {
//         step--;
//         selectedIndex = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var current = steps[step];
//     bool isOverview = current["isOverview"] == true;
//     bool isLanguageStep = current["isLanguageStep"] == true;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: back,
//         ),
//         centerTitle: true,
//         title: Text(
//           "Completed ${step + 1}/${steps.length}",
//           style: const TextStyle(
//               fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 25),
//
//             /// TITLE
//             Text(
//               current["title"],
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             /// ===== STEP LANGUAGE =====
//             if (isLanguageStep)
//               Expanded(
//                 child: FutureBuilder<List<Language>>(
//                   future: LanguageService.fetchLanguages(),
//                   builder: (context, snapshot) {
//
//                     if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const Center(
//                           child: CircularProgressIndicator());
//                     }
//
//                     if (snapshot.hasError) {
//                       return Center(
//                           child: Text("Error: ${snapshot.error}"));
//                     }
//
//                     final languages = snapshot.data!;
//
//                     return ListView.builder(
//                       itemCount: languages.length,
//                       itemBuilder: (_, index) {
//                         final lang = languages[index];
//                         bool isSelected =
//                             LanguageService.selectedLanguage.value?.code == lang.code;
//
//                         return GestureDetector(
//                           onTap: () async {
//                             setState(() {
//                               selectedIndex = index;
//                             });
//
//                             /// 🔥 LƯU LOCAL + UPDATE UI
//                             await LanguageService.saveSelectedLanguage(lang);
//
//                             print("Selected: ${lang.code}");
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(bottom: 15),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 18),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? const Color(0xFF17A398)
//                                   : const Color(0xFFE9EAF0),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Row(
//                               children: [
//                                 Text(lang.flag,
//                                     style:
//                                     const TextStyle(fontSize: 22)),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Text(
//                                     lang.name,
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.black87,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//
//             /// ===== STEP NORMAL =====
//             if (!isLanguageStep && !isOverview)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: current["options"].length,
//                   itemBuilder: (_, index) {
//                     bool isSelected = selectedIndex == index;
//
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = index;
//                         });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 18),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xFF17A398)
//                               : const Color(0xFFE9EAF0),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           current["options"][index],
//                           style: TextStyle(
//                             color: isSelected
//                                 ? Colors.white
//                                 : Colors.black87,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//             /// ===== STEP OVERVIEW =====
//             if (isOverview)
//               Expanded(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Learn listening, speaking, reading, and writing skills.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         overviewCard("9000+", "Words"),
//                         const SizedBox(width: 20),
//                         overviewCard("2100+", "Sentences"),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//
//             /// ===== BUTTON NEXT =====
//             GestureDetector(
//               onTap: (selectedIndex != null || isOverview) ? next : null,
//               child: Container(
//                 height: 55,
//                 margin: const EdgeInsets.only(bottom: 25),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
//                   ),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Next",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget overviewCard(String title, String subtitle) {
//     return Container(
//       width: 130,
//       height: 130,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9EAF0),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.description, size: 30),
//           const SizedBox(height: 10),
//           Text(title,
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(subtitle,
//               style: const TextStyle(color: Colors.grey))
//         ],
//       ),
//     );
//   }
// }




// // bản nối api
// import 'package:flutter/material.dart';
// import '../services/language_service.dart';
// import '../services/onboarding_service.dart';
// import '../models/language_model.dart';
// import 'congratulations_page.dart';
//
// class LoginCompleteFlow extends StatefulWidget {
//   const LoginCompleteFlow({super.key});
//
//   @override
//   State<LoginCompleteFlow> createState() => _LoginCompleteFlowState();
// }
//
// class _LoginCompleteFlowState extends State<LoginCompleteFlow> {
//   int step = 0;
//   int? selectedIndex;
//   bool isSubmitting = false;
//
//   Language? nativeLanguage; // ngôn ngữ toàn app / mother language
//   Language? targetLanguage; // ngôn ngữ muốn học
//
//   String? selectedGoal;
//   String? selectedSelfLevel;
//   String? selectedAgeGroup;
//   String? selectedDailyTime;
//   String? selectedHeardFrom;
//
//   final List<Map<String, dynamic>> steps = [
//     {
//       "title": "What is your native language?",
//       "isNativeLanguageStep": true,
//     },
//     {
//       "title": "Which language do you want to learn?",
//       "isTargetLanguageStep": true,
//     },
//     {
//       "title": "What is your main reason for learning?",
//       "options": [
//         "Travel",
//         "School",
//         "Work",
//         "Family/Friends",
//         "Skill Improvement",
//         "Others",
//       ]
//     },
//     {
//       "title": "How much do you know about this language?",
//       "options": [
//         "I don't know anything",
//         "I know a little",
//         "I can have basic conversations",
//         "I know a lot",
//       ]
//     },
//     {
//       "title": "How old are you?",
//       "options": [
//         "Under 18",
//         "18 - 24",
//         "25 - 34",
//         "35 - 44",
//         "45 - 54",
//         "55 - 64",
//         "65 or older",
//       ]
//     },
//     {
//       "title": "How much time can you study each day?",
//       "options": [
//         "5min/Day",
//         "15min/Day",
//         "30min/Day",
//         "60min/Day",
//       ]
//     },
//     {
//       "title": "How did you hear about Language App?",
//       "options": [
//         "Friends/Family",
//         "Play Store",
//         "Youtube",
//         "TV",
//         "Podcast",
//         "Website Ad",
//       ]
//     },
//     {
//       "title": "Course Overview",
//       "isOverview": true,
//     }
//   ];
//
//   bool get _canGoNext {
//     final current = steps[step];
//
//     if (current["isOverview"] == true) return true;
//     if (current["isNativeLanguageStep"] == true) return nativeLanguage != null;
//     if (current["isTargetLanguageStep"] == true) return targetLanguage != null;
//
//     return selectedIndex != null;
//   }
//
//   void back() {
//     if (step > 0) {
//       setState(() {
//         step--;
//         selectedIndex = null;
//       });
//     }
//   }
//
//   void _saveCurrentStepValue() {
//     if (selectedIndex == null) return;
//
//     final current = steps[step];
//     final value = current["options"]?[selectedIndex!] as String?;
//
//     if (value == null) return;
//
//     switch (step) {
//       case 2:
//         selectedGoal = value;
//         break;
//       case 3:
//         selectedSelfLevel = value;
//         break;
//       case 4:
//         selectedAgeGroup = value;
//         break;
//       case 5:
//         selectedDailyTime = value;
//         break;
//       case 6:
//         selectedHeardFrom = value;
//         break;
//     }
//   }
//
//   String _mapGoal(String value) {
//     switch (value) {
//       case "Travel":
//         return "TRAVEL";
//       case "School":
//         return "SCHOOL";
//       case "Work":
//         return "WORK";
//       case "Family/Friends":
//         return "FAMILY_FRIENDS";
//       case "Skill Improvement":
//         return "SKILL_IMPROVEMENT";
//       default:
//         return "OTHERS";
//     }
//   }
//
//   String _mapSelfLevel(String value) {
//     switch (value) {
//       case "I don't know anything":
//         return "COMPLETE_BEGINNER";
//       case "I know a little":
//         return "BEGINNER";
//       case "I can have basic conversations":
//         return "INTERMEDIATE";
//       case "I know a lot":
//         return "ADVANCED";
//       default:
//         return "BEGINNER";
//     }
//   }
//
//   String _mapDailyTime(String value) {
//     switch (value) {
//       case "5min/Day":
//         return "FIVE_MIN";
//       case "15min/Day":
//         return "FIFTEEN_MIN";
//       case "30min/Day":
//         return "THIRTY_MIN";
//       case "60min/Day":
//         return "SIXTY_MIN";
//       default:
//         return "FIFTEEN_MIN";
//     }
//   }
//
//   Future<void> next() async {
//     if (!_canGoNext || isSubmitting) return;
//
//     final current = steps[step];
//     final isOverview = current["isOverview"] == true;
//
//     _saveCurrentStepValue();
//
//     if (!isOverview && step < steps.length - 1) {
//       setState(() {
//         step++;
//         selectedIndex = null;
//       });
//       return;
//     }
//
//     await _submitOnboarding();
//   }
//
//   Future<void> _submitOnboarding() async {
//     if (nativeLanguage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng chọn ngôn ngữ mẹ đẻ")),
//       );
//       return;
//     }
//
//     if (targetLanguage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng chọn ngôn ngữ muốn học")),
//       );
//       return;
//     }
//
//     if (selectedGoal == null ||
//         selectedSelfLevel == null ||
//         selectedAgeGroup == null ||
//         selectedDailyTime == null ||
//         selectedHeardFrom == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng hoàn thành đầy đủ onboarding")),
//       );
//       return;
//     }
//
//     setState(() => isSubmitting = true);
//
//     final result = await OnboardingService.submit(
//       targetLanguageId: targetLanguage!.id,
//       nativeLanguageCode: nativeLanguage!.code,
//       selfLevel: _mapSelfLevel(selectedSelfLevel!),
//       goal: _mapGoal(selectedGoal!),
//       dailyTime: _mapDailyTime(selectedDailyTime!),
//       ageGroup: selectedAgeGroup!,
//       heardFrom: selectedHeardFrom!,
//     );
//
//     setState(() => isSubmitting = false);
//
//     if (!mounted) return;
//
//     if (result != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             result["motivationMessage"] ?? "Onboarding completed successfully",
//           ),
//         ),
//       );
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const CongratulationsPage(),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Gửi onboarding thất bại")),
//       );
//     }
//   }
//
//   Widget _buildLanguageList({
//     required List<Language> languages,
//     required Language? selectedLanguage,
//     required Function(Language lang) onSelected,
//   }) {
//     return ListView.builder(
//       itemCount: languages.length,
//       itemBuilder: (_, index) {
//         final lang = languages[index];
//         final isSelected = selectedLanguage?.code == lang.code;
//
//         return GestureDetector(
//           onTap: () async {
//             onSelected(lang);
//           },
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 15),
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? const Color(0xFF17A398)
//                   : const Color(0xFFE9EAF0),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               children: [
//                 Text(lang.flag, style: const TextStyle(fontSize: 22)),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     lang.name,
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black87,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 if (isSelected)
//                   const Icon(Icons.check_circle, color: Colors.white),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final current = steps[step];
//     final isOverview = current["isOverview"] == true;
//     final isNativeLanguageStep = current["isNativeLanguageStep"] == true;
//     final isTargetLanguageStep = current["isTargetLanguageStep"] == true;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F3F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5F2EFF),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: isSubmitting ? null : back,
//         ),
//         centerTitle: true,
//         title: Text(
//           "Completed ${step + 1}/${steps.length}",
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 25),
//             Text(
//               current["title"],
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 25),
//
//             if (isNativeLanguageStep || isTargetLanguageStep)
//               Expanded(
//                 child: FutureBuilder<List<Language>>(
//                   future: LanguageService.fetchLanguages(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (snapshot.hasError) {
//                       return Center(child: Text("Error: ${snapshot.error}"));
//                     }
//
//                     final languages = snapshot.data ?? [];
//
//                     return _buildLanguageList(
//                       languages: languages,
//                       selectedLanguage: isNativeLanguageStep
//                           ? nativeLanguage
//                           : targetLanguage,
//                       onSelected: (lang) async {
//                         if (isNativeLanguageStep) {
//                           await LanguageService.saveSelectedLanguage(lang);
//                           setState(() {
//                             nativeLanguage = lang;
//                             selectedIndex = 0;
//                           });
//                         } else {
//                           setState(() {
//                             targetLanguage = lang;
//                             selectedIndex = 0;
//                           });
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//
//             if (!isNativeLanguageStep && !isTargetLanguageStep && !isOverview)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: current["options"].length,
//                   itemBuilder: (_, index) {
//                     final isSelected = selectedIndex == index;
//
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = index;
//                         });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 18,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xFF17A398)
//                               : const Color(0xFFE9EAF0),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           current["options"][index],
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black87,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//             if (isOverview)
//               Expanded(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Learn listening, speaking, reading, and writing skills.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         overviewCard("9000+", "Words"),
//                         const SizedBox(width: 20),
//                         overviewCard("2100+", "Sentences"),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//
//             GestureDetector(
//               onTap: _canGoNext && !isSubmitting ? next : null,
//               child: Opacity(
//                 opacity: _canGoNext && !isSubmitting ? 1 : 0.6,
//                 child: Container(
//                   height: 55,
//                   margin: const EdgeInsets.only(bottom: 25),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Center(
//                     child: Text(
//                       isSubmitting ? "Submitting..." : "Next",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget overviewCard(String title, String subtitle) {
//     return Container(
//       width: 130,
//       height: 130,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9EAF0),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.description, size: 30),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             subtitle,
//             style: const TextStyle(color: Colors.grey),
//           )
//         ],
//       ),
//     );
//   }
// }




//bản nối lại learningpath
import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/onboarding_service.dart';
import '../services/learning_path_service.dart';
import '../models/language_model.dart';
import '../models/learning_path_model.dart';
import 'congratulations_page.dart';

class LoginCompleteFlow extends StatefulWidget {
  const LoginCompleteFlow({super.key});

  @override
  State<LoginCompleteFlow> createState() => _LoginCompleteFlowState();
}

class _LoginCompleteFlowState extends State<LoginCompleteFlow> {
  int step = 0;
  int? selectedIndex;
  bool isSubmitting = false;

  Language? nativeLanguage;
  Language? targetLanguage;
  LearningPathModel? selectedLearningPath;

  String? selectedGoal;
  String? selectedSelfLevel;
  String? selectedAgeGroup;
  String? selectedDailyTime;
  String? selectedHeardFrom;

  late Future<List<Language>> languagesFuture;
  Future<List<LearningPathModel>>? learningPathsFuture;

  final ScrollController _languageScrollController = ScrollController();
  final ScrollController _optionsScrollController = ScrollController();
  final ScrollController _learningPathScrollController = ScrollController();

  final List<Map<String, dynamic>> steps = [
    {
      "title": "What is your native language?",
      "isNativeLanguageStep": true,
    },
    {
      "title": "Which language do you want to learn?",
      "isTargetLanguageStep": true,
    },
    {
      "title": "What is your main reason for learning?",
      "options": [
        "Travel",
        "School",
        "Work",
        "Family/Friends",
        "Skill Improvement",
        "Others",
      ],
    },
    {
      "title": "How much do you know about this language?",
      "options": [
        "I don't know anything",
        "I know a little",
        "I can have basic conversations",
        "I know a lot",
      ],
    },
    {
      "title": "How old are you?",
      "options": [
        "Under 18",
        "18 - 24",
        "25 - 34",
        "35 - 44",
        "45 - 54",
        "55 - 64",
        "65 or older",
      ],
    },
    {
      "title": "How much time can you study each day?",
      "options": [
        "5min/Day",
        "15min/Day",
        "30min/Day",
        "60min/Day",
      ],
    },
    {
      "title": "How did you hear about Language App?",
      "options": [
        "Friends/Family",
        "Play Store",
        "Youtube",
        "TV",
        "Podcast",
        "Website Ad",
      ],
    },
    {
      "title": "Choose your learning path",
      "isLearningPathStep": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    languagesFuture = LanguageService.fetchLanguages();
    _restoreCurrentStepSelection();
  }

  @override
  void dispose() {
    _languageScrollController.dispose();
    _optionsScrollController.dispose();
    _learningPathScrollController.dispose();
    super.dispose();
  }

  bool get _canGoNext {
    final current = steps[step];

    if (current["isNativeLanguageStep"] == true) return nativeLanguage != null;
    if (current["isTargetLanguageStep"] == true) return targetLanguage != null;
    if (current["isLearningPathStep"] == true) return selectedLearningPath != null;

    return selectedIndex != null;
  }

  void _restoreCurrentStepSelection() {
    switch (step) {
      case 0:
        selectedIndex = nativeLanguage != null ? 0 : null;
        break;
      case 1:
        selectedIndex = targetLanguage != null ? 0 : null;
        break;
      case 2:
        selectedIndex = _findOptionIndex(step, selectedGoal);
        break;
      case 3:
        selectedIndex = _findOptionIndex(step, selectedSelfLevel);
        break;
      case 4:
        selectedIndex = _findOptionIndex(step, selectedAgeGroup);
        break;
      case 5:
        selectedIndex = _findOptionIndex(step, selectedDailyTime);
        break;
      case 6:
        selectedIndex = _findOptionIndex(step, selectedHeardFrom);
        break;
      case 7:
        selectedIndex = selectedLearningPath != null ? 0 : null;
        break;
      default:
        selectedIndex = null;
    }
  }

  int? _findOptionIndex(int stepIndex, String? value) {
    if (value == null) return null;
    final options = (steps[stepIndex]["options"] as List?)?.cast<String>() ?? [];
    final idx = options.indexOf(value);
    return idx >= 0 ? idx : null;
  }

  void back() {
    if (step > 0) {
      setState(() {
        step--;
        _restoreCurrentStepSelection();
      });
    }
  }

  void _saveCurrentStepValue() {
    if (selectedIndex == null) return;

    final current = steps[step];
    final value = current["options"]?[selectedIndex!] as String?;
    if (value == null) return;

    switch (step) {
      case 2:
        selectedGoal = value;
        break;
      case 3:
        selectedSelfLevel = value;
        break;
      case 4:
        selectedAgeGroup = value;
        break;
      case 5:
        selectedDailyTime = value;
        break;
      case 6:
        selectedHeardFrom = value;
        break;
    }
  }

  String _mapGoal(String value) {
    switch (value) {
      case "Travel":
        return "TRAVEL";
      case "School":
        return "SCHOOL";
      case "Work":
        return "WORK";
      case "Family/Friends":
        return "FAMILY_FRIENDS";
      case "Skill Improvement":
        return "SKILL_IMPROVEMENT";
      default:
        return "OTHERS";
    }
  }

  String _mapSelfLevel(String value) {
    switch (value) {
      case "I don't know anything":
        return "COMPLETE_BEGINNER";
      case "I know a little":
        return "BEGINNER";
      case "I can have basic conversations":
        return "INTERMEDIATE";
      case "I know a lot":
        return "ADVANCED";
      default:
        return "BEGINNER";
    }
  }

  String _mapDailyTime(String value) {
    switch (value) {
      case "5min/Day":
        return "FIVE_MIN";
      case "15min/Day":
        return "FIFTEEN_MIN";
      case "30min/Day":
        return "THIRTY_MIN";
      case "60min/Day":
        return "SIXTY_MIN";
      default:
        return "FIFTEEN_MIN";
    }
  }

  Future<void> next() async {
    if (!_canGoNext || isSubmitting) return;

    _saveCurrentStepValue();

    if (step < steps.length - 1) {
      setState(() {
        step++;
        _restoreCurrentStepSelection();
      });
      return;
    }

    await _submitOnboarding();
  }

  Future<void> _submitOnboarding() async {
    if (nativeLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ngôn ngữ mẹ đẻ")),
      );
      return;
    }

    if (targetLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ngôn ngữ muốn học")),
      );
      return;
    }

    if (selectedLearningPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn learning path")),
      );
      return;
    }

    if (selectedGoal == null ||
        selectedSelfLevel == null ||
        selectedAgeGroup == null ||
        selectedDailyTime == null ||
        selectedHeardFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng hoàn thành đầy đủ onboarding")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final result = await OnboardingService.submit(
      targetLanguageId: targetLanguage!.id,
      nativeLanguageCode: nativeLanguage!.code,
      selfLevel: _mapSelfLevel(selectedSelfLevel!),
      goal: _mapGoal(selectedGoal!),
      dailyTime: _mapDailyTime(selectedDailyTime!),
      ageGroup: selectedAgeGroup!,
      heardFrom: selectedHeardFrom!,
      learningPathId: selectedLearningPath!.id,
    );

    if (!mounted) return;

    setState(() => isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result["motivationMessage"] ?? "Onboarding completed successfully",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CongratulationsPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gửi onboarding thất bại")),
      );
    }
  }

  Widget _buildLanguageList({
    required List<Language> languages,
    required Language? selectedLanguage,
    required Function(Language lang) onSelected,
  }) {
    return ListView.builder(
      controller: _languageScrollController,
      key: const PageStorageKey("onboarding_language_list"),
      itemCount: languages.length,
      itemBuilder: (_, index) {
        final lang = languages[index];
        final isSelected = selectedLanguage?.code == lang.code;

        return GestureDetector(
          onTap: () async {
            onSelected(lang);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF17A398)
                  : const Color(0xFFE9EAF0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(lang.flag, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lang.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNormalOptions(List<String> options) {
    return ListView.builder(
      controller: _optionsScrollController,
      key: ValueKey("onboarding_options_step_$step"),
      itemCount: options.length,
      itemBuilder: (_, index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF17A398)
                  : const Color(0xFFE9EAF0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              options[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearningPathList(List<LearningPathModel> paths) {
    if (paths.isEmpty) {
      return const Center(
        child: Text("Ngôn ngữ này hiện chưa có learning path nào"),
      );
    }

    return ListView.builder(
      controller: _learningPathScrollController,
      key: const PageStorageKey("onboarding_learning_path_list"),
      itemCount: paths.length,
      itemBuilder: (_, index) {
        final path = paths[index];
        final isSelected = selectedLearningPath?.id == path.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedLearningPath = path;
              selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF17A398)
                  : const Color(0xFFE9EAF0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path.title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                if (path.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    path.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _metaChip("${path.totalSteps} steps", isSelected),
                    _metaChip("${path.estimatedHours}h", isSelected),
                    if (path.targetLevel.isNotEmpty)
                      _metaChip(path.targetLevel, isSelected),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _metaChip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.white24 : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = steps[step];
    final isNativeLanguageStep = current["isNativeLanguageStep"] == true;
    final isTargetLanguageStep = current["isTargetLanguageStep"] == true;
    final isLearningPathStep = current["isLearningPathStep"] == true;
    final options = (current["options"] as List?)?.cast<String>() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F2EFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: isSubmitting ? null : back,
        ),
        centerTitle: true,
        title: Text(
          "Completed ${step + 1}/${steps.length}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Text(
                current["title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),

              if (isNativeLanguageStep || isTargetLanguageStep)
                Expanded(
                  child: FutureBuilder<List<Language>>(
                    future: languagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      final languages = snapshot.data ?? [];

                      return _buildLanguageList(
                        languages: languages,
                        selectedLanguage: isNativeLanguageStep
                            ? nativeLanguage
                            : targetLanguage,
                        onSelected: (lang) async {
                          if (isNativeLanguageStep) {
                            await LanguageService.saveSelectedLanguage(lang);
                            setState(() {
                              nativeLanguage = lang;
                              selectedIndex = 0;
                            });
                          } else {
                            setState(() {
                              targetLanguage = lang;
                              selectedLearningPath = null;
                              learningPathsFuture =
                                  LearningPathService.getPublishedPaths(
                                    languageId: lang.id,
                                  );
                              selectedIndex = 0;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),

              if (!isNativeLanguageStep &&
                  !isTargetLanguageStep &&
                  !isLearningPathStep)
                Expanded(
                  child: _buildNormalOptions(options),
                ),

              if (isLearningPathStep)
                Expanded(
                  child: targetLanguage == null
                      ? const Center(
                    child: Text("Vui lòng chọn ngôn ngữ muốn học trước"),
                  )
                      : FutureBuilder<List<LearningPathModel>>(
                    future: learningPathsFuture ??
                        LearningPathService.getPublishedPaths(
                          languageId: targetLanguage!.id,
                        ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }

                      final paths = snapshot.data ?? [];
                      return _buildLearningPathList(paths);
                    },
                  ),
                ),

              GestureDetector(
                onTap: _canGoNext && !isSubmitting ? next : null,
                child: Opacity(
                  opacity: _canGoNext && !isSubmitting ? 1 : 0.6,
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C8CFF), Color(0xFF5F2EFF)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        isSubmitting
                            ? "Submitting..."
                            : (step == steps.length - 1 ? "Finish" : "Next"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}