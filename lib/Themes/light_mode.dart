//light mode theme for the sociqal media app
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey.shade300
);
