import 'package:chroma_craft_1/BrowsePage.dart';
import 'package:chroma_craft_1/ConfigurePage.dart';
import 'package:chroma_craft_1/Generate.dart';
import 'package:chroma_craft_1/LoginPage.dart';
import 'package:chroma_craft_1/Profile.dart';
import 'package:chroma_craft_1/RegisterPage.dart';
import 'package:chroma_craft_1/Settings.dart';
import 'package:chroma_craft_1/Typography.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//Remove Debug tag
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/config': (context) => const ConfigurePage(),
        '/ai': (context) => const GenerateAI(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/typograpy': (context) => const TypographyPage(),
      },
    );
  }
}