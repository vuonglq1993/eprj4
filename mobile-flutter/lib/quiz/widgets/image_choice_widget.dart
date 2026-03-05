import 'package:flutter/material.dart';

class ImageChoiceWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onSelect;

  const ImageChoiceWidget({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
  });

  // Hàm giả lập icon dựa trên text
  String _getEmoji(String text) {
    if (text == "Men") return "👨";
    if (text == "Women") return "👩";
    if (text == "Boy") return "👦";
    if (text == "Girl") return "👧";
    return "❓";
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedOption == option;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6CBC94).withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF6CBC94) : Colors.grey.shade200,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_getEmoji(option), style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                Text(option, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}