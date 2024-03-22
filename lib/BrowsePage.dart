import 'dart:io';

import 'package:chromacraft/theme_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'engine/fetch.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'engine/meta.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  State<Browser> createState() => _Browser();
}

class _Browser extends State<Browser> {
  late final List<TemplateMetadata> _templates;
  var _loaded = false;
  String email = '';
  String _firstName = '';
  String _lastName = '';
  String _selectedProfilePicture = ' ';

  @override
  void initState() {
    super.initState();
    _getEmailFromStorage();
    fetchTemplatesList().then((value) {
      setState(() {
        _templates = value;
        _loaded = true;
      });
      for (final it in value) {
        fetchTemplate(it.name);
      }
    });
  }

  Future<void> _getEmailFromStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userData.txt');
      final savedEmail = await file.readAsString();
      setState(() {
        email = savedEmail;
      });
      _getUserData();
      _loadSelectedProfilePicture();
    } catch (e) {
      print('Error reading email from file: $e');
    }
  }

  Future<void> _getUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('first_name , last_name')
          .eq('email', email);

      if (response != null && response.isNotEmpty) {
        final user = response[0];
        setState(() {
          _firstName = user['first_name'] as String;
          if (user['last_name'] as String == null) {
            _lastName = " ";
          } else {
            _lastName = user['last_name'] as String;
          }
        });
      } else {
        print('No user data found for this email: $email');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _loadSelectedProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedProfilePicture = prefs.getString('selectedProfilePicture');
    if (savedProfilePicture != null) {
      setState(() {
        _selectedProfilePicture = savedProfilePicture;
      });
    }

    // Load image ID from text file
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('image_id')
          .eq('email', email);

      final user = response[0];
      setState(() {
        _selectedProfilePicture = user['image_id'] as String;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading image ID from file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = context.read<ThemeNotifier>();
    final String logoImagePath =
        themeNotifier.currentTheme.brightness == Brightness.dark
            ? 'Images/logo.PNG'
            : 'Images/logo2.PNG';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Browse Template'),
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
              decoration:
                  const BoxDecoration(color: Color.fromARGB(200, 79, 55, 140)),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                logoImagePath,
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(_selectedProfilePicture),
                      ),
                      const SizedBox(
                          width: 5), // Add some spacing between image and text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$_firstName $_lastName',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            email,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: !_loaded
          ? const Center(
              child: Text(
                'Loading templates...',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: _templates.map(_buildTemplateCard).toList(),
              ),
            ),
    );
  }

  Widget _buildTemplateCard(TemplateMetadata meta) {
    return IntrinsicWidth(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Image(image: NetworkImage(meta.previewUrl), width: 500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Text("Project Homepage"),
                  onTap: () => launchUrl(meta.projectHomepage),
                ),
                Column(
                  children: meta.platforms
                      .map((it) => switch (it) {
                            Platform.windows =>
                              const FaIcon(FontAwesomeIcons.windows),
                            Platform.macos =>
                              const FaIcon(FontAwesomeIcons.apple),
                            Platform.linux =>
                              const FaIcon(FontAwesomeIcons.linux),
                            Platform.invalid =>
                              const FaIcon(FontAwesomeIcons.exclamation),
                          })
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
