import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'config.dart';
import 'util.dart';

final Map<String, Color Function(Color, Iterable<String>)> _operations = {
  "smartLighten": (it, args) {
    final t = double.parse(args.first);
    final hsv = HSVColor.fromColor(it);
    if (hsv.value <= .5) {
      return hsv.withValue(hsv.value + t).toColor();
    } else {
      return hsv.withValue(hsv.value - t).toColor();
    }
  },
};

String compileTemplate(Config config, String input) {
  return input.replaceAllMapped(
    RegExp(r"\{\{\s*(\w+)\s*(.*)}\}", caseSensitive: false),
    (match) {
      final optionName = match.group(1)!;
      final option = config.semantic[optionName] ?? config.rainbow[optionName];
      if (option == null) return "invalid";
      final ops = match
          .group(2)!
          .split('|')
          .map((it) => it.trim())
          .where((it) => it.isNotEmpty)
          .map(tokenize)
          .map((tokens) =>
              (Color it) => _operations[tokens[0]]!.call(it, tokens.skip(1)));
      var modified = Color(option.color.value);
      for (final op in ops) {
        modified = op(modified);
      }
      return colorToHex(modified, toUpperCase: false, enableAlpha: false);
    },
  );
}
