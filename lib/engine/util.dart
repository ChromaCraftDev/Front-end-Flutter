import 'dart:io';

import 'package:path/path.dart' as path;

// ==== FUNCTIONAL ====

T identity<T>(T input) => input;

// ====  FILES ====

extension AppendPath on Directory {
  String operator +(String other) => path.join(this.path, other);
}

Directory get userHome => Directory(
    Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!);

Stream<File> recurseFiles(String path) async* {
  yield* switch (await FileSystemEntity.type(path)) {
    FileSystemEntityType.file => Stream.value(File(path)),
    FileSystemEntityType.directory => Directory(path)
        .list(recursive: true)
        .asyncExpand(
            (it) => it is File ? Stream.value(it) : const Stream.empty()),
    _ => Stream.error("Not a supported file type!")
  };
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
