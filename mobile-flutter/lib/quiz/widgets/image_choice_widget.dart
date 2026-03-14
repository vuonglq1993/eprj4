import 'package:flutter/material.dart';
import '../../homepage/homepagesetting/theme_notifier.dart';

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

  String _getEmoji(String text) {
    if (text == "Men") return "👨";
    if (text == "Women") return "👩";
    if (text == "Boy") return "👦";
    if (text == "Girl") return "👧";
    return "❓";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = themeNotifier.value == ThemeMode.dark;

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
        const selectedColor = Color(0xFF6CBC94);

        return GestureDetector(
          onTap: () => onSelect(option),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? selectedColor.withOpacity(0.2) : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? selectedColor : (isDark ? Colors.white10 : Colors.grey.shade200),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_getEmoji(option), style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                Text(
                  option,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}