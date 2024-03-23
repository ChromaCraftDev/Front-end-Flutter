import 'dart:io';

import 'package:path/path.dart' as path;

// ==== FUNCTIONAL ====

T identity<T>(T input) => input;

// ==== STRINGS ====

String mapEnv(String value) {
  return value.replaceAllMapped(
    RegExp(r"\$\{(\s*[^\}]+\s*)\}"),
    (match) => Platform.environment[match.group(1)!] ?? "",
  );
}

List<String> tokenize(String input) => input.split(RegExp(r"\s+"));

// ====  FILES ====

extension AppendPath on Directory {
  String operator +(String other) => path.join(this.path, other);
}

// Not sure how reliable this is, but I'm not about to add another library to do just this.
Directory get userHome => Directory(
    Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!);

// `FileSystemEntity.type` is dart's way of `stat`int a file.
Future<bool> pathExists(String path) async =>
    await FileSystemEntity.type(path, followLinks: false) !=
    FileSystemEntityType.notFound;

/// The same as `Directory.delete(recurisve: true)`.
/// Abuses the fact that it deletes EVERYTHING when in recursive mode, directory or not.
Future<FileSystemEntity?> deleteIndiscriminately(String path) async =>
    await pathExists(path) ? Directory(path).delete(recursive: true) : null;

Stream<File> recurseFiles(String path) async* {
  yield* switch (await FileSystemEntity.type(path, followLinks: false)) {
    FileSystemEntityType.file => Stream.value(File(path)),
    FileSystemEntityType.directory => Directory(path)
        .list(recursive: true)
        .asyncExpand(
            (it) => it is File ? Stream.value(it) : const Stream.empty()),
    _ => Stream.error("Not a supported file type!")
  };
}

// why am i doing this, we don't have time
enum ForceMode {
  dontForce,
  deleteFirst,
  replaceOnConflict,
}

Future<FileSystemEntity?> movePath({
  required String from,
  required String to,
  ForceMode force = ForceMode.dontForce,
}) async {
  if (await pathExists(to)) {
    if (force == ForceMode.dontForce) {
      return null;
    } else if (force == ForceMode.deleteFirst) {
      deleteIndiscriminately(to);
    }
  }

  switch (await FileSystemEntity.type(from, followLinks: false)) {
    case FileSystemEntityType.directory:
      final src = Directory(from);
      final dest = Directory(to);
      await dest.create(recursive: true);
      await for (final item in src.list(recursive: true, followLinks: false)) {
        final pathPart = path.relative(item.path, from: from);
        // recurse
        await movePath(from: src + pathPart, to: dest + pathPart);
      }
      src.delete(recursive: true);
      return dest;
    case FileSystemEntityType.file:
      final src = File(from);
      final dest = File(to);
      await dest.writeAsBytes(await src.readAsBytes(), flush: true);
      await src.delete();
      return dest;
    case FileSystemEntityType.link:
      final src = Link(from);
      final dest = Link(to);
      if (force == ForceMode.replaceOnConflict) await src.delete();
      await dest.create(await src.target(), recursive: true);
      await src.delete();
      return dest;
    case FileSystemEntityType.notFound:
      return null;
    default:
      throw UnimplementedError("Unsupported file type: $from");
  }
}

Stream<File> copyFiles({
  required Stream<File> files,
  required String from,
  required String to,
  String Function(String) transform = identity,
}) async* {
  yield* files.asyncMap((it) async {
    final pathPart = path.relative(it.absolute.path, from: path.absolute(from));
    final dest = path.canonicalize(path.join(to, pathPart));
    await Directory(path.dirname(dest)).create(recursive: true);
    final out = transform(await it.readAsString());
    return File(dest).writeAsString(out);
  });
}
