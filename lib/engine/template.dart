import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'config.dart';

String template(Config config, String input) {
  var curr = input;
  for (final ColorOption(name: name, color: color) in config.semanticColors) {
    curr.replaceAll(name, color.toString());
  }
  return curr;
}
