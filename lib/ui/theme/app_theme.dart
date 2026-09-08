import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// DocuMind design tokens — modern AI SaaS (indigo / soft purple).
class AppColors {
  AppColors._();

  static const indigo = Color(0xFF3B5BDB);
  static const indigoDeep = Color(0xFF2F4AC0);
  static const indigoSoft = Color(0xFFE8EDFF);
  static const purple = Color(0xFF7C5CFC);
  static const purpleSoft = Color(0xFFF1ECFF);
  static const bg = Color(0xFFF5F7FB);
  static const bgBlue = Color(0xFFEEF2FF);
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1E293B);
  static const inkSoft = Color(0xFF64748B);
  static const line = Color(0xFFE2E8F0);
  static const success = Color(0xFF16A34A);
  static const successSoft = Color(0xFFDCFCE7);
  static const error = Color(0xFFDC2626);
  static const errorSoft = Color(0xFFFEE2E2);
  static const amber = Color(0xFFD97706);

  // Back-compat aliases used by older widgets
  static const teal = indigo;
  static const tealBright = purple;
  static const tealMuted = indigoSoft;
  static const mist = bg;
  static const mistDeep = bgBlue;
  static const rose = error;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final text = GoogleFonts.interTextTheme();

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.indigo,
        brightness: Brightness.light,
        primary: AppColors.indigo,
        onPrimary: Colors.white,
        secondary: AppColors.purple,
        surface: AppColors.paper,
        onSurface: AppColors.ink,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );

    return base.copyWith(
      textTheme: text.copyWith(
        displayLarge: text.displayLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
        ),
        headlineLarge: text.headlineLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
          fontSize: 28,
        ),
        headlineMedium: text.headlineMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        titleLarge: text.titleLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleMedium: text.titleMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: text.bodyLarge?.copyWith(
          color: AppColors.inkSoft,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: text.bodyMedium?.copyWith(
          color: AppColors.inkSoft,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: text.bodySmall?.copyWith(
          color: AppColors.inkSoft,
          fontSize: 13,
        ),
        labelLarge: text.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      cardTheme: CardThemeData(
        color: AppColors.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.indigo,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: AppColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.indigo, width: 1.6),
        ),
        hintStyle: text.bodyMedium?.copyWith(
          color: AppColors.inkSoft.withValues(alpha: 0.7),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerColor: AppColors.line,
    );
  }
}

class AtmosphereBackground extends StatelessWidget {
  const AtmosphereBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8FAFF),
            AppColors.bg,
            Color(0xFFF3F0FF),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _Blob(
              size: 280,
              color: AppColors.indigo.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _Blob(
              size: 300,
              color: AppColors.purple.withValues(alpha: 0.07),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class DmCard extends StatelessWidget {
  const DmCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.paper,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
