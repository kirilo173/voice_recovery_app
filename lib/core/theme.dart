import 'package:flutter/material.dart';

class C {
  C._();
  static const bg        = Color(0xFFF2F2F7);
  static const surface   = Color(0xFFFFFFFF);
  static const txt       = Color(0xFF111111);
  static const txt2      = Color(0xFF6B6B6B);
  static const txt3      = Color(0xFFAAAAAA);
  static const border    = Color(0xFFE0E0E0);
  static const border2   = Color(0xFFCCCCCC);
  static const blue      = Color(0xFF185FA5);
  static const blueLight = Color(0xFF378ADD);
  static const blueBg    = Color(0xFFE6F1FB);
  static const blueDark  = Color(0xFF0C447C);
  static const heroBlue  = Color(0xFF1A6BB5);
  static const teal      = Color(0xFF1D9E75);
  static const tealBg    = Color(0xFFE1F5EE);
  static const tealDark  = Color(0xFF0F6E56);
  static const tealBdr   = Color(0xFF5DCAA5);
  static const tealDeep  = Color(0xFF085041);
  static const amber     = Color(0xFFBA7517);
  static const amberBg   = Color(0xFFFAEEDA);
  static const amberBdr  = Color(0xFFEF9F27);
  static const amberDrk  = Color(0xFF633806);
  static const amberTxt  = Color(0xFF854F0B);
  static const amberDp   = Color(0xFF412402);
  static const red       = Color(0xFFE24B4A);
  static const redBg     = Color(0xFFFCEBEB);
}

class R {
  R._();
  static const double card = 12;
  static const double btn  = 12;
  static const double md   = 10;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.light(
      surface: C.surface,
      primary: C.blue,
      onPrimary: Colors.white,
      onSurface: C.txt,
    ),
    textTheme: const TextTheme(
      titleLarge:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: C.txt),
      titleMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: C.txt),
      bodyLarge:   TextStyle(fontSize: 13, color: C.txt),
      bodyMedium:  TextStyle(fontSize: 12, color: C.txt2),
      bodySmall:   TextStyle(fontSize: 11, color: C.txt2),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: C.txt),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: C.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(R.btn)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: C.txt,
        minimumSize: const Size(double.infinity, 44),
        side: const BorderSide(color: C.border, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(R.btn)),
        textStyle: const TextStyle(fontSize: 13),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: C.border, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: C.border, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: C.blueLight, width: 1.5),
      ),
      hintStyle: const TextStyle(fontSize: 13, color: C.txt3),
    ),
    dividerTheme: const DividerThemeData(color: C.border, thickness: 0.5, space: 0),
  );
}
