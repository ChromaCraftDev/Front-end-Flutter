enum Platform {
  windows,
  macos,
  linux,
  invalid;

  static Platform fromString(String name) => values.firstWhere(
        (element) => element.name == name,
        orElse: () => Platform.invalid,
      );
}

class TemplateMetadata {
  final String name;
  final int version;
  final Uri projectHomepage;
  final Uri preview;
  final List<Platform> platforms;
  final InstallerConfig install;

  TemplateMetadata(
    this.name,
    this.version,
    this.projectHomepage,
    this.platforms,
    this.install,
  ) : preview = Uri.https(
            "chromacraftdev.github.io", "/templates/previews/$name.webp");

  static TemplateMetadata fromJson(Map<String, dynamic> parsed) {
    return TemplateMetadata(
      parsed['name'],
      parsed['version'],
      Uri.parse(parsed['project_homepage']),
      (parsed['platforms'] as List<dynamic>)
          .map((it) => it as String)
          .map(Platform.fromString)
          .toList(),
      InstallerConfig.fromJson(parsed['install']),
    );
  }

  @override
  String toString() {
    return 'TemplateMetadata{name: $name, version: $version, projectHomepage: $projectHomepage, platforms: $platforms, install: $install}';
  }
}

class InstallerConfig {
  final String src;
  final Map<Platform, String> dest;

  InstallerConfig(this.src, this.dest);

  static InstallerConfig fromJson(Map<String, dynamic> parsed) {
    return InstallerConfig(
      parsed['src'],
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
