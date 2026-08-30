import 'dart:ui';

class CyclePalette {
  final Color primary;
  final Color secondary;
  final Color light;

  const CyclePalette({
    required this.primary,
    required this.secondary,
    required this.light,
  });
}

class CycleTheme {
  static const period = CyclePalette(
    primary: Color(0xFFF07D8C),
    secondary: Color(0xFFFAD2DA),
    light: Color(0xFFFBF5F3),
  );

  static const follicular = CyclePalette(
    primary: Color(0xFFFFF57C),
    secondary: Color(0xFFFAF5B9),
    light: Color(0xFFFFF7E8),
  );

  static const ovulation = CyclePalette(
    primary: Color(0xFFB7E28E),
    secondary: Color(0xFFD8EEC4),
    light: Color(0xFFF4F8EC),
  );

  static const luteal = CyclePalette(
    primary: Color(0xFF92DCE9),
    secondary: Color(0xFFC5EBF0),
    light: Color(0xFFF3F5F5),
  );
}
