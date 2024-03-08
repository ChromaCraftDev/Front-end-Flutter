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
import 'package:window_manager/window_manager.dart';
import 'theme_notifier.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
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
          '/browse':(context) => const Browser(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/typography': (context) => const TypographyPage(),
          
        },
      ),
    );
  }
}
