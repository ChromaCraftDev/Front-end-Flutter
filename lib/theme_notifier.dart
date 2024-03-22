// theme_notifier.dart
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = _getSystemDefaultTheme();

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme(bool isDarkMode) {
    _currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  static ThemeData _getSystemDefaultTheme() {
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    return brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
  }

  void setSystemDefaultTheme() {
    _currentTheme = _getSystemDefaultTheme();
    notifyListeners();
  }
}
