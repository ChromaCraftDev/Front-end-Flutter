import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'meta.dart';
import 'template.dart';

final _cacheDirectory = getApplicationCacheDirectory();
final templatePath = _path("templates");
final compiledPath = _path("compiled");

Future<String> Function(String) _path(String name) => (it) async {
      return path.canonicalize(path.join(
        (await _cacheDirectory).absolute.path,
        name,
        it,
      ));
    };

Future<TemplateMetadata?> getStoredTemplateMetadata(String name) async {
  final file = File(await templatePath("$name/meta.json"));
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
  final dir = await Directory(await templatePath(name)).create(recursive: true);
  final archive = ZipDecoder().decodeBuffer(InputStream(zip));
  await extractArchiveToDiskAsync(archive, dir.absolute.path);
  return dir;
}

Future<void> removeTemplate(String name) async {
  final dir = Directory(await templatePath(name));
  if (await dir.exists()) await dir.delete(recursive: true);
}

Stream<File> _copy(Directory src) async* {
  final basename = path.basename(src.absolute.path);
  final destDirStr = await compiledPath(basename);
  await Directory(destDirStr).create(recursive: true);
  await for (final srcF in src.list(recursive: true)) {
    String dest = path.join(destDirStr,
        (path.relative(srcF.absolute.path, from: src.absolute.path)));
    if (srcF is Directory) {
      await Directory(dest).create(recursive: true);
    } else if (srcF is File) {
      yield await srcF.copy(dest);
    }
  }
}

Stream<File> apply(Config config, List<Directory> templates) async* {
  yield* Stream.fromIterable(templates).asyncExpand(_copy).asyncMap((it) async {
    return it.writeAsString(template(config, await it.readAsString()));
  });
}
