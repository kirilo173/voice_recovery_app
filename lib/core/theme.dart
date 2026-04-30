import 'package:flutter/material.dart';

// ── Paleta ──────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  static const Color background   = Color(0xFF111412);  // fondo oscuro principal
  static const Color surface      = Color(0xFF1C1F1D);  // tarjetas / inputs
  static const Color surfaceLight = Color(0xFF252825);  // bordes suaves
  static const Color primary      = Color(0xFF4ADE80);  // verde brillante
  static const Color primaryMuted = Color(0xFF2A7A50);  // verde apagado
  static const Color primaryBg    = Color(0xFFD1FAE5);  // verde muy suave (selección)
  static const Color accent       = Color(0xFF34D399);  // verde medio
  static const Color textPrimary  = Color(0xFFF4F4F4);
  static const Color textSecondary= Color(0xFF9CA3AF);
  static const Color textMuted    = Color(0xFF6B7280);
  static const Color warning      = Color(0xFFFBBF24);  // amarillo (estrella vacía)
  static const Color error        = Color(0xFFEF4444);
  static const Color border       = Color(0xFF2D312E);
  static const Color recordRed    = Color(0xFFDC2626);
}

// ── Tema ─────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      background:   AppColors.background,
      surface:      AppColors.surface,
      primary:      AppColors.primary,
      onPrimary:    AppColors.background,
      onBackground: AppColors.textPrimary,
      onSurface:    AppColors.textPrimary,
    ),
    fontFamily: 'Geist',
    textTheme: const TextTheme(
      // Títulos grandes (panel logopeda, nombre de palabra)
      displayLarge: TextStyle(
        fontSize: 40, fontWeight: FontWeight.w700,
        color: AppColors.primary, letterSpacing: -1,
      ),
      // Título de pantalla
      headlineMedium: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w700,
        color: AppColors.primary, letterSpacing: -0.5,
      ),
      // Subtítulo sección
      titleLarge: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      // Cuerpo
      bodyLarge: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 13, fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
      // Labels de inputs
      labelLarge: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: AppColors.textMuted, letterSpacing: 0.8,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(
          fontFamily: 'Geist',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Geist',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.primary),
    ),
  );
}