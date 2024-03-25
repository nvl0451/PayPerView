import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        background: Colors.grey.shade300,
        primary: Colors.grey.shade200,
        secondary: Colors.grey.shade700,
        inversePrimary: Colors.grey.shade900),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey.shade800, displayColor: Colors.black));

ThemeData darkMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        background: Colors.grey.shade900,
        primary: Colors.grey.shade800,
        secondary: Colors.grey.shade700,
        inversePrimary: Colors.grey.shade300),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey.shade300, displayColor: Colors.white));
