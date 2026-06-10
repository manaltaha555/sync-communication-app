import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();
  Box get settingsBox => Hive.box('settings');

  bool isDark() {
    return settingsBox.get("isDark", defaultValue: true);
  }

  Future<void> toggleTheme(bool isDark) async {
    return settingsBox.put("isDark", isDark);
  }
}
