import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/theme/app_colors.dart';

class AppLightTheme {
  static ThemeData get lightheme => ThemeData(
    primaryColor: AppColors.primary,

    colorScheme: AppLightColors.colorScheme,
    dividerTheme: DividerThemeData(
      color: AppLightColors.colorScheme.onSurface.withValues(alpha: 0.2),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppLightColors.colorScheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppLightColors.colorScheme.surfaceContainerHighest,
      errorStyle: TextStyle(
        color: AppLightColors.colorScheme.onError,
        fontFamily: 'Poppins',
        fontSize: 12,
      ),

      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppLightColors.colorScheme.outline,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppLightColors.colorScheme.outline,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppLightColors.colorScheme.outline,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppLightColors.colorScheme.error,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppLightColors.colorScheme.error,
          width: 1.5,
        ),
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppLightColors.textPrimary,
        fontSize: 34,
        fontWeight: FontWeight.w900,
        fontFamily: 'Poppins',
        letterSpacing: 1.5,
      ),
      headlineLarge: TextStyle(
        color: AppLightColors.textPrimary,
        fontSize: 26,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppLightColors.textPrimary,
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: AppLightColors.textPrimary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      titleLarge: TextStyle(
        color: AppLightColors.textPrimary,
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppLightColors.textPrimary,
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: AppLightColors.textPrimary.withValues(alpha: 0.5),
        fontFamily: 'Poppins',
        fontSize: 12,
      ),
      labelMedium: TextStyle(
        color: AppColors.primary,
        fontSize: 12,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        color: AppLightColors.textPrimary.withValues(alpha: 0.7),
        fontSize: 12,
        fontFamily: 'Poppins',
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        color: AppLightColors.textPrimary..withValues(alpha: 0.7),
        fontSize: 10,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        color: AppLightColors.textPrimary.withValues(alpha: 0.9),
        fontSize: 10,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
