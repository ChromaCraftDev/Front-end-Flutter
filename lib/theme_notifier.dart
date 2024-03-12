// theme_notifier.dart
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme(bool isDarkMode) {
    _currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void setSystemDefaultTheme() {
    final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    _currentTheme = brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}