import 'dart:io';

import 'package:chromacraft/theme_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flex_color_picker/flex_color_picker.dart";
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'engine/config.dart';
//import 'engine/fetch.dart' as fetch;
import 'engine/storage.dart' as storage;

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({super.key});

  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage>
    with WidgetsBindingObserver {
  late SharedPreferences prefs;
  String email = '';
  String _firstName = '';
  String _lastName = '';
  String _selectedProfilePicture = ' ';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getEmailFromStorage();
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
        if (kDebugMode) {
          print('No user data found for this email: $email');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
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

//--------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = context.read<ThemeNotifier>();
    final String logoImagePath =
        themeNotifier.currentTheme.brightness == Brightness.dark
            ? 'Images/logo.PNG'
            : 'Images/logo2.PNG';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Colour Configure'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GFButton(
              onPressed: _applyButtonPressed,
              child: const Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Apply',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: GFDrawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(200, 79, 55, 140)),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                logoImagePath,
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
        child: Center(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Semantic Colors',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Wrap(
                    runAlignment: WrapAlignment.center,
                    runSpacing: 20,
                    spacing: 10,
                    children: config.semantic
                        .toMap()
                        .map(_buildOption)
                        .values
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Rainbow Colors',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Wrap(
                    runAlignment: WrapAlignment.center,
                    runSpacing: 20,
                    spacing: 10,
                    children: config.rainbow
                        .toMap()
                        .map(_buildOption)
                        .values
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  MapEntry<String, Widget> _buildOption(String name, ColorOption option) {
    return MapEntry(
        name,
        GestureDetector(
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
                          name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ] +
                      (option.description == null
                          ? []
                          : [
                              Text(
                                option.description!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ]),
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
        ));
  }

  void _showColorPickerDialog(ColorOption option) {
    Color pickerColor = option.color;

    showDialog(
      context: context,
      barrierDismissible: false,
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
                        pickersEnabled: const <ColorPickerType, bool>{
                          ColorPickerType.wheel: true,
                          ColorPickerType.primary: false,
                          ColorPickerType.accent: false,
                          ColorPickerType.both: true,
                        },
                        wheelWidth: 20,
                        width: 50,
                        height: 50,
                        spacing: 0,
                        enableTonalPalette: true,
                        runSpacing: 0,
                        borderRadius: 5,
                        hasBorder: true,
                        wheelHasBorder: true,
                        wheelDiameter: 200,
                        showColorName: true,
                        showRecentColors: true,
                        maxRecentColors: 5,
                        recentColors: const <Color>[],
                        showColorCode: true,
                        colorCodeHasColor: true,
                        copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                          secondaryMenu: true,
                          secondaryOnDesktopLongOnDevice: true,
                        )),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFButton(
                  color: GFColors.DANGER,
                  onPressed: () {
                    setState(() {
                      option.revert();
                      pickerColor = option.color;
                    });
                  },
                  child: const Text(
                    'Revert',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                GFButton(
                  color: GFColors.SUCCESS,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.black),
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
    if (kDebugMode) print("Installing...");
    saveConfig();
    storage.installAllDownloaded(config);

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Main content of the screen
            Positioned.fill(
              child: Scaffold(
                backgroundColor:
                    Colors.transparent, // Make scaffold transparent
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'Images/loading.gif', // Replace 'loading_image.png' with your image asset path
                        width: 100, // Adjust width as needed
                        height: 100, // Adjust height as needed
                      ),
                      const SizedBox(
                          height: 10), // Add spacing between image and text
                      const Text(
                        'Please wait while your custom theme template is applying.',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Simulate delay
    await Future.delayed(const Duration(seconds: 2));

    // Hide loading overlay
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
