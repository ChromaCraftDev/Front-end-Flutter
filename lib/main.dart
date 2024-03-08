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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'theme_notifier.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  Supabase.initialize(
    url: 'https://hgblhxdounljhdwemyoz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnYmxoeGRvdW5samhkd2VteW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4ODEwMzMsImV4cCI6MjAyNTQ1NzAzM30.kOaLOh5pGrZhAVDfSCd6pYdThxT161IOBeNSuKswZ7g',
  );
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
          '/login': (context) =>  LoginPage(),
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
