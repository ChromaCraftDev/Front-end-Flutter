import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'engine/config.dart';
import 'package:flutter/foundation.dart';

class GenerateAI extends StatefulWidget {
  const GenerateAI({super.key});

  @override
  _GenerateAIState createState() => _GenerateAIState();
}

class _GenerateAIState extends State<GenerateAI> {
  final TextEditingController _textEditingController = TextEditingController();
  String _response = '';
  final OpenAIService _aiService = OpenAIService();
  late SharedPreferences _prefs; // SharedPreferences instance
  bool _isLoading = false; // Loading indicator variable
  String email = '';
  String _firstName = '';
  String _lastName = '';
  String _selectedProfilePicture = ' ';

  @override
  void initState() {
    super.initState();
    _loadSavedColors(); // Load saved colors when the widget initializes
    _getEmailFromStorage();
  }

  Future<void> _loadSavedColors() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? savedColors = _prefs.getStringList('paletteColors');
    if (savedColors != null) {
      setState(() {
        for (var i = 0; i < config.semanticColors.length; i++) {
          config.semanticColors[i].color = colorFromHex(savedColors[i])!;
        }
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
      for (var i = 0; i < config.semanticColors.length; i++) {
        config.semanticColors[i].color = colorFromHex(hexColors[i])!;
      }
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
    for (int i = 0; i < config.semanticColors.length; i++) {
      config.semanticColors[i].color = colorFromHex(hexColors[i])!;
    }
    _saveColorsToPrefs(hexColors); // Save the colors to SharedPreferences
  }

  Future<void> _saveColorsToPrefs(List<String> hexColors) async {
    await _prefs.setStringList('paletteColors', hexColors);
  }

Widget _buildGenerateButton() {
  if (_isLoading) {
    return const CircularProgressIndicator(); // Show loading indicator when generating response
  } else {
    return ElevatedButton(
      onPressed: _textEditingController.text.isEmpty ? null : () {
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
      drawer: GFDrawer(
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      const SizedBox(width: 5), // Add some spacing between image and text
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
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Text prompt',
                          ),
                          onChanged: (String text) {
                          setState(() {}); // Trigger a state update
                          },
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
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
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
            child: Center(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150, // Set the maximum width for grid tiles
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: config.semanticColors.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 150, // Set the fixed width
                    height: 150, // Set the fixed height
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                      curve: Curves.decelerate, // Adjust the curve as needed
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: config.semanticColors[index].color,
                        borderRadius: BorderRadius.circular(8.0), // Add border radius
                      ),
                      child: Center(
                        child: Text(
                          config.semanticColors[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
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
  Future<void> _getEmailFromStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userData.txt');
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
        .eq('email',email);

    if (response != null && response.isNotEmpty) {
      final user = response[0];
      setState(() {
        _firstName = user['first_name'] as String;
        if (user['last_name'] as String == null) {
          _lastName = " ";
        }else{
          _lastName = user ['last_name'] as String;
        }
      });
    } else {
      print('No user data found for this email: $email');
    }
  } catch (e) {
    print('Error fetching user data: $e');
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
        .eq('email',email);

        final user = response[0];
      setState(() {
          _selectedProfilePicture = user['image_id'] as String;

      });
    } catch (e) {
      print('Error loading image ID from file: $e');
    }
  }
}


class OpenAIService {
  final List<Map<String, String>> messages = [];
  static const apiUri = 'https://api.openai.com/v1/chat/completions';
  static const apiKey = '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';

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      "role": "system",
      "content": """
You are 'ChromaCraft AI', an AI used for generating color schemes based on natural language prompts. 
Whenever the user gives you a prompt, you will reply with a list of hex colours in the following order.

${config.semanticColors.map((it) => "- ${it.name}: ${it.description}").join("\n\n")}

Keep in mind the laws of UI and design. Contrast is highly important for a pleasing theming appliation.
Make sure you always have a contrast ratio of 4.5:1 as per the Web Content Accessibility Guidelines.
If the user doesn't explicitly specify whether the theme is light or dark, make an assumption.

The format expected of your reply should follow the templat below (without the backticks, just the content inside)
```
mode = dark|light
${config.semanticColors.map((it) => "${it.name} = #XXXXXX").join("\n")}
```
"""
    });
    messages.add({
      "role": "user",
      "content": prompt,
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
          "temperature": 0.5
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
