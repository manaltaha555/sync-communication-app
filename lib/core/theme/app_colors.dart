import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFB00020);

  static BoxShadow pulseShadow = BoxShadow(
    color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
    blurRadius: 40,
    spreadRadius: 10,
  );
  static const SweepGradient pulseGradient = SweepGradient(
    colors: [primary, secondary, success, primary],
  );
  static const LinearGradient mainLinearGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final BoxShadow profilePickerShadow = BoxShadow(
    color: primary.withValues(alpha: 0.35),
    blurRadius: 16,
    spreadRadius: 1,
  );
}
//?color scheme
// ── Primary ──────────────────────────────────────────────────
// primary              → Main brand color — buttons, active icons, selected states
// onPrimary            → Text/icons on top of primary color
// primaryContainer     → Softer version of primary — hover states, containers
// onPrimaryContainer   → Text/icons on top of primaryContainer

// ── Secondary ────────────────────────────────────────────────
// secondary            → Secondary actions, chips, tags, accents
// onSecondary          → Text/icons on top of secondary color
// secondaryContainer   → Softer secondary — subtle highlights
// onSecondaryContainer → Text/icons on top of secondaryContainer

// ── Tertiary ─────────────────────────────────────────────────
// tertiary             → Optional third accent — badges, special highlights
// onTertiary           → Text/icons on top of tertiary
// tertiaryContainer    → Softer tertiary container
// onTertiaryContainer  → Text/icons on top of tertiaryContainer

// ── Surface ──────────────────────────────────────────────────
// surface                  → Cards, bottom sheets, dialogs, drawers background
// onSurface                → Text/icons on top of surface (main content color)
// surfaceContainerLow      → Slightly elevated surface — list tiles, app bars
// surfaceContainer         → Default container — input fields, chips background
// surfaceContainerHigh     → More prominent container — selected items, hover
// surfaceContainerHighest  → Strongest container — subtle separators
// onSurfaceVariant         → Muted text/icons on surface — subtitles, placeholders

// ── Background ───────────────────────────────────────────────
// background           → Page/scaffold background (deprecated → prefer surface)
// onBackground         → Text/icons on background (deprecated)

// ── Outline ──────────────────────────────────────────────────
// outline              → Borders, dividers, input borders
// outlineVariant       → Softer outline — subtle separators, disabled borders

// ── Error ────────────────────────────────────────────────────
// error                → Error states — validation, alerts, destructive actions
// onError              → Text/icons on top of error color
// errorContainer       → Softer error container — error banners background
// onErrorContainer     → Text/icons on top of errorContainer

// ── Inverse ──────────────────────────────────────────────────
// inverseSurface       → Inverted surface — snackbars, tooltips background
// onInverseSurface     → Text/icons on top of inverseSurface
// inversePrimary       → Primary color on inverted surface — snackbar action button

// ── Scrim & Shadow ───────────────────────────────────────────
// scrim                → Overlay behind modals, bottom sheets, drawers
// shadow               → Shadow color for elevated widgets

class AppDarkColors {
  // Text colors
  static const Color textPrimary = Colors.white;
  static final Color dempedColor = Colors.white.withValues(alpha: 0.4);
  // UI colors
  static final Color cardBackground = Colors.white.withValues(alpha: 0.05);
  static final Color borderColor = Colors.white.withValues(alpha: 0.08);
  static final dividerColor = Colors.white.withValues(alpha: 0.08);
  static const Color sheetColor = Color(0xFF0F1623);
  static final Color textInputFieldColor = Colors.white.withValues(alpha: 0.1);
  static final Color appBarColor = Color(0XFF15112B);
  static final Color circleAvatarColor = Color(0xFF131A2E);

  static final Color baseColor = const Color(0xFF161E31);
  static final Color highlightColor = const Color(0xFF242F4D);

  static final Color cellBg = Colors.white.withValues(alpha: 0.06);
  static final Color cellBorder = Colors.white.withValues(alpha: 0.08);
  static final Color handleColor = Colors.white.withValues(alpha: 0.2);

