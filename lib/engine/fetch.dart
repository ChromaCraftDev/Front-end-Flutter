import 'dart:convert';

import 'package:http/http.dart';

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

enum Platform {
  windows,
  macos,
  linux,
  invalid;

  static Platform fromString(String name) => values.firstWhere(
        (element) => element.name == name,
        orElse: () => Platform.invalid,
      );
}

class TemplateMetadata {
  final String name;
  final int version;
  final Uri projectHomepage;
  final List<Platform> platforms;
  final InstallerConfig install;


  TemplateMetadata(
    this.name,
    this.version,
    this.projectHomepage,
    this.platforms,
    this.install,
  );

  static TemplateMetadata fromJson(Map<String, dynamic> parsed) {
    return TemplateMetadata(
      parsed['name'],
      parsed['version'],
      Uri.parse(parsed['project_homepage']),
      (parsed['platforms'] as List<dynamic>)
          .map((e) => e as String)
          .map(Platform.fromString)
          .toList(),
      InstallerConfig.fromJson(parsed['install']),
    );
  }
}

class InstallerConfig {
  final String src;
  final Map<Platform, String> dest;

  InstallerConfig(this.src, this.dest);

  static InstallerConfig fromJson(Map<String, dynamic> parsed) {
    return InstallerConfig(
      parsed['src'],
      (parsed['destination'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(Platform.fromString(key), value as String);
      }),
    );
  }
}

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
