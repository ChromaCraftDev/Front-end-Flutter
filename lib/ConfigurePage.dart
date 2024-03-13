import 'engine/config.dart';
import 'Typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({Key? key}) : super(key: key);

  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  final Config config = Config();
  TextEditingController hexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Provider.of<ThemeNotifier>(context).currentTheme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Colour Configure'),
        actions: <Widget>[
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Make the container circular
              color: Color.fromARGB(150, 79, 55,
                  140), // Set the background color for the icon button
            ),
            child: IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {},
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Make the container circular
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
            padding:
                const EdgeInsets.only(right: 16.0), // Add padding to the right
            child: TextButton(
              onPressed: () {
                // Implement your apply button functionality here
                if (kDebugMode) {
                  print('Apply button pressed');
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.edit,
                      color: Color.fromARGB(150, 79, 55, 140)), // Icon
                  SizedBox(width: 15.0), // Add spacing between icon and text
                  Text(
                    'Apply',
                    style: TextStyle(color: Color.fromARGB(150, 79, 55, 140)),
                  ), // Text
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
      body: Center(
        child: Wrap(
          // a run is the column
          runAlignment: WrapAlignment.center,
          runSpacing: 20,
          // the gap between the individual items in the column
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
        width: 600, // Adjust the width as needed
        // height: 70, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Colors.black, // Dark color for the rectangle background
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
                  onColorChanged: (Color newColor) => setState(() {
                    option.color = newColor;
                    hexController.text = colorToHex(newColor);
                  }),
                  pickerAreaHeightPercent: 0.8,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: hexController,
                  decoration:
                      const InputDecoration(labelText: 'Hex Color Code'),
                  onChanged: (String hex) => setState(() {
                    option.color = hexToColor(hex);
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
                        hexController.text = colorToHex(option.original);
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
                    // Apply the chosen color
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

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }
}
