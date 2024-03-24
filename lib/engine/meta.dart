import 'dart:io' as io;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'util.dart';

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

  static FaIcon icon(Platform it) {
    return switch (it) {
      Platform.windows => const FaIcon(FontAwesomeIcons.windows),
      Platform.macos => const FaIcon(FontAwesomeIcons.apple),
      Platform.linux => const FaIcon(FontAwesomeIcons.linux),
      Platform.invalid => const FaIcon(FontAwesomeIcons.exclamation),
    };
  }
}

class TemplateMetadata {
  final String name;
  final int version;
  final Uri projectHomepage;
  final String previewUrl;
  final List<Platform> platforms;
  final InstallerConfig install;

  TemplateMetadata(
    this.name,
    this.version,
    this.projectHomepage,
    this.platforms,
    this.install,
  ) : previewUrl =
            "https://chromacraftdev.github.io/templates/previews/$name.webp";

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
