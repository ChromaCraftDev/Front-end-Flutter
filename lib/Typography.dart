import 'package:chroma_craft_1/ConfigurePage.dart';
import 'package:flutter/material.dart';

class TypographyPage extends StatefulWidget {
  const TypographyPage({Key? key}) : super(key: key);

  @override
  _TypographyPageState createState() => _TypographyPageState();
}

class _TypographyPageState extends State<TypographyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typography Configure'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.palette), // replace with your palette icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigurePage()),
              );
            },
          ),
          IconButton(
            icon: const Text('Tr'), // replace with your "Tr" icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TypographyPage()),
              );
            },
          ),
        ],
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
                Navigator.pushNamed(context, '/testweb');
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
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildTextStyle('Sans Serif', 'Used for application UI.', const TextStyle(fontFamily: 'Sans Serif')),
            const SizedBox(height: 16),
            buildTextStyle('Serif', 'Used for documents.', const TextStyle(fontFamily: 'Serif')),
            const SizedBox(height: 16),
            buildTextStyle('Monospace', 'Used for code editors, and terminals.', const TextStyle(fontFamily: 'MonoSpace')),
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
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.black, fontSize: 16),
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
