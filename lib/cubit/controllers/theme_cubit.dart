import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/cubit/state/theme_state.dart';
import 'package:sync_communication_app/services/theme_service.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());
    final ThemeService _themeService = ThemeService();


  /// load saved theme from Hive
  Future<void> loadFromBox() async {
    final isDark = _themeService.isDark();
    emit(state.copyWith(isDark: isDark));
  }

  /// toggle + save
  Future<void> toggleTheme() async {
    final newValue = !state.isDark;

    emit(state.copyWith(isDark: newValue));

    await _themeService.toggleTheme(newValue);
  }
}