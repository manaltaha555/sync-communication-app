import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/theme/app_colors.dart';

extension AppThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  ColorScheme get scheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  LinearGradient get mainLinearGradient => AppColors.mainLinearGradient;
  LinearGradient get bubbleGradient =>
      isDark ? AppDarkColors.bubbleGradient : AppLightColors.bubbleGradient;
  LinearGradient get navBarGradient =>
      isDark ? AppDarkColors.navBarGradient : AppLightColors.navBarGradient;

  Color get baseColor =>
      isDark ? AppDarkColors.baseColor : AppLightColors.baseColor;
  Color get highlightColor =>
      isDark ? AppDarkColors.highlightColor : AppLightColors.highlightColor;
  Color get circleAvatarColor => isDark
      ? AppDarkColors.circleAvatarColor
      : AppLightColors.circleAvatarColor;
  Color get prefixIconColor =>
      isDark ? AppDarkColors.prefixIconColor : AppLightColors.prefixIconColor;

  Color get cellBg => isDark ? AppDarkColors.cellBg : AppLightColors.cellBg;
  Color get cellBorder =>
      isDark ? AppDarkColors.cellBorder : AppLightColors.cellBorder;
  Color get handleColor =>
      isDark ? AppDarkColors.handleColor : AppLightColors.handleColor;

  BoxShadow get profilePickerShadow => AppColors.profilePickerShadow;
  BoxShadow get pulseShadow => AppColors.pulseShadow;
  SweepGradient get pulseGradient => AppColors.pulseGradient;
  BoxShadow get sectionCardShadow => isDark
      ? AppDarkColors.sectionCardShadow
      : AppLightColors.sectionCardShadow;
}
