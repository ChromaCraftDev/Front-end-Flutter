import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'storage.dart';
import 'util.dart';

class ColorOption {
  Color original;
  Color color;
  final String name;
  final String? description;

  ColorOption(this.original, this.name, {this.description}) : color = original;

  static Map<String, dynamic> toJson(ColorOption it) {
    return {
      "color": it.color.value,
      "name": it.name,
      "description": it.description
    };
  }

  static ColorOption fromJson(Map<String, dynamic> json) {
    return ColorOption(
      Color(json["color"] as int),
      json["name"],
      description: json["description"],
    );
  }
}

class FontOption {
  String fontName;
  // TODO: include ttf file
  FontOption(this.fontName);
}

extension _OptionMap on List<ColorOption> {
  Map<String, ColorOption> _optionMap() => {for (final it in this) it.name: it};
}

class Config {
  var _semanticColors = [
    ColorOption(
      const Color(0xFF1E1E2E),
      'base',
      description: 'The most prevalent.\nUsually the background colour.',
    ),
    ColorOption(
      const Color(0xFF11111B),
      'shade',
      description:
          'Visually below the components using base colour.\nUsually used for sidebars',
    ),
    ColorOption(
      const Color(0xFF313244),
      'container',
      description:
          'Visually above the components using base.\nUsually used for cards.',
    ),
    ColorOption(
      const Color(0xFFCDD6F4),
      'text',
      description: 'Forground.\nUsually used for main text, and icons.',
    ),
    ColorOption(
      const Color(0xFFA6ADC8),
      'subtle',
      description:
          'Less important than "text".\nUsally used for description texts',
    ),
    ColorOption(
      const Color(0xFFCBA6F7),
      'primary',
      description: 'The focus.\nUsually used for important buttons.',
    ),
    ColorOption(
      const Color(0xFFF5C2E7),
      'alternate',
      description: 'A contracting accent used to create visual interest.',
    ),
    ColorOption(
      const Color(0xFFF38BA8),
      'error',
      description: 'Used to indicate Error',
    ),
    ColorOption(
      const Color(0xFFFAB387),
      'warning',
      description: 'Used to indicate Warning',
    ),
    ColorOption(
      const Color(0xFFA6E3A1),
      'success',
      description: 'Used to indicate success.',
    ),
  ];
  List<ColorOption> get semanticColors => _semanticColors;
  var _rainbowColors = [
    ColorOption(const Color(0xFFF38BA8), 'red'),
    ColorOption(const Color(0xFFFAB387), 'orange'),
    ColorOption(const Color(0xFFF9E2AF), 'yellow'),
    ColorOption(const Color(0xFFA6E3A1), 'green'),
    ColorOption(const Color(0xFF94E2D5), 'cyan'),
    ColorOption(const Color(0xFF89B4FA), 'blue'),
    ColorOption(const Color(0xFFCBA6F7), 'purple'),
  ];
  List<ColorOption> get rainbowColors => _rainbowColors;
}

final config = Config();

final _configFile = cacheDirectory.then((it) => File(it + "color_config.json"));

Future<void> saveConfig() async {
  final json = {
    "semantic": config.semanticColors.map(ColorOption.toJson).toList(),
    "rainbow": config.rainbowColors.map(ColorOption.toJson).toList(),
  };
  await (await _configFile).writeAsString(jsonEncode(json));
}

Future<void> loadConfig() async {
  if (!await (await _configFile).exists()) return;
  final json = jsonDecode(await (await _configFile).readAsString())
      as Map<String, dynamic>;
  config._semanticColors = (json["semantic"] as List<dynamic>)
      .map((it) => ColorOption.fromJson(it as Map<String, dynamic>))
      .toList(growable: false);
  config._rainbowColors = (json["rainbow"] as List<dynamic>)
      .map((it) => ColorOption.fromJson(it as Map<String, dynamic>))
      .toList(growable: false);
}
