import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Brightness systemBrightness = window.platformBrightness;
  ThemeMode themeMode =
      systemBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

  runApp(MyApp(initialThemeMode: themeMode));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({Key? key, required this.initialThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(initialThemeMode: initialThemeMode),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: themeProvider.getTheme(),
            darkTheme: themeProvider.getDarkTheme(),
            themeMode: themeProvider.getThemeMode(),
            home: ThemeToggleScreen(),
          );
        },
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _lightTheme = ThemeData.light();
  ThemeData _darkTheme = ThemeData.dark();
  ThemeMode _themeMode;

  ThemeProvider({required ThemeMode initialThemeMode})
      : _themeMode = initialThemeMode;

  ThemeData getTheme() => _lightTheme;
  ThemeData getDarkTheme() => _darkTheme;
  ThemeMode getThemeMode() => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ThemeToggleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Toggle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Toggle the theme',
              style: Theme.of(context).textTheme.headline5,
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Switch(
                  value: themeProvider.getThemeMode() == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
