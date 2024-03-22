import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'config.dart';

final Map<String, Color Function(Color, Iterable<String>)> _operations = {
  "smartLighten": (it, args) {
    final t = double.parse(args.first);
    final hsv = HSVColor.fromColor(it);
    if (ThemeData.estimateBrightnessForColor(it) == Brightness.dark) {
      return hsv.withValue(hsv.value + t).toColor();
    } else {
      return hsv.withValue(hsv.value - t).toColor();
    }
  },
};

String compileTemplate(Config config, String input) {
  return input.replaceAllMapped(
    RegExp(r"\{\{\s*[c]\.(\w+)\s*(?:\|\s*(.*)\s*)?\}\}", caseSensitive: false),
    (match) {
      final option = (config.semanticColors + config.rainbowColors)
          .where((it) => it.name == match.group(1)!)
          .firstOrNull;
      if (option == null) return "invalid";
      final ops = match
          .groups(List.generate(match.groupCount - 2, (i) => i + 2))
          .map((it) {
        final tokens = it!.split(RegExp("\\s+"));
        return (Color it) => _operations[tokens[0]]!.call(it, tokens.skip(1));
      });
      var modified = Color(option.color.value);
      for (final op in ops) {
        modified = op(modified);
      }
      return colorToHex(modified, toUpperCase: false, enableAlpha: false);
    },
  );
}