  static final Color prefixIconColor = Colors.white.withValues(alpha: 0.5);
  static final BoxShadow sectionCardShadow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static final LinearGradient bubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withValues(alpha: 0.12),
      Colors.white.withValues(alpha: 0.06),
      Colors.white.withValues(alpha: 0.03),
    ],
    stops: const [0.0, 0.5, 1.0],
  );
  static final LinearGradient navBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B1634), Color(0xFF15112B)],
  );
  // ColorScheme
  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,

    surface: cardBackground,
    onSurface: textPrimary,
    surfaceContainerHighest: textInputFieldColor,
    surfaceContainerLow: appBarColor,
    onSurfaceVariant: dempedColor,

    primary: AppColors.primary,
    onPrimary: textPrimary,

    primaryContainer: AppColors.primary.withValues(alpha: 0.15),
    onPrimaryContainer: AppColors.primary,

    secondary: AppColors.secondary,
    onSecondary: textPrimary,

    tertiary: AppColors.success,
    onTertiary: textPrimary,

    error: AppColors.error, //Color(0xFFCF6679)
    onError: textPrimary,

    outline: borderColor,
    outlineVariant: dividerColor,

    inverseSurface: AppColors.primary.withValues(alpha: 0.85),
    onInverseSurface: Colors.white,

    shadow: AppColors.primary.withValues(alpha: 0.06),
    scrim: sheetColor,
  );
}

class AppLightColors {
  // Text colors
  static const Color textPrimary = Color(0xFF111844);
  static final Color dempedColor = textPrimary.withValues(alpha: 0.4);

  // UI colors
  static final Color cardBackground = Colors.white.withValues(alpha: 0.85);
  static final Color dividerColor = Colors.black.withValues(alpha: 0.08);

  static final Color borderColor = Colors.black.withValues(alpha: 0.15);
  static const Color sheetColor = Color(0xFFEAEAEA);
  static const Color textInputFieldColor = Color(0xFFF8FAFC);
  static const Color appBarColor = Color(0XFFF5EFFF);
  static final Color circleAvatarColor = Colors.white;

  static final Color baseColor = const Color(0xFFE8EAF6);
  static final Color highlightColor = const Color(0xFFF5F6FF);

  static final Color cellBg = Colors.black.withValues(alpha: 0.04);
  static final Color cellBorder = Colors.black.withValues(alpha: 0.08);
  static final Color handleColor = Colors.black.withValues(alpha: 0.15);

  static final Color prefixIconColor = Colors.black.withValues(alpha: 0.5);

  static final BoxShadow sectionCardShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 8,
    spreadRadius: 0,
    offset: const Offset(0, 2),
  );

  static final LinearGradient bubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.black.withValues(alpha: 0.08),
      Colors.black.withValues(alpha: 0.04),
      Colors.black.withValues(alpha: 0.02),
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  static final LinearGradient navBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF4F6FB), Color(0xFFE9EDF5)],
  );

  // ColorScheme
  // ColorScheme
  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    surface: cardBackground,
    onSurface: textPrimary,

    surfaceContainerLow: appBarColor,
    surfaceContainer: const Color(0xFFF8FAFC),
    surfaceContainerHigh: const Color(0xFFF1F5F9),
    surfaceContainerHighest: textInputFieldColor,

    onSurfaceVariant: dempedColor,

    primary: AppColors.primary,
    onPrimary: Colors.white,

    primaryContainer: AppColors.primary.withValues(alpha: 0.12),
    onPrimaryContainer: AppColors.primary,

    secondary: AppColors.secondary,
    onSecondary: Colors.white,

    secondaryContainer: AppColors.secondary.withValues(alpha: 0.12),
    onSecondaryContainer: AppColors.secondary,

    tertiary: AppColors.success,
    onTertiary: Colors.white,

    tertiaryContainer: AppColors.success.withValues(alpha: 0.12),
    onTertiaryContainer: AppColors.success,

    error: AppColors.error,
    onError: AppColors.error,

    errorContainer: AppColors.error.withValues(alpha: 0.12),
    onErrorContainer: AppColors.error,

    outline: borderColor,
    outlineVariant: dividerColor,

    inverseSurface: const Color(0xFF1E293B),
    onInverseSurface: Colors.white,

    inversePrimary: AppColors.primary,

    shadow: Colors.black.withValues(alpha: 0.08),
    scrim: sheetColor,
  );
}
