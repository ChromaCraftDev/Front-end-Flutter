import 'package:flutter/material.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({super.key});

  @override
  _ConfigurePageState createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  Color colorBoxColor1 = const Color.fromARGB(255, 30, 30, 46);
  Color colorBoxColor2 = const Color.fromARGB(255, 17, 17, 27);
  Color colorBoxColor3 = const Color.fromARGB(255, 49, 50, 68);
  Color colorBoxColor4 = const Color.fromARGB(255, 205, 214, 244);
  Color colorBoxColor5 = const Color.fromARGB(255, 166, 173, 200);
  Color colorBoxColor6 = const Color.fromARGB(255, 203, 166, 247);
  Color colorBoxColor7 = const Color.fromARGB(255, 250, 179, 135);
  Color colorBoxColor8 = const Color.fromARGB(255, 243, 139, 168);
  Color colorBoxColor9 = const Color.fromARGB(255, 249, 226, 175);
  Color colorBoxColor10 = const Color.fromARGB(255, 166, 227, 161);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure'),
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
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildButton('Base', 'The most prevalent. Usually the background colour.', colorBoxColor1),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Shade', 'Visually below the components using base colour usually used for sidebars', colorBoxColor2),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Container', 'Visually above the components using base, usually used for cards.', colorBoxColor3),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Text', 'Forground, usually used for main text, and icons.', colorBoxColor4),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Subtle', 'Less important than "text" usally used for description texts', colorBoxColor5),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Primary', 'The focus. usally used for important buttons.', colorBoxColor6),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Alternate', 'A contracting accent used to create visual interest.', colorBoxColor7),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Error', 'Used to indicate Error', colorBoxColor8),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Warning', 'Used to indicate Warning', colorBoxColor9),
              const SizedBox(height: 10), // Add some space between the buttons
              buildButton('Success', 'Used to indicate success.', colorBoxColor10),
            ],
          ),
        ),
    );
  }
}

Widget buildButton(String title, String subtitle, Color colorBoxColor) {
    return Container(
      width: 800, // adjust the width as needed
      height: 70, // adjust the height as needed
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // rounded corners
          ),
        ),
        onPressed: () {
          // handle button press
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            GestureDetector(
              onTap: () {
                setState(() {
                  colorBoxColor = colorBoxColor == Colors.red ? Colors.blue : Colors.red;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                color: colorBoxColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void setState(Null Function() param0) {
  }