import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  /// Access the current `ThemeData` directly
  ThemeData get theme => Theme.of(this);

  /// Access the current `TextTheme` directly
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkModelEnabled => Theme.of(this).brightness == Brightness.dark;

  /// Access the current `ColorScheme` directly
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
