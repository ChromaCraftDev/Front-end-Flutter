import 'dart:io';

import 'package:chromacraft/engine/storage.dart';
import 'package:chromacraft/theme_notifier.dart';
import 'package:flutter/foundation.dart';
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
  List<TemplateMetadata>? _templates;
  var _loaded = false;
  String email = '';
  String _firstName = '';
  String _lastName = '';
  String _selectedProfilePicture = ' ';

  @override
  void initState() {
    super.initState();
    _getEmailFromStorage();
    reloadTemplates();
  }

  void reloadTemplates() {
    setState(() {
      _loaded = false;
    });
    fetchTemplatesList().then((value) {
      setState(() {
        _templates = value;
        _loaded = true;
      });
    });
  }

  Future<void> _getEmailFromStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/auth/userData.txt');
      final savedEmail = await file.readAsString();
      setState(() {
        email = savedEmail;
      });
      _getUserData();
      _loadSelectedProfilePicture();
    } catch (e) {
      if (kDebugMode) print('Error reading email from file: $e');
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
          _lastName = user['last_name'] as String;
        });
      } else {
        if (kDebugMode) print('No user data found for this email: $email');
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching user data: $e');
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
      if (kDebugMode) print('Error loading image ID from file: $e');
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reloadTemplates,
          )
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Align(
            alignment: Alignment.topCenter,
            child: !_loaded
                ? Text(
                    'Loading templates...',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: _templates!.map(_buildTemplateCard).toList(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(TemplateMetadata meta) {
    final action = FutureBuilder(
        future: statTemplate(meta.name, _templates!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return switch (snapshot.data!) {
              TemplateStat.remoteNotFound => const Icon(Icons.error),
              TemplateStat.notFound => IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => downloadOrUpdateTemplate(meta.name)
                      .then((_) => setState(() => ())),
                ),
              TemplateStat.needsUpdate => IconButton(
                  icon: const Icon(Icons.update),
                  onPressed: () => downloadOrUpdateTemplate(meta.name)
                      .then((_) => setState(() => ())),
                ),
              TemplateStat.ok => IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => uninstallTemplate(meta.name)
                      .then((_) => setState(() => ())),
                ),
            };
          }
        });
    return IntrinsicWidth(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                      Text(
                        meta.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ] +
                    (meta.platforms.contains(Platform.current())
                        ? [action]
                        : []),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: 500,
                  child: Image.network(
                    meta.previewUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Preview image not available."),
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    child: const Text("Project Homepage"),
                    onPressed: () => launchUrl(meta.projectHomepage),
                  ),
                  Row(children: meta.platforms.map(Platform.icon).toList()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
