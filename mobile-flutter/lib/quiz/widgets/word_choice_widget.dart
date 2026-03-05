import 'package:flutter/material.dart';

class WordChoiceWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onSelect;

  const WordChoiceWidget({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedOption == option;

        return GestureDetector(
          onTap: () => onSelect(option),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6CBC94).withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6CBC94)
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? const Color(0xFF6CBC94)
                      : Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(option,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}