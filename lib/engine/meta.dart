import 'dart:io' as io;

enum Platform {
  windows,
  macos,
  linux,
  invalid;

  static Platform fromString(String name) {
    return values.firstWhere(
      (element) => element.name == name,
      orElse: () => Platform.invalid,
    );
  }

  static Platform current() {
    return switch (io.Platform.operatingSystem) {
      "windows" => Platform.windows,
      "linux" => Platform.linux,
      "macos" => Platform.macos,
      _ => Platform.invalid
    };
  }
}

class TemplateMetadata {
  final String name;
  final int version;
  final Uri projectHomepage;
  final String previewUrl;
  final InstallerConfig install;

  TemplateMetadata(
    this.name,
    this.version,
    this.projectHomepage,
    this.install,
  ) : previewUrl =
            "https://chromacraftdev.github.io/templates/previews/$name.webp";

  static TemplateMetadata fromJson(Map<String, dynamic> parsed) {
    return TemplateMetadata(
      parsed['name'],
      parsed['version'],
      Uri.parse(parsed['project_homepage']),
      InstallerConfig.fromJson(parsed['install']),
    );
  }

  @override
  String toString() {
    return 'TemplateMetadata{name: $name, version: $version, projectHomepage: $projectHomepage, install: $install}';
  }
}

class InstallerConfig {
  final String src;
  final bool zip;
  final Map<Platform, String> dest;

  InstallerConfig(this.src, this.zip, this.dest);

  static InstallerConfig fromJson(Map<String, dynamic> parsed) {
    return InstallerConfig(
      parsed['src'],
      parsed['zip'] ?? false,
      (parsed['destination'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(Platform.fromString(key), value as String);
      }),
    );
  }

  @override
  String toString() {
    return 'InstallerConfig{src: $src, dest: $dest}';
  }
}
