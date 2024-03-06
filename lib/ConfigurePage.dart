import 'package:chroma_craft_1/Typography.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart'; // Import the ThemeNotifier class
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({Key? key}) : super(key: key);

  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  Color colorBoxColor1 =  HexColor('#1E1E2E');
  Color colorBoxColor2 = HexColor('#11111B');
  Color colorBoxColor3 = HexColor('#313244');
  Color colorBoxColor4 = HexColor('#CDD6F4');
  Color colorBoxColor5 = HexColor('#A6ADC8');
  Color colorBoxColor6 = HexColor('#CBA6F7');
  Color colorBoxColor7 = HexColor('#FAB387');
  Color colorBoxColor8 = HexColor('#F38BA8');
  Color colorBoxColor9 = HexColor('#F9E2AF');
  Color colorBoxColor10 = HexColor('#A6E3A1');

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkModeEnabled = themeNotifier.currentTheme == ThemeData.dark();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colour Configure'),
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
              buildButton('Base', 'The most prevalent. Usually the background colour.', colorBoxColor1),
              buildButton('Shade', 'Visually below the components using base colour usually used for sidebars', colorBoxColor2),
              buildButton('Container', 'Visually above the components using base, usually used for cards.', colorBoxColor3),
              buildButton('Text', 'Forground, usually used for main text, and icons.', colorBoxColor4),
              buildButton('Subtle', 'Less important than "text" usally used for description texts', colorBoxColor5),
            ]),
            const SizedBox(width: 20), // Add space between columns
            _buildColumn([
              buildButton('Primary', 'The focus. usally used for important buttons.', colorBoxColor6),
              buildButton('Alternate', 'A contracting accent used to create visual interest.', colorBoxColor7),
              buildButton('Error', 'Used to indicate Error', colorBoxColor8),
              buildButton('Warning', 'Used to indicate Warning', colorBoxColor9),
              buildButton('Success', 'Used to indicate success.', colorBoxColor10),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children.map((widget) => Padding(padding: EdgeInsets.symmetric(vertical: 10), child: widget)).toList(),
    );
  }

  Widget buildButton(String title, String subtitle, Color colorBoxColor) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pick a color'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: colorBoxColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      colorBoxColor = color;
                    });
                  },
                  showLabel: true,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 600, // Adjust the width as needed
        height: 70, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Colors.black, // Dark color for the rectangle background
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
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
}
