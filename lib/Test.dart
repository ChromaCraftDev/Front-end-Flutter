import 'package:flutter/material.dart';

void main() {
  runApp(ChromaCraftApp());
}

class ChromaCraftApp extends StatelessWidget {
  // Define the colors for the palettes
  final List<Color> paletteColors = [
    Colors.red, // Base
    Colors.green, // Primary
    Colors.blue, // Shade
    Colors.yellow, // Alternate
    Colors.orange, // Container
    Colors.purple, // Error
    Colors.brown, // Text
    Colors.teal, // Warning
    Colors.grey, // Subtle
    Colors.pink, // Success
  ];

  // Define corresponding labels for each color
  final List<String> colorLabels = [
    'Base',
    'Primary',
    'Shade',
    'Alternate',
    'Container',
    'Error',
    'Text',
    'Warning',
    'Subtle',
    'Success',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChromaCraft',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Generate Palette'),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(200, 79, 55, 140)),
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
        body: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Image Prompt section
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                        'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D'),
                  ),
                  // Text Prompt section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Text prompt',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add functionality for the generate button
                          },
                          child: Text('Generate'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Color palettes
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: paletteColors.length ~/ 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: paletteColors[index],
                            borderRadius:
                                BorderRadius.circular(8.0), // Add border radius
                          ),
                          height: 80, // Adjust height as needed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                colorLabels[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: paletteColors.length ~/ 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: paletteColors[index + paletteColors.length ~/ 2],
                            borderRadius:
                                BorderRadius.circular(8.0), // Add border radius
                          ),
                          height: 80, // Adjust height as needed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                colorLabels[index + paletteColors.length ~/ 2],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Apply button
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.check),
            ),
          ),
        ),
      ),
    );
  }
}
