import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'config.dart';
import 'meta.dart';
import 'template.dart';
import 'util.dart';

/// The *ChromaCraft* applicaton directory. Do not use directly.
final cacheDirectory = getApplicationCacheDirectory();

/// Where the downloaded templates from the browse page go.
final templateDirectory = cacheDirectory
    .then((it) => Directory(it + "templates").create(recursive: true));

/// Temporary location to store the compiled output before being installed.
/// Is safe to be deleted when the application is closed, without any loss.
final compiledDirectory = cacheDirectory
    .then((it) => Directory(it + "compiled").create(recursive: true));

/// The location where the host's previous version of the file is moved, if it existed.
final backupDirectory = cacheDirectory
    .then((it) => Directory(it + "backup").create(recursive: true));

final installedFile =
    cacheDirectory.then((it) => File(it + "installed").create(recursive: true));

Future<TemplateMetadata?> getLocalTemplateMetadata(String name) async {
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

Future<Directory> unpackTemplate(String name, Uint8List zip) async {
  final dir = Directory(await templateDirectory + name);
  if (await dir.exists()) await dir.delete(recursive: true);
  await dir.create(recursive: true);
  final archive = ZipDecoder().decodeBuffer(InputStream(zip));
  await extractArchiveToDiskAsync(archive, dir.absolute.path);
  return dir;
}

/// In order, this function:
/// 1. If installed, restores any backed up files then removes installed entry.
/// 2. Deletes compiled files
/// 3. Deletes downloaded template
Future<void> uninstallTemplate(String name) async {
  final meta = await getLocalTemplateMetadata(name);
  if (meta == null) throw Exception("Template '$name' doesn't exist locally.");

  if (!meta.platforms.contains(Platform.current())) {
    throw "Unsupported platform!";
  }

  final template = await templateDirectory + name;
  final compilePath = await compiledDirectory + meta.name;
  final installPath = userHome + meta.install.dest[Platform.current()]!;
  final backupPath = await backupDirectory + meta.name;

  if (await (await installedFile).hasLine(installPath)) {
    movePath(from: backupPath, to: installPath, force: ForceMode.deleteFirst);
    await (await installedFile).removeLine(installPath);
  }
  deleteIndiscriminately(compilePath);
  deleteIndiscriminately(template);
}

/// In order, this function:
/// 1. Compiles the files
/// 2. Backs up any files that would've been overriden during installation.
/// 3. Copies all that is compiled to the install directory.
/// 4. Register the name in the installed list.
Future<void> compileAndInstall(Config config, Directory template) async {
  final meta = TemplateMetadata.fromJson(
      jsonDecode(await File(template + "meta.json").readAsString()));

  if (!meta.platforms.contains(Platform.current())) {
    throw "Unsupported platform!";
  }

  final sourcePath = template + meta.install.src;
  final compilePath = await compiledDirectory + meta.name;
  final installPath = userHome + meta.install.dest[Platform.current()]!;
  final backupPath = await backupDirectory + meta.name;

  final compiled = copyFiles(
    from: sourcePath,
    to: compilePath,
    files: recurseFiles(sourcePath),
    transform: (it) => compileTemplate(config, it),
  );

  print("""
  sourcePath = $sourcePath
  compilePath = $compilePath
  installPath = $installPath
  backupPath = $backupPath
  """);
  if (!await (await installedFile).hasLine(installPath)) {
    await movePath(from: installPath, to: backupPath); // backup
    await (await installedFile).appendLine(installPath);
  }
  deleteIndiscriminately(installPath);

  final Future<void> installed;
  if (meta.install.zip) {
    await compiled.join();
    installed = ZipFileEncoder().zipDirectoryAsync(
      Directory(compilePath),
      filename: installPath,
    );
  } else {
    installed = copyFiles(
      files: compiled,
      from: compilePath,
      to: installPath,
    ).join().then((_) {});
  }

  return installed;
}

/// A helper function for usage in the UI
Stream<void> installAllDownloaded(Config config) async* {
  await for (final template in (await templateDirectory).list()) {
    final name = path.basename(template.path);
    if (template is Directory) {
      if (kDebugMode) {
        print("Found template '$name'. Trying to compile...");
      }
      yield compileAndInstall(config, template);
    } else {
      throw "Invalid item found in templates directory: $name";
    }
  }
}
