import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Провайдер для управления темой
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    // Загружаем сохраненную тему из Hive при инициализации
    final box = Hive.box('settings');
    final savedTheme = box.get('themeMode', defaultValue: 'system');
    state = _mapStringToThemeMode(savedTheme);
  }

  // Переключение темы и сохранение в Hive
  void setTheme(ThemeMode themeMode) {
    state = themeMode;
    final box = Hive.box('settings');
    box.put('themeMode', _mapThemeModeToString(themeMode));
  }

  // Преобразование строки в ThemeMode
  ThemeMode _mapStringToThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // Преобразование ThemeMode в строку для сохранения
  String _mapThemeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}
