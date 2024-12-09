import 'package:flutter/material.dart';

class AppColors {
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF000000);
  static const Color gray = Color(0xFF7F7F7F);
  static const Color green = Color(0xFFE0FFE0);
  static const Color blue = Color(0xFFE0ECFF);
  static const Color violet = Color(0xFFE9E0FF);
  static const Color red = Color(0xFFFFE0D7);
  static const Color yellow = Color(0xFFFFF7D8);
  static const Color lightBlue = Color(0xFFB5FFF2);
  static const Color pink = Color(0xFFFFADFC);
  static const Color orange = Color(0xFFFFE0A2);
  static const Color lightGray = Color(0xFFB4B4B4);
  static const Color darkGray = Color(0xFF515151);
  static const Color extraLightGray = Color(0xFFE1E1E1);
  static const Color extraDarkGray = Color(0xFF272727);
  static const Color lavenderGray = Color(0xFFCEBCCB);
  static const Color brown = Color(0xFFE4BD9F);

  Map<String, dynamic> _toMap() {
    return {
      'surface': surface,
      'onSurface': onSurface,
      'primary': primary,
      'gray': gray,
      'green': green,
      'blue': blue,
      'violet': violet,
      'red': red,
      'yellow': yellow,
      'lightBlue': lightBlue,
      'pink': pink,
      'orange': orange,
      'lightGray': lightGray,
      'darkGray': darkGray,
      'extraLightGray': extraLightGray,
      'extraDarkGray': extraDarkGray,
      'lavenderGray': lavenderGray,
      'brown': brown,
    };
  }

  dynamic get(String? propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
  }
}
