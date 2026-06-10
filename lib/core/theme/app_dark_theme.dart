import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/theme/app_colors.dart';

class AppDarkTheme {
  // display*: App main title / hero text (Splash, app name)
  // headline*: Screen titles / section headers
  // title*: Items titles (user names, card titles, buttons)
  // body*: Normal text (descriptions, subtitles, paragraphs)
  // label*: Small UI text (chips, tags, timestamps, small buttons)
  //

  static ThemeData get darkTheme => ThemeData(
    // cardColor: AppDarkColors.cardBackground,
    colorScheme: AppDarkColors.colorScheme,
    primaryColor: AppColors.primary,

    // dividerTheme: DividerThemeData(
    //   color: AppDarkColors.colorScheme.onSurface.withValues(alpha: 0.2),
    // ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppDarkColors.colorScheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppDarkColors.colorScheme.surfaceContainerHighest,
      errorStyle: TextStyle(color: AppDarkColors.colorScheme.onError),

      hintStyle: TextStyle(
        // color: scheme.onSurface,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppDarkColors.colorScheme.outline,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppDarkColors.colorScheme.outline,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppDarkColors.colorScheme.outline,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppDarkColors.colorScheme.error,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: AppDarkColors.colorScheme.error,
          width: 1.5,
        ),
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 36,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
      headlineLarge: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 28,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: AppDarkColors.textPrimary,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      titleLarge: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: AppDarkColors.textPrimary.withValues(alpha: 0.5),
        fontFamily: 'Poppins',
        fontSize: 13,
      ),
      labelMedium: TextStyle(
        color: AppColors.primary,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
      bodyLarge:  TextStyle(
        color: AppDarkColors.textPrimary.withValues(alpha: 0.7),
        fontSize: 14,
        fontFamily: 'Poppins',
        height: 1.4
      ),
      bodyMedium: TextStyle(
        color: AppDarkColors.textPrimary.withValues(alpha: 0.7),
        fontSize: 12,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        color: AppDarkColors.textPrimary.withValues(alpha: 0.7),
        fontSize: 10,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
