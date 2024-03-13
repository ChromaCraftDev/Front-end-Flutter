import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ColorOption {
  final Color original;
  Color color;
  final String name;
  final String description;

  ColorOption(this.original, this.name, this.description) : color = original;
}

class FontOption {
  String fontName;
  // TODO: include ttf file
  FontOption(this.fontName);
}

class Config {
  final List<ColorOption> semanticColors = [
    ColorOption(
      const Color.fromARGB(255, 30, 30, 46),
      'Base',
      'The most prevalent.\nUsually the background colour.',
    ),
    ColorOption(
      const Color.fromARGB(255, 17, 17, 27),
      'Shade',
      'Visually below the components using base colour.\nUsually used for sidebars',
    ),
    ColorOption(
      const Color.fromARGB(255, 49, 50, 68),
      'Container',
      'Visually above the components using base.\nUsually used for cards.',
    ),
    ColorOption(
      const Color.fromARGB(255, 205, 214, 244),
      'Text',
      'Forground.\nUsually used for main text, and icons.',
    ),
    ColorOption(
      const Color.fromARGB(255, 166, 173, 200),
      'Subtle',
      'Less important than "text".\nUsally used for description texts',
    ),
    ColorOption(
      const Color.fromARGB(255, 203, 166, 247),
      'Primary',
      'The focus.\nUsually used for important buttons.',
    ),
    ColorOption(
      const Color.fromARGB(255, 250, 179, 135),
      'Alternate',
      'A contracting accent used to create visual interest.',
    ),
    ColorOption(
      const Color.fromARGB(255, 243, 139, 168),
      'Error',
      'Used to indicate Error',
    ),
    ColorOption(
      const Color.fromARGB(255, 249, 226, 175),
      'Warning',
      'Used to indicate Warning',
    ),
    ColorOption(
      const Color.fromARGB(255, 166, 227, 161),
      'Success',
      'Used to indicate success.',
    ),
  ];
}
