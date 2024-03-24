import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'storage.dart';
import 'util.dart';

class ColorOption {
  final Color _original;
  Color color;
  final String? description;

  ColorOption(Color original, [this.description])
      : _original = original,
        color = original;

  void revert() => color = _original;

  Map<String, dynamic> toJSON() {
    return {"color": color.value, "description": description};
  }

  static ColorOption fromJSON(Map<String, dynamic> json) {
    return ColorOption(Color(json["color"] as int), json["description"]);
  }
}

abstract class OptionCategory {
  Map<String, ColorOption> toMap();

  ColorOption? operator [](String name) => toMap()[name];

  void revert() => toMap().forEach((_, it) => it.revert());

  Map<String, dynamic> toJSON() {
    return toMap().map((key, value) => MapEntry(key, value.color.value));
  }
}

class SemanticColors extends OptionCategory {
  final ColorOption base;
  final ColorOption shade;
  final ColorOption container;
  final ColorOption text;
  final ColorOption subtle;
  final ColorOption primary;
  final ColorOption alternate;
  final ColorOption error;
  final ColorOption warning;
  final ColorOption success;

  SemanticColors({
    Color base = const Color(0xFF1E1E2E),
    Color shade = const Color(0xFF11111B),
    Color container = const Color(0xFF313244),
    Color text = const Color(0xFFCDD6F4),
    Color subtle = const Color(0xFFA6ADC8),
    Color primary = const Color(0xFFCBA6F7),
    Color alternate = const Color(0xFFF5C2E7),
    Color error = const Color(0xFFF38BA8),
    Color warning = const Color(0xFFFAB387),
    Color success = const Color(0xFFA6E3A1),
  })  : base = ColorOption(
            base, 'The most prevalent.\nUsually the background colour.'),
        shade = ColorOption(shade,
            'Visually below the components using base colour.\nUsually used for sidebars'),
        container = ColorOption(container,
            'Visually above the components using base.\nUsually used for cards.'),
        text = ColorOption(
            text, 'Forground.\nUsually used for main text, and icons.'),
        subtle = ColorOption(subtle,
            'Less important than "text".\nUsally used for description texts'),
        primary = ColorOption(
            primary, 'The focus.\nUsually used for important buttons.'),
        alternate = ColorOption(
            alternate, 'A contracting accent used to create visual interest.'),
        error = ColorOption(error, 'Used to indicate Error'),
        warning = ColorOption(warning, 'Used to indicate Warning'),
        success = ColorOption(success, 'Used to indicate success.');

  static SemanticColors fromJSON(Map<String, dynamic> json) {
    return SemanticColors(
      base: Color(json['base'] as int),
      shade: Color(json['shade'] as int),
      container: Color(json['container'] as int),
      text: Color(json['text'] as int),
      subtle: Color(json['subtle'] as int),
      primary: Color(json['primary'] as int),
      alternate: Color(json['alternate'] as int),
      error: Color(json['error'] as int),
      warning: Color(json['warning'] as int),
      success: Color(json['success'] as int),
    );
  }

  @override
  Map<String, ColorOption> toMap() {
    return {
      'base': base,
      'shade': shade,
      'container': container,
      'text': text,
      'subtle': subtle,
      'primary': primary,
      'alternate': alternate,
      'error': error,
      'warning': warning,
      'success': success,
    };
  }
}

class RainbowColors extends OptionCategory {
  final ColorOption red;
  final ColorOption orange;
  final ColorOption yellow;
  final ColorOption green;
  final ColorOption cyan;
  final ColorOption blue;
  final ColorOption purple;

  RainbowColors({
    Color red = const Color(0xFFF38BA8),
    Color orange = const Color(0xFFFAB387),
    Color yellow = const Color(0xFFF9E2AF),
    Color green = const Color(0xFFA6E3A1),
    Color cyan = const Color(0xFF94E2D5),
    Color blue = const Color(0xFF89B4FA),
    Color purple = const Color(0xFFCBA6F7),
  })  : red = ColorOption(red),
        orange = ColorOption(orange),
        yellow = ColorOption(yellow),
        green = ColorOption(green),
        cyan = ColorOption(cyan),
        blue = ColorOption(blue),
        purple = ColorOption(purple);
  static RainbowColors fromJSON(Map<String, dynamic> json) {
    return RainbowColors(
      red: Color(json['red'] as int),
      orange: Color(json['orange'] as int),
      yellow: Color(json['yellow'] as int),
      green: Color(json['green'] as int),
      cyan: Color(json['cyan'] as int),
      blue: Color(json['blue'] as int),
      purple: Color(json['purple'] as int),
    );
  }

  @override
  Map<String, ColorOption> toMap() {
    return {
      'red': red,
      'orange': orange,
      'yellow': yellow,
      'green': green,
      'cyan': cyan,
      'blue': blue,
      'purple': purple,
    };
  }
}

class Config {
  final SemanticColors semantic;
  final RainbowColors rainbow;

  Config({SemanticColors? semantic, RainbowColors? rainbow})
      : semantic = semantic ?? SemanticColors(),
        rainbow = rainbow ?? RainbowColors();

  static Config fromJSON(Map<String, dynamic> json) {
    return Config(
      semantic: SemanticColors.fromJSON(json['semantic']),
      rainbow: RainbowColors.fromJSON(json['rainbow']),
    );
  }

  Map<String, OptionCategory> toMap() {
    return {
      'semantic': semantic,
      'rainbow': rainbow,
    };
  }

  void revert() => toMap().forEach((_, it) => it.revert());

  Map<String, dynamic> toJSON() {
    return toMap().map((key, value) => MapEntry(key, value.toJSON()));
  }
}

var _config = Config();
Config get config => _config;

final _configFile = cacheDirectory.then((it) => File(it + "config.json"));

Future<void> saveConfig() async {
  await (await _configFile).writeAsString(jsonEncode(_config.toJSON()));
}

Future<void> loadConfig() async {
  if (!await (await _configFile).exists()) return;
  _config = Config.fromJSON(jsonDecode(await (await _configFile).readAsString())
      as Map<String, dynamic>);
}
