import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const InputFieldWidget({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      enabled: enabled,
      style: TextStyle(
        color: enabled
            ? theme.textTheme.bodyLarge?.color
            : theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
      ),
      decoration: InputDecoration(
        hintText: "Type your answer...",
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        // Khi disabled thì đổi màu nền nhạt đi một chút
        fillColor: enabled ? theme.cardColor : theme.disabledColor.withOpacity(0.05),
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.05)),
        ),
      ),
    );
  }
}