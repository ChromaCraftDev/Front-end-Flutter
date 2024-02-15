import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum AppTheme { light, dark }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme _currentTheme = AppTheme.light;

  void _toggleTheme() {
    setState(() {
      _currentTheme = _currentTheme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    });
  }

  ThemeData _getTheme() {
    switch (_currentTheme) {
      case AppTheme.light:
        return ThemeData.light();
      case AppTheme.dark:
        return ThemeData.dark();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _getTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('System-wide Theming Tool'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 2,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Toggle Theme: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  ElevatedButton(
                    onPressed: _toggleTheme,
                    child: Text(
                      _currentTheme == AppTheme.light ? 'Dark' : 'Light',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
