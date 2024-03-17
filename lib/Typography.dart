import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ConfigurePage.dart';
import 'theme_notifier.dart';

class TypographyPage extends StatefulWidget {
  const TypographyPage({Key? key}) : super(key: key);

  @override
  _TypographyPageState createState() => _TypographyPageState();
}

class _TypographyPageState extends State<TypographyPage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Typography Page'),
        actions: <Widget>[
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ConfigurePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutQuart;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(150, 79, 55, 140),
            ),
            child: IconButton(
              icon: const Text('Tr'),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                if (kDebugMode) {
                  print('Apply button pressed');
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.edit,
                      color: Color.fromARGB(150, 79, 55, 140)),
                  SizedBox(width: 15.0),
                  Text(
                    'Apply',
                    style: TextStyle(color: Color.fromARGB(150, 79, 55, 140)),
                  ),
                ],
              ),
            ),
          ),
          ThemeToggle(),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(200, 79, 55, 140)),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'Images/logo2.png',
                width: 1000,
                height: 1000,
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
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildTextStyle('Sans Serif', 'Used for application UI.',
                const TextStyle(fontFamily: 'Sans Serif')),
            const SizedBox(height: 16),
            buildTextStyle('Serif', 'Used for documents.',
                const TextStyle(fontFamily: 'Serif')),
            const SizedBox(height: 16),
            buildTextStyle('Monospace', 'Used for code editors, and terminals.',
                const TextStyle(fontFamily: 'MonoSpace')),
          ],
        ),
      ),
    );
  }

  Widget buildTextStyle(String title, String subtitle, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              subtitle,
              style: TextStyle( fontSize: 16),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'The quick brown fox jumps over the lazy dog',
            style: style.copyWith(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
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
