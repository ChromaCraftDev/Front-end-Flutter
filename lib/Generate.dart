import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'engine/config.dart';
import 'package:flutter/foundation.dart';

class ColorOption {
  final Color original;
  Color color;
  final String name;
  final String description;

  ColorOption(this.original, this.name, this.description) : color = original;

  get presets => null;
}

class GenerateAI extends StatefulWidget {
  const GenerateAI({Key? key}) : super(key: key);

  @override
  _GenerateAIState createState() => _GenerateAIState();
}

class _GenerateAIState extends State<GenerateAI> {
  final TextEditingController _textEditingController = TextEditingController();
  String _response = '';
  final OpenAIService _aiService = OpenAIService();
  late SharedPreferences _prefs; // SharedPreferences instance
  bool _isLoading = false; // Loading indicator variable

  @override
  void initState() {
    super.initState();
    _loadSavedColors(); // Load saved colors when the widget initializes
  }

  Future<void> _loadSavedColors() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? savedColors = _prefs.getStringList('paletteColors');
    if (savedColors != null) {
      setState(() {
        paletteColors.clear();
        paletteColors.addAll(savedColors.map((hexColor) => Color(int.parse(hexColor.substring(1, 7), radix: 16) | 0xFF000000)));
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _generateResponse(String textPrompt) async {
    setState(() {
      _isLoading = true; // Set loading to true when generating response
    });
    String response = await _aiService.chatGPTAPI(textPrompt);
    List<String> hexColors = _extractHexColors(response);
    setState(() {
      paletteColors.clear();
      paletteColors.addAll(hexColors.map((hexColor) => Color(int.parse(hexColor.substring(1, 7), radix: 16) | 0xFF000000)));
    });
    _updateConfigColors(hexColors);
    setState(() {
      _response = response;
      _isLoading = false; // Set loading to false when response is received
    });
  }

  List<String> _extractHexColors(String response) {
    List<String> hexColors = [];
    RegExp regExp = RegExp(r'#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b');
    Iterable<Match> matches = regExp.allMatches(response);
    for (Match match in matches) {
      String? hexColor = match.group(0);
      if (hexColor != null) {
        hexColors.add(hexColor);
      } else {
        if (kDebugMode) {
          print("Failed to extract hex color from match: $match");
        }
      }
    }
    if (hexColors.isEmpty) {
      if (kDebugMode) {
        print("No hex colors found in response: $response");
      }
    }
    return hexColors;
  }

  void _updateConfigColors(List<String> hexColors) {
    for (int i = 0; i < hexColors.length && i < Config().semanticColors.length; i++) {
      Config().semanticColors[i].color = Color(int.parse(hexColors[i].substring(1, 7), radix: 16) | 0xFF000000);
    }
    _saveColorsToPrefs(hexColors); // Save the colors to SharedPreferences
  }

  Future<void> _saveColorsToPrefs(List<String> hexColors) async {
    await _prefs.setStringList('paletteColors', hexColors);
  }

  List<Color> paletteColors = [
    for (var colorOption in Config().semanticColors) colorOption.original,
  ];

  final List<String> colorLabels = [
    'Base',
    'Shade',
    'Container',
    'Text',
    'Subtle',
    'Primary',
    'Alternate',
    'Error',
    'Warning',
    'Success',
  ];

  Widget _buildGenerateButton() {
    if (_isLoading) {
      return const CircularProgressIndicator(); // Show loading indicator when generating response
    } else {
      return ElevatedButton(
        onPressed: () {
          _generateResponse(_textEditingController.text);
        },
        child: const Text('Generate'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Generate Template'),
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
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Text prompt',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (String text) {
                            _generateResponse(text);
                          },
                        ),
                      ),
                      _buildGenerateButton(), // Call the function to display the button or loading indicator
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _response,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0,
                          decoration: TextDecoration.underline, // Example: underline
                          decorationColor: Colors.blue, // Example: underline color
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: paletteColors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: paletteColors[index],
                          borderRadius: BorderRadius.circular(8.0), // Add border radius
                        ),
                        width: 80, // Set width to control the size
                        height: 80, // Set height to match the width
                        child: Center(
                          child: Text(
                            colorLabels[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Text('Apply'),
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
      "content": "$prompt you are used to generated color codes for a theming application so you have generate colour codes according to the given prompt above in HEX to below template, base-colour = [color in hex], Shade-color = [color in hex], Container-color = [color in hex], Text-color = [color in hex], Subtle-color = [color in hex], Primary-color = [color in hex], Alternate-color = [color in hex], Error-color = [color in hex], Warning-color = [color in hex], 'Success-color = [color in hex] "
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
        return 'An error occurred while communicating with the server. Please try again later.';
      }
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }
}
