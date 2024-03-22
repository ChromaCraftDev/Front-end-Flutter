import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'storage.dart';
import 'meta.dart';

const domain = "chromacraftdev.github.io";
const offline = false;
final testTemplate = File(path.join("lib", "engine", "test.zip")).readAsBytes();
final testJson = File(path.join("lib", "engine", "test.json")).readAsString();

Future<http.Response> _get(String name) async {
  final response = await http.get(Uri.https(domain, "/templates/$name"));
  if (response.statusCode == 200) {
    return response;
  }
  return Future.error(
      "Could not reach $domain, error code: ${response.statusCode}");
}

Future<List<TemplateMetadata>> fetchTemplatesList() async {
  final json = offline ? await testJson : (await _get("templates.json")).body;
  return (jsonDecode(json) as List<dynamic>)
      .map((it) => it as Map<String, dynamic>)
      .map(TemplateMetadata.fromJson)
      .toList(growable: false);
}

Future<Directory> fetchTemplate(String name) async {
  final bytes =
      offline ? await testTemplate : (await _get("$name.zip")).bodyBytes;
  return await storeTemplate(name, bytes);
}

Future<bool> templateNeedsUpdate(
    String name, List<TemplateMetadata> list) async {
  final TemplateMetadata remote;
  try {
    remote = list.singleWhere((it) => it.name == name);
  } catch (_) {
    return Future.error(
        "Could not find template for $name in server ($domain).");
  }
  final local = await getStoredTemplateMetadata(name);
  if (local == null) {
    return Future.error("Could not find template for $name locally.");
  }
  return local.version < remote.version;
}

main() async {
  final list = await fetchTemplatesList();
  print(list);
  for (var TemplateMetadata(name: name) in list) {
    print(await fetchTemplate(name));
  }
}
