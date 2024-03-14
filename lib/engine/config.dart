import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
      const Color(0xFF1E1E2E),
      'base',
      'The most prevalent.\nUsually the background colour.',
    ),
    ColorOption(
      const Color(0xFF11111B),
      'shade',
      'Visually below the components using base colour.\nUsually used for sidebars',
    ),
    ColorOption(
      const Color(0xFF313244),
      'container',
      'Visually above the components using base.\nUsually used for cards.',
    ),
    ColorOption(
      const Color(0xFFCDD6F4),
      'text',
      'Forground.\nUsually used for main text, and icons.',
    ),
    ColorOption(
      const Color(0xFFA6ADC8),
      'subtle',
      'Less important than "text".\nUsally used for description texts',
    ),
    ColorOption(
      const Color(0xFFCBA6F7),
      'primary',
      'The focus.\nUsually used for important buttons.',
    ),
    ColorOption(
      const Color(0xFFF5C2E7),
      'alternate',
      'A contracting accent used to create visual interest.',
    ),
    ColorOption(
      const Color(0xFFF38BA8),
      'error',
      'Used to indicate Error',
    ),
    ColorOption(
      const Color(0xFFFAB387),
      'warning',
      'Used to indicate Warning',
    ),
    ColorOption(
      const Color(0xFFA6E3A1),
      'success',
      'Used to indicate success.',
    ),
  ];
}
