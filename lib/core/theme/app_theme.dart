import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Цвета для светлой темы (на основе референса)
  static const background = Color(0xFFF0EEFF);
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);
  static const accent = Color(0xFF5B6BF8);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF39C12);
  static const error = Color(0xFFE74C3C);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
}

class AppTheme {
  // Название геттера 'dark' сохранено для совместимости с main.dart
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light, // Переключено на светлую тему
        fontFamily: GoogleFonts.nunito().fontFamily,
        scaffoldBackgroundColor: AppColors.background,

        colorScheme: const ColorScheme.light(
          primary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
          onSurface: AppColors.textPrimary,
        ),

        // Использование CardThemeData для устранения ошибки компиляции
        cardTheme: const CardThemeData(
          color: AppColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: AppColors.border, width: 1),
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.nunito().fontFamily,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: GoogleFonts.nunito().fontFamily,
            ),
          ),
        ),

        // ПРИМЕНЕННАЯ ПРАВКА: Добавлена базовая тема в конструктор шрифтов
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.light().textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(color: AppColors.textPrimary),
          bodyMedium: const TextStyle(color: AppColors.textPrimary),
          titleLarge: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
