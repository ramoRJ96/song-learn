import 'package:flutter/material.dart';

abstract final class StitchColors {
  static const bg = Color(0xFF0A0C10);
  static const surface = Color(0xFF12161C);
  static const pill = Color(0xFF1A1F28);
  static const chip = Color(0xFF252A32);
  static const amber = Color(0xFFE8A23C);
  static const amberOn = Color(0xFF1A1208);
  static const muted = Color(0xFF8B95A5);
  static const label = Color(0xFF5EC8D8);
  static const white = Color(0xFFF4F6F8);
  static const line = Color(0x14FFFFFF);
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: StitchColors.amber,
      brightness: Brightness.dark,
      surface: StitchColors.bg,
    ),
    scaffoldBackgroundColor: StitchColors.bg,
    sliderTheme: const SliderThemeData(
      trackHeight: 3,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
    ),
  );
}
