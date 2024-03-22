

import 'package:chromacraft/Setting.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Settings'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
              color: Color.fromARGB(200, 79, 55, 140)),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'Images/logo2.PNG',
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
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
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
      body: SettingsContent(),
    );
  }
}

