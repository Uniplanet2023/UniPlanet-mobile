import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet/theme/theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static const String _themeKey = 'theme_key';

  ThemeCubit() : super(lightMode) {
    _loadInitialTheme();
  }

  void _loadInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }
}
