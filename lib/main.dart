import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum AppTheme { logo, text }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme _currentTheme = AppTheme.logo;

  void _toggleTheme() {
    setState(() {
      _currentTheme = _currentTheme == AppTheme.logo ? AppTheme.text : AppTheme.logo;
    });
  }

  ThemeData _getTheme() {
    switch (_currentTheme) {
      case AppTheme.logo:
        return ThemeData.light();
      case AppTheme.text:
        return ThemeData.dark();
    }
  }

  Color _getIconColor(BuildContext context) {
    return _currentTheme == AppTheme.logo ? Colors.orange : Colors.white;
  }

  Color _getBorderColor(BuildContext context) {
    return _currentTheme == AppTheme.logo ? Colors.black : Colors.white;
  }

  IconData _getIconData() {
    return _currentTheme == AppTheme.logo ? Icons.wb_sunny : Icons.nightlight_round;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _getTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ChromaCraft'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 2,
              right: 10,
              child: GestureDetector(
                onTap: _toggleTheme,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getBorderColor(context),
                      width: 2.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _getIconData(),
                    color: _getIconColor(context),
                    size: 30, // Increased size of the logo
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
