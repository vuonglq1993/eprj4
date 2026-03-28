import 'package:flutter/material.dart';
import '../../homepage/homepagesetting/theme_notifier.dart';

class WordChoiceWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String)? onSelect;

  const WordChoiceWidget({
    super.key,
    required this.options,
    required this.selectedOption,
    // required this.onSelect,
    this.onSelect, // Bỏ required
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Sử dụng theme trực tiếp để check dark mode sẽ chuẩn hơn là gọi notifier
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: options.map((option) {
        final isSelected = selectedOption == option;
        const selectedColor = Color(0xFF6CBC94);

        return GestureDetector(
          // Nếu onSelect null thì vô hiệu hóa onTap
          onTap: onSelect == null ? null : () => onSelect!(option),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? selectedColor.withOpacity(0.2) : theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? selectedColor
                    : (isDark ? Colors.white10 : Colors.grey.shade300),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? selectedColor : (isDark ? Colors.grey[600] : Colors.grey),
                ),
                const SizedBox(width: 10),
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
      }).toList(),
    );
  }
}