import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';
import 'package:uniplanet/config/theme/theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static const String _themeKey = 'theme_key';

  ThemeCubit() : super(lightMode) {
    _loadInitialTheme();
  }

  void _loadInitialTheme() async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    final isDarkMode = prefsHelper.getBool(_themeKey) ?? false;
    emit(isDarkMode ? darkMode : lightMode);
  }

  void toggleTheme() async {
    if (state == lightMode) {
      emit(darkMode);
      await _saveThemePreference(true);
    } else {
      emit(lightMode);
      await _saveThemePreference(false);
    }
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    await prefsHelper.saveBool(_themeKey, isDarkMode);
  }
}
