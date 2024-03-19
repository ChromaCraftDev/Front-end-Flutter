import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ChromaCraftApp());
}

class ChromaCraftApp extends StatefulWidget {
  @override
  _ChromaCraftAppState createState() => _ChromaCraftAppState();
}

class _ChromaCraftAppState extends State<ChromaCraftApp> {
  TextEditingController _textEditingController = TextEditingController();
  String _response = '';
  OpenAIService _aiService = OpenAIService();

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
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _generateResponse(String textPrompt) async {
    String response = await _aiService.chatGPTAPI(textPrompt);
    setState(() {
      _response = response;
    });
  }

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
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              labelText: 'Text prompt',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _generateResponse(_textEditingController.text);
                          },
                          child: Text('Generate'),
                        ),
                      ],
                    ),
                  ),
                  // Display Response section
                  Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _response,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )),
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

class OpenAIService {
  final List<Map<String, String>> messages = [];
  static const apiUri = 'https://api.openai.com/v1/chat/completions';
  static const apiKey = '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';

  Future<String> chatGPTAPI(String prompt) async {
  messages.add({
    "role": "user",
    "content":  "$prompt you are used to generated color codes for a theming application so you have generate colour codes according to the given prompt above in HEX to below template, base-colour = [color in hex]"
  });
  try {
    final res = await http.post(
      Uri.parse(apiUri),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $apiKey',
        'OpenAI-Organization': ''
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": messages,
        "temperature": 0.7
      }),
    );

    if (res.statusCode == 200) {
      String content =
          jsonDecode(res.body)['choices'][0]['message']['content'];
      content = content.trim();

      messages.add({
        'role': 'assistant',
        'content': content,
      });
      return content;
    } else {
      // Handle API errors here
      return 'An error occurred while communicating with the server. Please try again later.';
    }
  } catch (e) {
    return 'An unexpected error occurred: ${e.toString()}';
  }
}

}
