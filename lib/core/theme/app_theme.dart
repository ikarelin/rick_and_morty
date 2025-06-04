import 'package:flutter/material.dart';

class AppTheme {
  // Светлая тема
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent, // Основной цвет для активных элементов
    scaffoldBackgroundColor: Colors.white, // Фон экрана
    cardColor: Colors.grey[100], // Цвет карточек персонажей
    dividerColor: Colors.grey[300], // Цвет разделителей
    iconTheme: const IconThemeData(
      color: Colors.black87, // Цвет иконок
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
      headlineSmall: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: Colors.black54,
        fontSize: 10,
      ), // Для навигации
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white.withOpacity(0.3), // Полупрозрачный фон
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.black54.withOpacity(0.5),
    ),
  );

  // Темная тема
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueAccent, // Сохраняем тот же основной цвет
    scaffoldBackgroundColor: Colors.grey[900], // Темный фон
    cardColor: Colors.grey[800], // Цвет карточек в темной теме
    dividerColor: Colors.grey[700], // Цвет разделителей
    iconTheme: const IconThemeData(
      color: Colors.white70, // Цвет иконок
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white60, fontSize: 14),
      headlineSmall: TextStyle(
        color: Colors.white70,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: Colors.white60,
        fontSize: 10,
      ), // Для навигации
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black.withOpacity(0.3), // Полупрозрачный фон
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white60.withOpacity(0.5),
    ),
  );
}
