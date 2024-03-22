import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'meta.dart';
import 'template.dart';
import 'util.dart';

final cacheDirectory = getApplicationCacheDirectory();
final templateDirectory = cacheDirectory
    .then((it) => Directory(it + "templates").create(recursive: true));
final compiledDirectory = cacheDirectory
    .then((it) => Directory(it + "compiled").create(recursive: true));

Future<TemplateMetadata?> getStoredTemplateMetadata(String name) async {
  final template = Directory(await templateDirectory + name);
  final file = File(template + "meta.json");
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
  final dir =
      await Directory(await templateDirectory + name).create(recursive: true);
  final archive = ZipDecoder().decodeBuffer(InputStream(zip));
  await extractArchiveToDiskAsync(archive, dir.absolute.path);
  return dir;
}

Future<void> removeTemplate(String name) async {
  final dir = Directory(await templateDirectory + name);
  if (await dir.exists()) await dir.delete(recursive: true);
}

Stream<File> compileAndInstall(Config config, Directory template) async* {
  final meta = TemplateMetadata.fromJson(
      jsonDecode(await File(template + "meta.json").readAsString()));

  if (!meta.platforms.contains(Platform.current())) {
    yield* Stream.error("Unsupported platform!");
    return;
  }

  final sourcePath = template + meta.install.src;
  final compilePath = await compiledDirectory + meta.name;
  final installPath = userHome + meta.install.dest[Platform.current()]!;

  final compiled = copyFiles(
    from: sourcePath,
    files: recurseFiles(sourcePath),
    to: compilePath,
    transform: (it) => compileTemplate(config, it),
  );
  final installed = copyFiles(
    files: compiled,
    from: compilePath,
    to: installPath,
  );

  yield* installed;
}

Stream<File> installAllDownloaded(Config config) async* {
  await for (final template in (await templateDirectory).list()) {
    if (template is Directory) {
      if (kDebugMode) print("Found template '$template'. Trying to compile...");
      yield* compileAndInstall(config, template);
    } else {
      yield* Stream.error(
          "Invalid item found in templates directory: $template");
    }
  }
}
