import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'meta.dart';

final Future<Directory> _cacheDirectory = getApplicationCacheDirectory();

Future<String> _path(String name) async {
  return path.join((await _cacheDirectory).absolute.path, name);
}

Future<File> save(String name, Uint8List content) async {
  return File(await _path(name)).writeAsBytes(content);
}

Future<TemplateMetadata?> getStoredTemplateMetadata(String name) async {
  final file = File(await _path(path.join(name, "meta.json")));
  if (await file.exists()) {
    var decoded = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    decoded.putIfAbsent("name", () => name);
    return TemplateMetadata.fromJson(decoded);
  } else {
    return null;
  }
}

Future<Directory> storeTemplate(String name, Uint8List zip) async {
  await removeTemplate(name); // clean it up if it exists already
  final dir = await Directory(await _path(name)).create(recursive: true);
  final archive = ZipDecoder().decodeBuffer(InputStream(zip));
  await extractArchiveToDiskAsync(archive, dir.absolute.path);
  return dir;
}

Future<void> removeTemplate(String name) async {
  final dir = Directory(await _path(name));
  if (await dir.exists()) await dir.delete(recursive: true);
}

// flutter run -t lib/engine/storage.dart
main() async {
  print("based on whether you ran this before");
  print(await getStoredTemplateMetadata("foot"));

  print("should say null");
  await removeTemplate("foot");
  print(await getStoredTemplateMetadata("foot"));

  print("should work");
  await storeTemplate(
    "foot",
    await File(path.join("lib", "engine", "test.zip")).readAsBytes(),
  );
  print(await getStoredTemplateMetadata("foot"));
}
