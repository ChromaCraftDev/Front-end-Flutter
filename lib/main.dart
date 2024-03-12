import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme_notifier.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'BrowsePage.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import 'ConfigurePage.dart';
import 'Generate.dart';
import 'Profile.dart';
import 'Settings.dart';
import 'Typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  try {
    await Supabase.initialize(
      url: 'https://hgblhxdounljhdwemyoz.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnYmxoeGRvdW5samhkd2VteW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4ODEwMzMsImV4cCI6MjAyNTQ1NzAzM30.kOaLOh5pGrZhAVDfSCd6pYdThxT161IOBeNSuKswZ7g',
    );
  } catch (error) {
    print('Error initializing Supabase: $error');
    // Handle initialization error, e.g., show an error dialog
    return;
  }

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
        themeMode: ThemeMode.system,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/config': (context) => const ConfigurePage(),
          '/ai': (context) => const GenerateAI(),
          '/browse': (context) => const Browser(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/typography': (context) => const TypographyPage(),
        },
      ),
    );
  }
}