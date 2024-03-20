import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flex_color_picker/flex_color_picker.dart";
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

class _ConfigurePageState extends State<ConfigurePage>
    with WidgetsBindingObserver {
  late SharedPreferences prefs;

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
    for (var option in config.semanticColors) {
      final savedColor = prefs.getInt(option.name);
      if (savedColor != null) {
        setState(() {
          option.color = Color(savedColor);
        });
      }
    }
  }

  void saveColorToPrefs(ColorOption option) {
    prefs.setInt(option.name, option.color.value);
  }

  void clearSharedPreferences() async {
    await prefs.clear();
  }

  void revertToDefaultColors() {
    for (var option in config.semanticColors) {
      setState(() {
        option.color = option.original;
      });
    }
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
    final colorScheme =
        Provider.of<ThemeNotifier>(context).currentTheme.colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: TextButton(
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                shape: MaterialStateProperty.all(const CircleBorder()),
              ),
              child: const Text(
                'Tr',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _applyButtonPressed,
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Color.fromARGB(150, 79, 55, 140)),
                  SizedBox(width: 15.0),
                  Text(
                    'Apply',
                    style: TextStyle(color: Color.fromARGB(150, 79, 55, 140)),
                  ),
                ],
              ),
            ),
          ),
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
                'Images/logo2.PNG',
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
          children: config.semanticColors
              .map((option) => _buildButton(option))
              .toList(growable: false),
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
        width: 550,
        decoration: BoxDecoration(
          color: const Color.fromARGB(200, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
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
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                Text(
                  option.description,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: option.color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(50, 255, 255, 255),
                  width: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(ColorOption option) {
    Color pickerColor = option.color;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SizedBox(
            width: 700, // Set the width of the popup
            height: 550, // Set the height of the popup
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ColorPicker widget
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ColorPicker(
                      color: pickerColor,
                      enableOpacity: true,
                      onColorChanged: (Color color) {
                        setState(() {
                          pickerColor = color;
                          option.color = color;
                        });
                      },
                      heading: Text(
                        'Select color from wheel',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.wheel: true,
                        ColorPickerType.primary: false,
                        ColorPickerType.accent: false,
                        ColorPickerType.both: true,
                      },
                      wheelWidth: 40,
                      width: 40,
                      height: 40,
                      spacing: 2,
                      runSpacing: 2,
                      borderRadius: 1,
                      wheelDiameter: 300,
                      showColorCode: true,
                      hasBorder: true,
                      colorCodeHasColor: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      option.color = option.original;
                      pickerColor = option.original;
                    });
                  },
                  child: const Text(
                    'Revert',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    saveColorToPrefs(option);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _applyButtonPressed() async {
    for (var option in config.semanticColors) {
      saveColorToPrefs(option);
    }
    storage.apply(
      config,
      [await fetch.fetchTemplate("foot")],
    ).listen(print);
    if (kDebugMode) {
      print('Apply button pressed');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
