import 'package:flutter/material.dart';

class CustomTheme {
  static CustomTheme _instance;

  factory CustomTheme() {
    if (_instance == null) _instance = new CustomTheme._();
    return _instance;
  }

  CustomTheme._();

  ThemeData themeDark = ThemeData.dark();

  ThemeData theme = ThemeData.light();

}
