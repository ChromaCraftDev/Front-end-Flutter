import 'dart:convert';

import 'package:http/http.dart';

const bool OFFLINE = true;
const String JSON = """
{
  "foot": {
    "version": 0,
    "project_homepage": "https://codeberg.org/dnkl/foot",
    "platforms": [
      "linux"
    ],
    "install": {
      "src": "src.ini",
      "destination": {
        "linux": ".config/foot/foot.ini"
      }
    }
  }
}
""";

Future<Map<String, dynamic>> fetchTemplateMetadata() async {
  if (OFFLINE) {
    return jsonDecode(JSON) as Map<String, dynamic>;
  }
  final response = await get(
      Uri.https("chromacraftdev.github.io", "/templates/templates.json"));
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  return Future.error(
      "Could not reach chromacraftdev.github.io, error code: ${response.statusCode}");
}
