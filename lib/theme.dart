import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomTheme {
  const CustomTheme();

  static const Color loginGradientStart = Color(0xFF555555);
  static const Color loginGradientEnd = Color(0xFF292929);
  static const Color buttonGradientStart = Color(0xFFDBBA00);
  static const Color buttonGradientEnd = Color(0xFFBDA000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color yellow = Color(0xFFFFBF00);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[loginGradientStart, loginGradientEnd],
    stops: <double>[0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
