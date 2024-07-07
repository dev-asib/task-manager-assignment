import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';

ThemeData lightThemeData() {
  return ThemeData(
    brightness: Brightness.light,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 0.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: AppColors.white,
        hintStyle: TextStyle(color: Colors.grey.shade400)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: AppColors.white,
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}


ThemeData darkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 0.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: AppColors.white,
        hintStyle: TextStyle(color: Colors.grey.shade400)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: AppColors.white,
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
