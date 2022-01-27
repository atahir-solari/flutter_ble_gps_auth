import 'package:flutter/painting.dart';

class CustomTheme {
  static const Color purple = Color(0xff023047);
  static const Color yellow = Color(0xffffb703);
  static const Color black = Color(0xff000000);
  static const Color blue = Color(0xff219ebc);
  static const Color white = Color(0xffffffff);

  static TextStyle listTileTitleStyle = const TextStyle(
    color: purple,
    fontSize: 17,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static TextStyle listTileSubitleStyle = const TextStyle(
    color: blue,
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
}
