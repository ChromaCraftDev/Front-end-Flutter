import 'dart:convert';

import 'package:http/http.dart';

import 'template.dart';

const bool offline = true;
const String json = """
[
  {
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
    },
    "name": "foot"
  }
]
""";

Future<List<TemplateMetadata>> fetchTemplateMetadata() async {
  if (offline) {
    return (jsonDecode(json) as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map(TemplateMetadata.fromJson)
        .toList(growable: false);
  }
  final response = await get(
      Uri.https("chromacraftdev.github.io", "/templates/templates.json"));
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map(TemplateMetadata.fromJson)
        .toList(growable: false);
  }
  return Future.error(
      "Could not reach chromacraftdev.github.io, error code: ${response.statusCode}");
}
