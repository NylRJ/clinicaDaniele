import 'package:flutter/material.dart';

const _brand = Color(0xFF6EE7B7);

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _brand,
      onPrimary: Color(0xFF0B0F0E),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF111827),
      secondary: Color(0xFFF3F4F6),
      onSecondary: Color(0xFF111827),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, height: 40/32, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 24, height: 32/24, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 20, height: 28/20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 24/16),
      bodyMedium: TextStyle(fontSize: 14, height: 20/14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _brand,
        foregroundColor: const Color(0xFF0B0F0E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: _brand,
      onPrimary: Color(0xFF0B0F0E),
      surface: Color(0xFF0B0F0E),
      onSurface: Color(0xFFF9FAFB),
      secondary: Color(0xFF111827),
      onSecondary: Color(0xFFF9FAFB),
      error: Color(0xFFF87171),
    ),
    scaffoldBackgroundColor: const Color(0xFF0B0F0E),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, height: 40/32, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 24, height: 32/24, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 20, height: 28/20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 24/16),
      bodyMedium: TextStyle(fontSize: 14, height: 20/14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _brand,
        foregroundColor: const Color(0xFF0B0F0E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
  );
}
