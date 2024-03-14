import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'config.dart';

String template(Config config, String input) {
  var curr = input;
  // for (final ColorOption(name: name, color: color) in config.semanticColors) {
  curr = curr.replaceAllMapped(
    RegExp(r"\{\{\s*[c]\.(\w+)\s*(\|.*)?\}\}", caseSensitive: false),
    (match) {
      final option = config.semanticColors
          .where((it) => it.name == match.group(1)!)
          .firstOrNull;
      return option != null
          ? colorToHex(option.color, toUpperCase: false, enableAlpha: false)
          : "invalid";
    },
  );
  // }
  return curr;
}
