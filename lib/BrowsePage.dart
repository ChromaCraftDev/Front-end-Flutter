import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

class Browse extends StatelessWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse store"),
      ),
      body: kIsWeb ? _buildWebContent() : _buildWebView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle refresh action
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildWebContent() {
    return const Center(
      child: Text(
        'WebView is not supported on this platform.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildWebView() {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      return _buildWebContent(); // Display a message for Windows platform
    } else if (!kIsWeb) {
      return const WebView(
        initialUrl: 'https://flutter.dev',
        javascriptMode: JavascriptMode.unrestricted,
      );
    } else {
      // Handle web platform or other unsupported platforms
      return _buildWebContent();
    }
  }
}