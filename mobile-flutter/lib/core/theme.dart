import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const bg = Color(0xFF0B1023);
  static const surface = Color(0xFF141430);
  static const inputBg = Color(0xFF1C1C3A);
  static const cardBg = Color(0xFF171730);

  // Primary purple
  static const primary = Color(0xFF6B3EEA);
  static const primaryLight = Color(0xFF8B60FF);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A8FA8);
  static const textHint = Color(0xFF4A4F6A);

  // Border
  static const border = Color(0xFF2A2A4A);
  static const borderFocus = Color(0xFF6B3EEA);

  // Status
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFEF5350);

  // Skill colors
  static const grammar = Color(0xFF6B3EEA);
  static const vocabulary = Color(0xFF3E8EEA);
  static const listening = Color(0xFFFF6B35);
  static const reading = Color(0xFF35C79A);
}

class AppGradients {
  /// Gradient chính cho nút bấm và highlight
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF9B72FF), Color(0xFF5230E0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Gradient cho logo/icon container
  static const LinearGradient primaryIcon = LinearGradient(
    colors: [Color(0xFF8B60FF), Color(0xFF5B2FE0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle overlay ở top của màn hình để tạo chiều sâu
  static const LinearGradient bgTop = LinearGradient(
    colors: [Color(0xFF131840), Color(0xFF0B1023)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.45],
  );

  /// Gradient thanh tiến trình active
  static const LinearGradient progressActive = LinearGradient(
    colors: [Color(0xFF9B72FF), Color(0xFF6B3EEA)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppShadows {
  /// Glow tím cho nút primary
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.45),
          blurRadius: 22,
          offset: const Offset(0, 8),
          spreadRadius: -3,
        ),
      ];

  /// Glow nhẹ dùng trong result page / icon
  static List<BoxShadow> get primaryGlowSoft => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.35),
          blurRadius: 32,
          offset: const Offset(0, 6),
          spreadRadius: 2,
        ),
      ];

  /// Shadow tối cho card / container
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  /// Shadow nhẹ cho item row
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bg,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
