import 'package:flutter/material.dart';

class AppColors {
  // ── Background ─────────────────────────────────────────────
  static const bg      = Color(0xFF071628);   // base screen bg
  static const bgMid   = Color(0xFF0A1F3A);   // gradient mid
  static const bgDeep  = Color(0xFF061219);   // gradient end
  static const surface = Color(0x1264DCFF);   // glass card surface rgba(100,220,255,.07)
  static const inputBg = Color(0x0F64DCFF);   // input fill (slightly more transparent)
  static const cardBg  = Color(0x1264DCFF);

  // ── Primary — Arctic Blue ───────────────────────────────────
  static const primary      = Color(0xFF00B4D8);  // button gradient start
  static const primaryDeep  = Color(0xFF0077B6);  // button gradient end
  static const primaryLight = Color(0xFF90E0EF);  // highlight, gradient text
  static const accent       = Color(0xFF64DCFF);  // icon, badge, text accent
  static const pale         = Color(0xFFB8F0FF);  // selected item text

  // ── Typography ─────────────────────────────────────────────
  static const textPrimary   = Color(0xFFFFFFFF);          // heading
  static const textSecondary = Color(0xBFFFFFFF);          // body rgba(.75)
  static const textMuted     = Color(0x73FFFFFF);          // sub-label rgba(.45)
  static const textHint      = Color(0x40FFFFFF);          // placeholder rgba(.25)

  // ── Border ─────────────────────────────────────────────────
  static const border      = Color(0x1AFFFFFF);  // default rgba(.10)
  static const borderGlass = Color(0x2E64DCFF);  // glass card border rgba(.18)
  static const borderFocus = Color(0xFF64DCFF);

  // ── Semantic ───────────────────────────────────────────────
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const error   = Color(0xFFF87171);
  static const ai      = Color(0xFFA78BFA);   // AI / special badges

  // ── Skill colors ───────────────────────────────────────────
  static const grammar    = Color(0xFFA78BFA);
  static const vocabulary = Color(0xFF64DCFF);
  static const listening  = Color(0xFFF87171);
  static const reading    = Color(0xFF34D399);
}

class AppGradients {
  /// Nút bấm primary — arctic blue gradient
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Logo / avatar / icon container
  static const LinearGradient primaryIcon = LinearGradient(
    colors: [Color(0xFF64DCFF), Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Full screen background — 3 stop navy gradient
  static const LinearGradient screenBg = LinearGradient(
    colors: [Color(0xFF071628), Color(0xFF0A1F3A), Color(0xFF061219)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  /// Header overlay subtle tint
  static const LinearGradient bgTop = LinearGradient(
    colors: [Color(0xFF0D2540), Color(0xFF071628)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.55],
  );

  /// Gradient text — accent → light
  static const LinearGradient gradientText = LinearGradient(
    colors: [Color(0xFF64DCFF), Color(0xFF90E0EF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Hero card glass surface
  static const LinearGradient cardHero = LinearGradient(
    colors: [Color(0x1E64DCFF), Color(0x0A0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero card blue variant (vocab)
  static const LinearGradient cardHeroBlue = LinearGradient(
    colors: [Color(0x1A00B4D8), Color(0x0C0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Progress bar
  static const LinearGradient progressActive = LinearGradient(
    colors: [Color(0xFF64DCFF), Color(0xFF00B4D8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppShadows {
  /// Glow cyan cho nút và icon primary
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: const Color(0xFF00B4D8).withValues(alpha: 0.40),
          blurRadius: 22,
          offset: const Offset(0, 8),
          spreadRadius: -3,
        ),
      ];

  /// Glow nhẹ cho avatar / result icon
  static List<BoxShadow> get primaryGlowSoft => [
        BoxShadow(
          color: const Color(0xFF64DCFF).withValues(alpha: 0.25),
          blurRadius: 32,
          offset: const Offset(0, 6),
          spreadRadius: 2,
        ),
      ];

  /// Shadow glass card
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.30),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: const Color(0xFF64DCFF).withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Shadow nhẹ cho row item
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.20),
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
          surface: Color(0xFF0A1F3A),
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
          outline: AppColors.border,
          // Explicitly set all M3 surface variants so nothing defaults to grey
          surfaceTint: Colors.transparent,
          surfaceContainerLowest: Color(0xFF071628),
          surfaceContainerLow: Color(0xFF071628),
          surfaceContainer: Color(0xFF0A1F3A),
          surfaceContainerHigh: Color(0xFF0A1B2E),
          surfaceContainerHighest: Color(0xFF0D2540),
          surfaceDim: Color(0xFF071628),
          surfaceBright: Color(0xFF0D2540),
          onSurfaceVariant: Color(0xBFFFFFFF),
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
              (s) => s.contains(WidgetState.selected)
                  ? AppColors.accent
                  : AppColors.textMuted),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.border),
        ),
        dividerColor: AppColors.border,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF0D2540),
          contentTextStyle:
              const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
