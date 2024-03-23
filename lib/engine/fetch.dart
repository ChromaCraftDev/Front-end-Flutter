import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'storage.dart';
import 'meta.dart';
import 'util.dart';

const domain = "chromacraftdev.github.io";

Future<http.Response> _get(String name) async {
  final response = await http.get(Uri.https(domain, "/templates/$name"));
  if (response.statusCode == 200) {
    return response;
  }
  return Future.error(
      "Could not reach $domain, error code: ${response.statusCode}");
}

Future<List<TemplateMetadata>> fetchTemplatesList() async {
  final json = (await _get("templates.json")).body;
  return (jsonDecode(json) as List<dynamic>)
      .map((it) => it as Map<String, dynamic>)
      .map(TemplateMetadata.fromJson)
      .toList(growable: false);
}

Future<Directory> downloadOrUpdateTemplate(String name) async {
  deleteIndiscriminately(await templateDirectory + name);
  deleteIndiscriminately(await compiledDirectory + name);
  final bytes = (await _get("$name.zip")).bodyBytes;
  return await unpackTemplate(name, bytes);
}

enum TemplateStat {
  remoteNotFound,
  notFound,
  needsUpdate,
  ok,
}

Future<TemplateStat> statTemplate(
    String name, List<TemplateMetadata> list) async {
  final TemplateMetadata remote;
  try {
    remote = list.singleWhere((it) => it.name == name);
  } catch (_) {
    return TemplateStat.remoteNotFound;
  }
  final local = await getLocalTemplateMetadata(name);
  if (local == null) {
    return TemplateStat.notFound;
  }
  // users can manually set negative versions to say 'do not update'
  if (0 < local.version && local.version < remote.version) {
    return TemplateStat.needsUpdate;
  }

  return TemplateStat.ok;
}
