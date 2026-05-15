import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand blues (matching HTML: #185FA5, #378ADD, #E6F1FB)
  static const blue900 = Color(0xFF042C53);
  static const blue800 = Color(0xFF0C447C);
  static const blue600 = Color(0xFF185FA5);
  static const blue400 = Color(0xFF378ADD);
  static const blue200 = Color(0xFF85B7EB);
  static const blue100 = Color(0xFFB5D4F4);
  static const blue50  = Color(0xFFE6F1FB);

  // Teal / success (#1D9E75, #E1F5EE)
  static const teal800 = Color(0xFF085041);
  static const teal600 = Color(0xFF0F6E56);
  static const teal400 = Color(0xFF1D9E75);
  static const teal100 = Color(0xFF9FE1CB);
  static const teal50  = Color(0xFFE1F5EE);

  // Amber / warning (#BA7517, #FAEEDA)
  static const amber800 = Color(0xFF633806);
  static const amber600 = Color(0xFF854F0B);
  static const amber400 = Color(0xFFBA7517);
  static const amber100 = Color(0xFFFAC775);
  static const amber50  = Color(0xFFFAEEDA);

  // Red / danger (#E24B4A, #FCEBEB)
  static const red600 = Color(0xFFA32D2D);
  static const red400 = Color(0xFFE24B4A);
  static const red50  = Color(0xFFFCEBEB);

  // Purple (#534AB7, #EEEDFE)
  static const purple800 = Color(0xFF26215C);
  static const purple600 = Color(0xFF534AB7);
  static const purple200 = Color(0xFFAFA9EC);
  static const purple50  = Color(0xFFEEEDFE);

  // Coral (#993C1D, #FAECE7)
  static const coral600 = Color(0xFF993C1D);
  static const coral50  = Color(0xFFFAECE7);

  // Neutral grays
  static const gray50  = Color(0xFFF1EFE8);
  static const gray200 = Color(0xFFB4B2A9);
  static const gray400 = Color(0xFF888780);
  static const gray600 = Color(0xFF5F5E5A);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue600,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F4F0),
    fontFamily: 'SF Pro Text', // iOS feel; falls back to system
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blue600,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0x26000000), width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F4F0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x26000000), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x26000000), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.blue400, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
  );
}

// ─── Text style helpers ───────────────────────────────────────────────────────
class AppText {
  AppText._();

  static const sectionLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.gray400,
    letterSpacing: 0.6,
  );

  static const cardTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF1C1C1E),
  );

  static const cardSub = TextStyle(
    fontSize: 11,
    color: AppColors.gray400,
  );

  static const bigNumber = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Color(0xFF1C1C1E),
  );
}