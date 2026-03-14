import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const InputFieldWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color), // Màu chữ nhập vào
      decoration: InputDecoration(
        hintText: "Type your answer...",
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: theme.cardColor, // Nền ô nhập theo theme
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF5F2EFF), width: 2),
        ),
      ),
    );
  }
}