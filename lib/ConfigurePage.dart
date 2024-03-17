import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Typography.dart';
import 'engine/config.dart';
import 'engine/fetch.dart' as fetch;
import 'engine/storage.dart' as storage;
import 'theme_notifier.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({Key? key}) : super(key: key);

  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> with WidgetsBindingObserver {
  final Config config = Config();
  TextEditingController hexController = TextEditingController();
  late SharedPreferences prefs;
  late ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    WidgetsBinding.instance?.addObserver(this);
  }

  void initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadSavedColors();
  }

  void loadSavedColors() {
    config.semanticColors.forEach((option) {
      final savedColor = prefs.getInt(option.name);
      if (savedColor != null) {
        setState(() {
          option.color = Color(savedColor);
        });
      }
    });
  }

  void saveColorToPrefs(ColorOption option) {
    prefs.setInt(option.name, option.color.value);
  }

  void clearSharedPreferences() async {
    await prefs.clear();
  }

  void revertToDefaultColors() {
    config.semanticColors.forEach((option) {
      setState(() {
        option.color = option.original;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      clearSharedPreferences();
    } else if (state == AppLifecycleState.resumed) {
      revertToDefaultColors();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeNotifier = Provider.of<ThemeNotifier>(context);
    final colorScheme = _themeNotifier.currentTheme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Colour Configure'),
        actions: <Widget>[
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(150, 79, 55, 140),
            ),
            child: IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {},
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Text('Tr'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const TypographyPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _applyButtonPressed,
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
          ThemeToggle(), // Adding the theme toggle button
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
      body: Center(
        child: Wrap(
          runAlignment: WrapAlignment.center,
          runSpacing: 20,
          spacing: 10,
          children:
              config.semanticColors.map(_buildButton).toList(growable: false),
        ),
      ),
    );
  }

  Widget _buildButton(ColorOption option) {
    return GestureDetector(
      onTap: () {
        _showColorPickerDialog(option);
      },
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  option.name,
                  style: const TextStyle(color: Colors.white),
                  softWrap: true,
                ),
                Text(
                  option.description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: option.color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(ColorOption option) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: option.color,
                  onColorChanged: (newColor) => setState(() {
                    option.color = newColor;
                    hexController.text = colorToHex(option.color,
                        includeHashSign: true, enableAlpha: false);
                  }),
                  pickerAreaHeightPercent: 0.8,
                  enableAlpha: false,
                ),
                TextFormField(
                  controller: hexController,
                  decoration:
                      const InputDecoration(labelText: 'Hex Color Code'),
                  onChanged: (String hex) => setState(() {
                    option.color = colorFromHex(hex)!;
                  }),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () => setState(() {
                        option.color = option.original;
                        hexController.text = colorToHex(option.original,
                            includeHashSign: true, enableAlpha: false);
                      }),
                      child: const Text('Revert'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    saveColorToPrefs(option);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _applyButtonPressed() {
    config.semanticColors.forEach((option) {
      saveColorToPrefs(option);
    });
    if (kDebugMode) {
      print('Apply button pressed');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    hexController.dispose();
    super.dispose();
  }
}

class ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = _themeNotifier.currentThemeMode == ThemeMode.dark;
    return IconButton(
      icon: Icon(isDarkMode ? Icons.brightness_2_rounded : Icons.brightness_7_rounded),
      onPressed: () {
        _themeNotifier.toggleTheme();
      },
    );
  }
}
