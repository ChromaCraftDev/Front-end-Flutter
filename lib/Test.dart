import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Generation with Google AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextGenerationScreen(),
    );
  }
}

class TextGenerationScreen extends StatefulWidget {
  @override
  _TextGenerationScreenState createState() => _TextGenerationScreenState();
}

class _TextGenerationScreenState extends State<TextGenerationScreen> {
  TextEditingController _promptController = TextEditingController();
  String _generatedText = '';
  bool _loading = false;

  Future<void> _generateText(String prompt) async {
    setState(() {
      _loading = true;
    });

    const String apiKey = 'AIzaSyBXe8a9jS50NmXW6T_FpDjdubZ1nd-RPvM';
    const String endpoint ='https://language.googleapis.com/v1/documents:analyzeText';

    final Map<String, dynamic> requestBody = {
      'document': {
        'type': 'PLAIN_TEXT',
        'content': prompt,
      },
      'features': {
        'extractSyntax': false,
        'extractEntities': false,
        'extractDocumentSentiment': false,
        'extractEntitySentiment': false,
        'classifyText': true,
      },
    };

    final Uri uri = Uri.parse('$endpoint?key=$apiKey');

    final http.Response response =
        await http.post(uri, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String generatedText = data['text'] as String;
      setState(() {
        _generatedText = generatedText;
        _loading = false;
      });
    } else {
      setState(() {
        _generatedText = 'Failed to generate text';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Generation with Google AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter Prompt',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () {
                      final String prompt = _promptController.text.trim();
                      if (prompt.isNotEmpty) {
                        _generateText(prompt);
                      }
                    },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Text'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _generatedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
