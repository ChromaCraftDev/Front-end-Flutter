import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkThemeEnabled = false;

  void _toggleTheme(bool value) {
    setState(() {
      _darkThemeEnabled = value;
      // Update theme based on the toggle value
      if (_darkThemeEnabled) {
        // Dark theme
        _applyTheme(ThemeData.dark());
      } else {
        // Light theme
        _applyTheme(ThemeData.light());
      }
    });
  }

  void _applyTheme(ThemeData theme) {
    // You can further customize the theme based on your requirements
    // For example, you might want to change colors, fonts, etc.
    // Here, we are just updating the whole app's theme
    MaterialApp app = MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsContent(_toggleTheme),
      ),
    );
    // Replace the current route with the new themed app
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => app));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(60.0),
              child: Text('ChromaCraft', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24,)),
            ),
            ListTile(
              title: const Text('Configure'),
              onTap: () {
                Navigator.pushNamed(context, '/config');
              },
            ),
            ListTile(
              title: const Text('Browse Template'),
              onTap: () {
                Navigator.pushNamed(context, '/browse');
              },
            ),
            ListTile(
              title: const Text('Generate Template'),
              onTap: () {
                Navigator.pushNamed(context, '/ai');
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      body: SettingsContent(_toggleTheme),
    );
    
  }
}

class SettingsContent extends StatelessWidget {
  final Function(bool) onThemeChanged;

  const SettingsContent(this.onThemeChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: Theme.of(context).textTheme.headline6,
          ),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: false, // You should get the actual theme value from your app settings
            onChanged: onThemeChanged,
          ),
        ],
      ),
    );
  }
}
