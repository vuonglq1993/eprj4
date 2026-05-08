import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds — trắng ngà với tint tím nhẹ
  static const bg      = Color(0xFFF6F4FF);   // nền toàn app
  static const surface = Color(0xFFFFFFFF);   // card / bottom sheet
  static const inputBg = Color(0xFFF0EEFB);   // input field
  static const cardBg  = Color(0xFFFFFFFF);

  // Primary purple — giữ nguyên identity
  static const primary      = Color(0xFF6B3EEA);
  static const primaryLight = Color(0xFF8B60FF);

  // Text
  static const textPrimary   = Color(0xFF12082E);  // navy đậm
  static const textSecondary = Color(0xFF6B6880);  // grey-purple
  static const textHint      = Color(0xFFAAABBF);  // placeholder

  // Border
  static const border      = Color(0xFFE4E1F5);
  static const borderFocus = Color(0xFF6B3EEA);

  // Status
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error   = Color(0xFFEF4444);

  // Skill colors
  static const grammar    = Color(0xFF6B3EEA);
  static const vocabulary = Color(0xFF3B82F6);
  static const listening  = Color(0xFFEF6820);
  static const reading    = Color(0xFF10B981);
}

class AppGradients {
  /// Nút primary
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF9B72FF), Color(0xFF5230E0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Logo / avatar icon
  static const LinearGradient primaryIcon = LinearGradient(
    colors: [Color(0xFF9B72FF), Color(0xFF5B2FE0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Header overlay — tint tím nhạt ở đỉnh màn hình
  static const LinearGradient bgTop = LinearGradient(
    colors: [Color(0xFFEDE8FF), Color(0xFFF6F4FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.55],
  );

  /// Hero card tím nhạt (thay thế gradient tối trên nền sáng)
  static const LinearGradient cardHero = LinearGradient(
    colors: [Color(0xFFEAE4FF), Color(0xFFF3F0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero card xanh nhạt (vocab / listening)
  static const LinearGradient cardHeroBlue = LinearGradient(
    colors: [Color(0xFFDEEBFF), Color(0xFFEFF4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Progress bar
  static const LinearGradient progressActive = LinearGradient(
    colors: [Color(0xFF9B72FF), Color(0xFF6B3EEA)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppShadows {
  /// Glow tím cho nút & icon primary
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.28),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
      ];

  /// Glow nhẹ hơn cho avatar / result icon
  static List<BoxShadow> get primaryGlowSoft => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.18),
          blurRadius: 28,
          offset: const Offset(0, 6),
          spreadRadius: 2,
        ),
      ];

  /// Shadow card — tím nhạt thay vì đen (hiện đại hơn)
  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF6B3EEA).withValues(alpha: 0.07),
          blurRadius: 20,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  /// Shadow nhẹ cho row item
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: const Color(0xFF6B3EEA).withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
          outline: AppColors.border,
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
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? Colors.white : AppColors.textHint),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.border),
        ),
        dividerColor: AppColors.border,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.borderFocus, width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.textHint),
        ),
      );
}
