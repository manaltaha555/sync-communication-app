import 'package:flutter/material.dart';

class ThemeState {
  final bool isDark;
  final ThemeMode themeMode;

  const ThemeState({
    this.isDark = true,
  }) : themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeState copyWith({bool? isDark}) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
    );
  }
}