import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Text Generation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AIPage(),
    );
  }
}

class AIPage extends StatefulWidget {
  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedText = '';

  Future<void> _generateText(String prompt) async {
    // Replace 'YOUR_OPENAI_API_KEY' with your actual OpenAI API key
    String apiKey = 'YOUR_OPENAI_API_KEY';
    String endpoint = 'https://api.openai.com/v1/engines/davinci-codex/completions';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    Map<String, dynamic> data = {
      'prompt': prompt,
      'max_tokens': 50, // Adjust the number of tokens generated as needed
    };

    try {
      final response = await http.post(Uri.parse(endpoint), headers: headers, body: jsonEncode(data));
      final responseData = json.decode(response.body);
      setState(() {
        _generatedText = responseData['choices'][0]['text'];
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Text Generation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _promptController,
              decoration: InputDecoration(labelText: 'Enter Prompt'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _generateText(_promptController.text);
            },
            child: Text('Generate Text'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Text(_generatedText),
            ),
          ),
        ],
      ),
    );
  }
}
