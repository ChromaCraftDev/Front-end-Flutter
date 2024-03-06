import 'package:chroma_craft_1/Typography.dart';
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
  // Define a list of color variables
  List<Color> colorBoxColors = [
    const Color.fromARGB(255, 30, 30, 46),
    const Color.fromARGB(255, 17, 17, 27),
    const Color.fromARGB(255, 49, 50, 68),
    const Color.fromARGB(255, 205, 214, 244),
    const Color.fromARGB(255, 166, 173, 200),
    const Color.fromARGB(255, 203, 166, 247),
    const Color.fromARGB(255, 250, 179, 135),
    const Color.fromARGB(255, 243, 139, 168),
    const Color.fromARGB(255, 249, 226, 175),
    const Color.fromARGB(255, 166, 227, 161),
  ];

  TextEditingController hexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkModeEnabled = themeNotifier.currentTheme == ThemeData.dark();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colour Configure'),
        actions: <Widget>[
          Container(
              decoration: const BoxDecoration(
              shape: BoxShape.circle, // Make the container circular
              color: Color.fromARGB(150, 79, 55, 140), // Set the background color for the icon button
            ),
            child: IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {
                
              },
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
                    pageBuilder: (context, animation, secondaryAnimation) => const TypographyPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutQuart;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'Images/logo2.PNG',
                width: 1000, // Adjust width as needed
                height: 1000, // Adjust height as needed
              ),
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColumn([
              buildButton('Base', 'The most prevalent. Usually the background colour.', colorBoxColors[0], 0),
              buildButton('Shade', 'Visually below the components using base colour usually used for sidebars', colorBoxColors[1], 1),
              buildButton('Container', 'Visually above the components using base, usually used for cards.', colorBoxColors[2], 2),
              buildButton('Text', 'Forground, usually used for main text, and icons.', colorBoxColors[3], 3),
              buildButton('Subtle', 'Less important than "text" usally used for description texts', colorBoxColors[4], 4),
            ]),
            const SizedBox(width: 20), // Add space between columns
            _buildColumn([
              buildButton('Primary', 'The focus. usally used for important buttons.', colorBoxColors[5], 5),
              buildButton('Alternate', 'A contracting accent used to create visual interest.', colorBoxColors[6], 6),
              buildButton('Error', 'Used to indicate Error', colorBoxColors[7], 7),
              buildButton('Warning', 'Used to indicate Warning', colorBoxColors[8], 8),
              buildButton('Success', 'Used to indicate success.', colorBoxColors[9], 9),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children.map((widget) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: widget)).toList(),
    );
  }

  Widget buildButton(String title, String subtitle, Color colorBoxColor, int index) {
    return GestureDetector(
      onTap: () {
        _showColorPickerDialog(colorBoxColor, index);
      },
      child: Container(
        width: 600, // Adjust the width as needed
        height: 70, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Colors.black, // Dark color for the rectangle background
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorBoxColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(Color color, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: color,
                  onColorChanged: (Color newColor) {
                    setState(() {
                      colorBoxColors[index] = newColor;
                      hexController.text = colorToHex(newColor);
                    });
                  },
                  showLabel: true,
                  pickerAreaHeightPercent: 0.8,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: hexController,
                  decoration: const InputDecoration(labelText: 'Hex Color Code'),
                  onChanged: (String hex) {
                    _changeColorFromHex(hex, index);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _changeColorFromHex(String hex, int index) {
    try {
      Color newColor = hexToColor(hex);
      setState(() {
        colorBoxColors[index] = newColor;
      });
    } catch (e) {
      print('Invalid hex color');
    }
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