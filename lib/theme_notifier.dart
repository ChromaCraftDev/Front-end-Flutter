import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode _themeMode;
  late File _themeFile;

  ThemeNotifier({ThemeMode initialThemeMode = ThemeMode.light}) {
    _lightTheme = ThemeData.light();
    _darkTheme = ThemeData.dark();
    _themeMode = initialThemeMode;
    _loadThemeFromFile();
  }

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeMode get currentThemeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeToFile();
    notifyListeners();
  }

  ThemeData get currentTheme {
    if (_themeMode == ThemeMode.dark) {
      return _darkTheme;
    } else {
      return _lightTheme;
    }
  }

  Future<void> _loadThemeFromFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    _themeFile = File('${directory.path}/theme.txt');
    if (_themeFile.existsSync()) {
      final String themeString = await _themeFile.readAsString();
      _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners(); // Notify listeners to rebuild with the loaded theme
    }
  }

  Future<void> _saveThemeToFile() async {
    await _themeFile.writeAsString(_themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
