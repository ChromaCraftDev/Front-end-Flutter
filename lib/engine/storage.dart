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

final _templateConfigFile =
    cacheDirectory.then((it) => File(it + "template_config.json"));

Future<bool> setTemplateInstallPath(String name, String newPath) async {
  final file = await _templateConfigFile;
  final Map<String, dynamic> json;
  if (await file.exists()) {
    final str = await file.readAsString();
    json = jsonDecode(str) as Map<String, dynamic>;
    final oldPath = json[name]?['path'] as String?;
    final installed = json[name]?['installed'] ?? false;
    if (oldPath != null && installed) {
      if (await pathExists(mapEnv(newPath))) return false;
      movePath(from: mapEnv(oldPath), to: mapEnv(newPath));
    }
    json[name] = {'installed': installed, 'path': newPath};
  } else {
    json = {
      name: {'installed': false, 'path': newPath}
    };
  }
  await file.writeAsString(jsonEncode(json), flush: true);
  return true;
}

Future<String?> getTemplateInstallPath(String name) async {
  final file = await _templateConfigFile;
  if (await file.exists()) {
    final str = await file.readAsString();
    final json = jsonDecode(str) as Map<String, dynamic>;
    return json[name]?['path'];
  } else {
    return null;
  }
}

Future<void> setTemplateInstalled(String name, bool installed) async {
  final file = await _templateConfigFile;
  final Map<String, dynamic> json;
  if (await file.exists()) {
    final str = await file.readAsString();
    json = jsonDecode(str) as Map<String, dynamic>;
    json[name] = {'installed': installed, 'path': json[name]?['path']};
  } else {
    json = {
      name: {'installed': installed, 'path': null}
    };
  }
  await file.writeAsString(jsonEncode(json), flush: true);
}

Future<bool> getTemplateInstalled(String name) async {
  final file = await _templateConfigFile;
  if (await file.exists()) {
    final str = await file.readAsString();
    final json = jsonDecode(str) as Map<String, dynamic>;
    return json[name]?['installed'] ?? false;
  } else {
    return false;
  }
}

Future<TemplateMetadata?> getLocalTemplateMetadata(String name) async {
  final template = Directory(await templateDirectory + name);
  final file = File(template + "meta.json");
  if (await file.exists()) {
    final decoded =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;
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

  final template = await templateDirectory + name;
  final compilePath = await compiledDirectory + meta.name;
  final installPath = await getTemplateInstallPath(meta.name) ??
      meta.install.dest[Platform.current()];
  final backupPath = await backupDirectory + meta.name;

  if (installPath != null && await getTemplateInstalled(name)) {
    await movePath(
      from: backupPath,
      to: mapEnv(installPath),
      force: ForceMode.deleteFirst,
    );
    await setTemplateInstalled(name, false);
  }
  await deleteIndiscriminately(compilePath);
  await deleteIndiscriminately(template);
}

/// In order, this function:
/// 1. Compiles the files
/// 2. Backs up any files that would've been overriden during installation.
/// 3. Copies all that is compiled to the install directory.
/// 4. Register the name in the installed list.
Future<void> compileAndInstall(Config config, Directory template) async {
  final meta = TemplateMetadata.fromJson(
      jsonDecode(await File(template + "meta.json").readAsString()));

  final sourcePath = template + meta.install.src;
  final compilePath = await compiledDirectory + meta.name;
  final installPath = await getTemplateInstallPath(meta.name) ??
      meta.install.dest[Platform.current()];
  if (installPath == null) throw "Unspported platform!";
  final mappedInstallPath = mapEnv(installPath);
  final backupPath = await backupDirectory + meta.name;

  final compiled = copyFiles(
    from: sourcePath,
    to: compilePath,
    files: recurseFiles(sourcePath),
    transform: (it) => compileTemplate(config, it),
  );

  if (!await getTemplateInstalled(meta.name)) {
    await movePath(from: mappedInstallPath, to: backupPath); // backup
  }

  // order matters, i think
  await setTemplateInstallPath(meta.name, installPath);
  await setTemplateInstalled(meta.name, true);

  final Future<void> installed;
  if (meta.install.zip) {
    await compiled.join();
    installed = ZipFileEncoder().zipDirectoryAsync(
      Directory(compilePath),
      filename: mappedInstallPath,
    );
  } else {
    installed = copyFiles(
      files: compiled,
      from: compilePath,
      to: mappedInstallPath,
    ).join();
  }

  return installed;
}

/// A helper function for usage in the UI
Future<void> installAllDownloaded(Config config) async {
  await for (final template in (await templateDirectory).list()) {
    final name = path.basename(template.path);
    if (template is Directory) {
      if (kDebugMode) {
        print("Found template '$name'. Trying to compile...");
      }
      await compileAndInstall(config, template);
    } else {
      throw "Invalid item found in templates directory: $name";
    }
  }
}
