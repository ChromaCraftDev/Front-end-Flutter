import 'package:chroma_craft_1/BrowsePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chroma_craft_1/LoginPage.dart';
import 'package:chroma_craft_1/RegisterPage.dart';
import 'package:chroma_craft_1/ConfigurePage.dart';
import 'package:chroma_craft_1/Generate.dart';
import 'package:chroma_craft_1/Profile.dart';
import 'package:chroma_craft_1/Settings.dart';
import 'package:chroma_craft_1/Typography.dart';
import 'theme_notifier.dart'; // Import the ThemeNotifier class
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) => MaterialApp(
        debugShowCheckedModeBanner: false, // Remove Debug tag
        theme: themeNotifier.currentTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) =>  RegisterPage(),
          '/config': (context) => const ConfigurePage(),
          '/ai': (context) => const GenerateAI(),
          '/testweb':(context) => const Browse(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/typography': (context) => const TypographyPage(),
        },
      ),
    );
  }
}
