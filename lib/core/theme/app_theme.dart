import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[100],
    dividerColor: Colors.grey,
    iconTheme: const IconThemeData(color: Colors.black54),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black54),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueAccent[200],
    cardColor: Colors.grey[800], // Более светлый серый для контраста
    scaffoldBackgroundColor: Colors.grey[950], // Легкий оттенок вместо черного
    dividerColor: Colors.grey[800],
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      elevation: 1,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
    ),
    cardTheme: CardThemeData(
      elevation: 8, // Увеличиваем тень
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
  );
}
