import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class GenerateAI extends StatefulWidget {
  const GenerateAI({Key? key}) : super(key: key);

  @override
  _GenerateAIState createState() => _GenerateAIState();
}

class _GenerateAIState extends State<GenerateAI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Generate Template'),
        actions: <Widget>[
          ThemeToggle(),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(200, 79, 55, 140),
              ),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'Images/logo2.png',
                width: 1000, // Adjust width as needed
                height: 1000, // Adjust height as needed
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Configure'),
                    onTap: () {
                      Navigator.pushNamed(context, '/config');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.web),
                    title: const Text('Browse Template'),
                    onTap: () {
                      Navigator.pushNamed(context, '/browse');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.create),
                    title: const Text('Generate Template'),
                    onTap: () {
                      Navigator.pushNamed(context, '/ai');
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle), // Icon for Profile
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.currentThemeMode == ThemeMode.dark;
    return IconButton(
      icon: Icon(isDarkMode ? Icons.brightness_2_rounded : Icons.brightness_7_rounded),
      onPressed: () {
        themeNotifier.toggleTheme();
      },
    );
  }
}
