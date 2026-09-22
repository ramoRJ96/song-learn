import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFFE8A23C);
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: const Color(0xFF101418),
    ),
    scaffoldBackgroundColor: const Color(0xFF101418),
    sliderTheme: const SliderThemeData(trackHeight: 3),
  );
}
