// NOT A PART OF A SOFTWARE 
// .

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class OpenaiService {
  final String apiKey;
  final String endpoint = 'https://api.openai.com/v1/engines/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/completions';

  OpenaiService(this.apiKey);

  Future<String> generatePrompt(String prompt) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to generate prompt: ${response.statusCode}');
    }
  }
}

class PromptGenerator extends ChangeNotifier {
  final OpenaiService openaiService;
  String prompt = '';
  String generatedText = '';
  bool isLoading = false;

  PromptGenerator(this.openaiService);

  Future<void> generatePrompt() async {
    isLoading = true;
    notifyListeners();
    try {
      generatedText = await openaiService.generatePrompt(prompt);
    } catch (e) {
      generatedText = 'Failed to generate prompt: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PromptGenerator(OpenaiService('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')),
      child: MaterialApp(
        title: 'OpenAI Prompt Generator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PromptGeneratorScreen(),
      ),
    );
  }
}

class PromptGeneratorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final promptGenerator = Provider.of<PromptGenerator>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenAI Prompt Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter prompt'),
              onChanged: (value) => promptGenerator.prompt = value,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: promptGenerator.generatePrompt,
              child: const Text('Generate'),
            ),
            const SizedBox(height: 16.0),
            promptGenerator.isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Text(promptGenerator.generatedText),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}